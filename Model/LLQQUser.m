//
//  LLQQUser.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-11.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQUser.h"

@implementation LLQQUser
@synthesize uin, qqNum, categoryIndex, nickname, signature, qqLevel, nextLeveRemainDays, userDetail, status, faceImg;

-(id)init
{
    if (self = [super init]) {
        uin = 0;
        qqNum = 0;
        categoryIndex = -1;
        status = nil;
        faceImg = nil;        
        signature = nil;
        nickname = nil;
        qqLevel = -1;
        nextLeveRemainDays = -1;        
        userDetail = nil;        
    }
    return self;
}

-(void)dealloc
{
    self.status = nil;
    self.faceImg = nil;
    self.nickname = nil;
    self.signature = nil;
    self.userDetail = nil;
    [super dealloc];
}
@end
