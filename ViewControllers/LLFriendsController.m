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
    
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [_segment release];
    _segment = nil;
    
    [_request release];
    _request = nil;
    
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
            NSDictionary *categoriesDic = (NSDictionary *)info;
            NSLog(@"%@", categoriesDic);
        }
        break;
            
        default:
            break;
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
        return 4;
    else {
        return 0;
    }
}

- (NSInteger) mainTable:(UITableView *)mainTable numberOfSubItemsforItem:(SDGroupCell *)item atIndexPath:(NSIndexPath *)indexPath
{
    return 2;
}

- (SDGroupCell *) mainTable:(UITableView *)mainTable prepareItem:(SDGroupCell *)item forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return item;
}

- (SDSubCell *) mainItem:(SDGroupCell *)item prepareSubItem:(SDSubCell *)subItem forRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* 默认头像*/
    return subItem;
}
@end
