//
//  LLQQUser.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUser.h"

@implementation LLQQUser
@synthesize qqNum, categoryIndex, nickname, signature, userDetail;

-(id)init
{
    if (self = [super init]) {
        qqNum = 0;
        categoryIndex = -1;
        nickname = nil;
        signature = nil;
        userDetail = nil;
        
    }
    return self;
}

-(void)dealloc
{
    self.nickname = nil;
    self.signature = nil;
    self.userDetail = nil;
    [super dealloc];
}

@end
