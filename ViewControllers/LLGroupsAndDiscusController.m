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
 
}

- (NSInteger) mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

- (SDGroupCell *) mainTable:(UITableView *)mainTable prepareItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (SDSubCell *) mainItem:(SDGroupCell *)item prepareSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
