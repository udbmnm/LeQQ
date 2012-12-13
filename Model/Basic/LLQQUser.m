//
//  LLQQUser.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUser.h"

@implementation LLQQUser
@synthesize uin, qqNum, categoryIndex, nickname, signature, qqLevel, nextLeveRemainDays, faceImg, face, isVIP, vipLevel, markname;

-(id)init
{
    if (self = [super init]) {
        uin = (long)-1;
        qqNum = (long)-1;
        categoryIndex = (long)-1;
        nickname = nil;
        markname = nil;
        
        faceImg = nil;        
        face = (long)-1;
        signature = nil;
        qqLevel = (long)-1;
        nextLeveRemainDays = (long)-1;        
        isVIP = NO; 
        vipLevel = (long)-1;
        userDetail = nil;
    }
    return self;
}

-(void)dealloc
{
    self.faceImg = nil;
    self.nickname = nil;
    self.markname = nil;
    self.signature = nil;
    
    [userDetail release];
    [super dealloc];
}

-(LLQQUser *)mergedWith:(LLQQUser *)anotherUser
{
    /* update the user info */
    /* .... */
    
    return self;
}

- (LLQQUserDetail *)userDetail
{
    if (userDetail == nil) {
        /* alloc when used */
        userDetail = [[LLQQUserDetail alloc] init];
    }
    return userDetail;
}
- (void)setUserDetail:(LLQQUserDetail *)aUserDetail
{
    [aUserDetail retain];
    
    if (userDetail) {
        [userDetail release];
    }
    
    userDetail = aUserDetail;
}
@end
