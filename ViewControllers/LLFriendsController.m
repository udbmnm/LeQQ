//
//  LLFriendsController.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLFriendsController.h"
#import "LLQQGlobalCache.h"

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
        _usersTree = nil;
        _categoriesDic = nil;
        _onlineUsersList = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    _segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"好友", @"群", @"最近联系", nil]];
    [_segment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [_segment addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventValueChanged];
    _segment.selectedSegmentIndex = 0;

    self.navigationItem.titleView = _segment;
    [_segment release];    
    
    _request = [[LLQQCommonRequest alloc] initWithBox:[[LLGlobalCache getGlobalCache] getMoonBox] delegate:self];
    [_request getAllFriends];
    [_request getAllOnlineFriends];
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [_segment release];
    _segment = nil;
    
    [_request release];
    _request = nil;
    
    [_usersTree release];
    _usersTree = nil;
    
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

#pragma mark segment callback
- (void)segmentClicked:(id)sender
{
    NSLog(@"sender's index:%d", [(UISegmentedControl *)sender selectedSegmentIndex]);
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
        default:
            break;
    }
    
    if (_categoriesDic && _onlineUsersList) {
        _usersTree = [[LLQQUsersTree alloc] initWithCategoriesDic:_categoriesDic
                                                  onlineUsersList:_onlineUsersList];
        [self.tableView reloadData];
    }
}

#pragma mark - SDNestedTableDelegate
- (void) mainTable:(UITableView *)mainTable item:(SDGroupCell *)item didExpanded:(BOOL)isExpanded
{
    
}

- (void) mainItem:(SDGroupCell *)item subItemDidClicked:(SDSelectableCell *)subItem
{
    
}

- (NSInteger) mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    if (section == 0)
        return _usersTree == nil? 0 : [_usersTree getCategoriesCount];
    else {
        return 0;
    }
}

- (NSInteger) mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    LLQQCategory *category = [[_usersTree getCategories] objectAtIndex:indexPath.row];
    return category.usersMap.count;
}

- (SDGroupCell *) mainTable:(UITableView *)mainTable prepareItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLQQCategory *category = [[_usersTree getCategories] objectAtIndex:indexPath.row];
    [item.titleLabel setText:category.name];
    return item;
}

- (SDSubCell *) mainItem:(SDGroupCell *)item prepareSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 默认头像*/
    LLQQCategory *category = [[_usersTree getCategories] objectAtIndex:item.cellIndexPath.row];
    NSArray *userListInCategory = [_usersTree getUsersListOfCategory:category.index];
    LLQQUser *user = (LLQQUser*)[userListInCategory objectAtIndex:indexPath.row];
    
    [[(LLQQUserCell *)subItem nameLabel] setText:user.nickname];
    [[(LLQQUserCell *)subItem signatureLabel] setText:user.signature];
    return subItem;
}
@end
