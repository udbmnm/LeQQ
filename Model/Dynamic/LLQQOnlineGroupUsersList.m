//
//  LLQQOnlineGroupUsersList.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-16.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQOnlineGroupUsersList.h"

@implementation LLQQOnlineGroupUsersList
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
@end
