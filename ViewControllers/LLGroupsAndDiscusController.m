//
//  LLGroupsAndDiscusController.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-21.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLGroupsAndDiscusController.h"
#import "LLQQHelper.h"

@interface LLGroupsAndDiscusController ()

@end

@implementation LLGroupsAndDiscusController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _groupsDic = nil;
    _discusDic = nil;
    _dataTree  = [[LLGlobalCache getGlobalCache] getTreeOfGroupsAndDiscus];
    
    _request = [[LLQQCommonRequest alloc] initWithBox:[[LLGlobalCache getGlobalCache] getMoonBox]
                                             delegate:self];
    [_request getAllGroups];
    [_request getAllDiscus];
}

- (void)viewDidUnload
{
    [_groupsDic release];
    [_discusDic release];
    [_dataTree release];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - callback of common request 
- (void)LLQQCommonRequestNotify:(LLQQCommonRequestType)requestType isOK:(BOOL)success info:(id)info
{
    if (!success) {
        return;
    }    
    
    switch (requestType) {
        case kQQRequestGetAllGroups:
            _groupsDic = [(NSDictionary *)info retain];
            break;
        case kQQRequestGetAllDiscus:
            _discusDic = [(NSDictionary *)info retain];
        default:
            break;
    }
    
    if (_groupsDic != nil && _discusDic != nil) {
        _dataTree = [[LLQQGroupsAndDiscusTree alloc] initWithGroupsDic:_groupsDic discusDic:_discusDic];
        [[LLGlobalCache getGlobalCache] saveTreeOfGroupsAndDiscus:_dataTree];
        [self.tableView reloadData];
    }
    
    
}

#pragma mark - SDNestedTableDelegate methods
- (void) mainTable:(UITableView *)mainTable item:(SDGroupCell *)item didExpanded:(BOOL)isExpanded
{
    
}

- (void) mainItem:(SDGroupCell *)item subItemDidClicked:(SDSelectableCell *)subItem
{
    
}

- (NSInteger) mainTable:(UITableView *)mainTable numberOfItemsInSection:(NSInteger)section
{
    if (section != 0 || _dataTree == nil) return 0;
        
    return [_dataTree getSectionCount];
}

- (NSInteger) mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    if (_dataTree == nil) return 0;
    NSLog(@"count:%d", [_dataTree getMembersCountAtSection:item.cellIndexPath.row]);
    
    return [_dataTree getMembersCountAtSection:item.cellIndexPath.row];
}

- (SDGroupCell *) mainTable:(UITableView *)mainTable prepareItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [item.titleLabel setText:[_dataTree getTitleForSection:item.cellIndexPath.row]];
    return item;
}

- (SDSubCell *) mainItem:(SDGroupCell *)item prepareSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *members = [_dataTree getListOfSection:item.cellIndexPath.row];
    id member = [members objectAtIndex:subItem.cellIndexPath.row];
    
    if ([member isKindOfClass:[LLQQGroup class]]) {
        [[(LLQQUserCell *)subItem nameLabel] setText:[(LLQQGroup *)member name]];
        [[(LLQQUserCell *)subItem faceImgView] setImage:[UIImage imageNamed:@"Group40X40"]];
    } else {
        [[(LLQQUserCell *)subItem nameLabel] setText:[(LLQQDiscus *)member name]];
        [[(LLQQUserCell *)subItem faceImgView] setImage:[UIImage imageNamed:@"Discuss40X40"]];
    }
    
    return subItem;
    
}


@end
