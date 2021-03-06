//
//  LLFriendsController.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLFriendsController.h"
#import "LLQQGlobalCache.h"
#import "LLNotificationCenter.h"
#import "LLQQChattingViewController.h"

@interface LLFriendsController ()
@end

@implementation LLFriendsController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _segment = nil;
        _request = nil;
        _usersTree = [[LLGlobalCache getGlobalCache] getTreeOfUsers];
        _categoriesDic = nil;
        _onlineUsersList = nil;
        
        [LLNotificationCenter add:self
                         selector:@selector(loginNotificationHandler:)
                 notificationType:kNotificationTypeLoginSuccess];
        

    }
    return self;
}

- (void)dealloc
{

    [super dealloc];
}

- (void)viewDidLoad
{        
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [_segment release];
    _segment = nil;
    
    [_request release];
    _request = nil;
    
    [_usersTree release];
    
    [_categoriesDic release];
    _categoriesDic = nil;
    
    [_onlineUsersList release];
    _onlineUsersList = nil;
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -login callback
/* called when login success, gets the all friends info*/
-(void)loginNotificationHandler:(NSNotification *)nofi
{
    DEBUG_LOG_WITH_FORMAT(@"self.navication con %@", self.navigationController);
    
    _request = [[LLQQCommonRequest alloc] initWithBox:[[LLGlobalCache getGlobalCache] getMoonBox] delegate:self];
    [_request getAllFriends];
    [_request getAllOnlineFriends];
}

#pragma mark  LLQQCommonRequestDelegate
- (void)LLQQCommonRequestNotify:(LLQQCommonRequestType)requestType isOK:(BOOL)success info:(id)info
{
    if (success == NO) {
        NSString *errorMsg = nil;
        if ([info isKindOfClass:[NSError class]]) {
            errorMsg = [NSString stringWithFormat:@"%@", info];
        } else {
            errorMsg = (NSString *)errorMsg;
        } 
        [[[[iToast makeText:errorMsg] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        return;
    }    
    
    switch (requestType) {
        case kQQRequestGetAllFriends:
        {
            _categoriesDic = [(NSDictionary *)info retain];
            
           [[[[iToast makeText:@"All friends loaded"] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
            break;
        case kQQRequestGetAllOnlineFriends:
        {
            _onlineUsersList = [(LLQQOnlineUsersList*)info retain];
            [[[[iToast makeText:@"online friends loaded"] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        }
            break;
        case kQQRequestGetUserSignature:
        {
            NSDictionary *signatureDic = (NSDictionary*)info;
            unsigned long uin = [[signatureDic objectForKey:@"uin"] longValue];
            NSString *signature = [signatureDic objectForKey:@"signature"];
            [[_usersTree getUser:uin] setSignature:signature];
            
            /* 局部刷新*/
            
            NSIndexPath *indexPath = [_usersTree getUserIndexPath:uin];   
            NSLog(@"indexPath %@, (%d, %d)", indexPath, indexPath.section, indexPath.row);
            SDGroupCell *groupCell = (SDGroupCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.section inSection:0]];            
            if (groupCell) {
                SDSubCell *subCell = (SDSubCell *)[groupCell.subTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
                
                if (subCell) {
                    [groupCell.subTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                } else {
                    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.section inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                }
                
            }            
        }
            break;
        default:
            break;
    }
    
    /* 只有完成了所有用户和在线用户信息（不包括签名和头像图片）才加载整个table页面*/
    if (_categoriesDic && _onlineUsersList) {
        _usersTree = [[LLQQUsersTree alloc] initWithCategoriesDic:_categoriesDic
                                                  onlineUsersList:_onlineUsersList];
        
        [[LLGlobalCache getGlobalCache] saveTreeOfUsers:_usersTree];
        [self.tableView reloadData];
    }
}

#pragma mark SDNestedTableDelegate
- (void) mainTable:(UITableView *)mainTable item:(SDGroupCell *)item didExpanded:(BOOL)isExpanded
{
    /* load the nickname and face imgs */
        
    if (isExpanded == YES) {
        NSArray *users = [_usersTree getUsersListOfSection:item.cellIndexPath.row];
        LLQQUser *aUser = [users lastObject];
        
        if (aUser.signature == nil) {    
            NSMutableArray *usersUins = [[NSMutableArray alloc] init];
            for (LLQQUser *user in users) {
                [usersUins addObject:[NSNumber numberWithLong:user.uin]];
            }
            [_request getUsersSignatures:usersUins];            
        }
    }
}

- (void) mainItem:(SDGroupCell *)item subItemDidClicked:(SDSelectableCell *)subItem
{
    LLQQUser *user = [_usersTree getUserAtIndexPath:[NSIndexPath indexPathForRow:subItem.cellIndexPath.row 
                                                                       inSection:item.cellIndexPath.row]];
    long friendUin = user.uin;
    /* push to the chating view */
    [[self navigationController] pushViewController:[[[LLQQChattingViewController alloc] 
                                                      initWitFriendUin:friendUin] autorelease] 
                                           animated:YES];
}

/* 一层,分组数目*/
- (NSInteger) mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
        return _usersTree == nil? 0 : [_usersTree getCategoriesCount];
    else {
        return 0;
    }
}

/*二层，各分组内的用户数目*/
- (NSInteger) mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    return [_usersTree getUsersCountAtSection:indexPath.row];
}

/*显示一级元素前设置分组的标题*/
- (SDGroupCell *) mainTable:(UITableView *)mainTable prepareItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLQQCategory *category = [_usersTree getCategoryAtSection:indexPath.row];
    [item.titleLabel setText:[NSString stringWithFormat:@"%@ [%ld/%ld]", category.name, 0, [_usersTree getUsersCountAtSection:indexPath.row]]];
    return item;
}

/*显示二级元素前,设置用户cell的名字、签名、图片*/
- (SDSubCell *) mainItem:(SDGroupCell *)item prepareSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LLQQUser *user = [_usersTree getUserAtIndexPath:[NSIndexPath indexPathForRow:subItem.cellIndexPath.row 
                                                                       inSection:item.cellIndexPath.row]];
    
    if (user.markname == nil) {
        [[(LLQQUserCell *)subItem nameLabel] setText:user.nickname];
    } else {
        [[(LLQQUserCell *)subItem nameLabel] setText:[NSString stringWithFormat:@"%@ (%@)", user.markname, user.nickname]];
    }
    [[(LLQQUserCell *)subItem signatureLabel] setText:user.signature];
    
    /*added onece*/
    if ([[(LLQQUserCell*)subItem faceImgView] imageURL] == nil) {
        //[[(LLQQUserCell *)subItem faceImgView] setImageURL:[_request getFaceOfUserURL:user.uin isMe:NO]];
    }
    return subItem;
}
@end
