//
//  LLQQUser.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUser.h"

@implementation LLQQUser
@synthesize uin, qqNum, categoryIndex, nickname, signature, qqLevel, nextLeveRemainDays, userDetail, faceImg, face, isVIP, vipLevel, markname;

-(id)init
{
    if (self = [super init]) {
        uin = 0;
        qqNum = 0;
        categoryIndex = -1;
        nickname = nil;
        markname = nil;
        
        faceImg = nil;        
        face = 0;
        signature = nil;
        qqLevel = -1;
        nextLeveRemainDays = -1;        
        isVIP = NO; 
        vipLevel = 0;
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
    self.userDetail = nil;
    [super dealloc];
}

-(LLQQUser *)mergedWith:(LLQQUser *)anotherUser
{
    /* update the user info */
    /* .... */
    
    return self;
}
@end
