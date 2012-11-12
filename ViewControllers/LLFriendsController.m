//
//  LLFriendsController.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLFriendsController.h"
#import "LLGlobalCache.h"

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
- (void)LLQQCommonRequestNotify:(LLQQCommonRequestType)requestType info:(id)info
{
    
}
@end
