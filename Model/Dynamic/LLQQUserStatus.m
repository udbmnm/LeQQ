//
//  LLQQUserStatus.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-15.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUserStatus.h"

@implementation LLQQUserStatus
@synthesize uin, status,clientType;

- (id)init
{
    if (self = [super init]) {
        uin = 0;
        status = kQQUserStatusNull;
        clientType = kQQClientTypeNull;
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

@end
