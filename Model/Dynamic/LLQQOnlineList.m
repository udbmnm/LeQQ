//
//  LLQQOnlineList.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-15.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUser.h"
#import "LLQQOnlineList.h"

@implementation LLQQOnlineList

- (id)init
{
    if (self = [super init]) {
        _onlineList = nil;
    }
    return self; 
}

- (void)dealloc
{
    [_onlineList release];
    [super dealloc];
}

- (void)add:(LLQQUserStatus*)aUserStatus
{
    [_onlineList addObject:aUserStatus];
}

- (NSArray *)getOnlineStatusListOfCategory:(LLQQCategory *)category
{
    NSMutableArray *statusList = [NSMutableArray array];
    
    for (LLQQUserStatus *status in _onlineList) {
        LLQQUser *user = [[category usersMap] objectForKey:[NSString stringWithFormat:@"%ld", status.uin]];
        if (user) {
            [statusList addObject:status];
        }
    }
    return statusList;
}

@end
