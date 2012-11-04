//
//  LLQQLoginInfo.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-4.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQLoginInfo.h"

@implementation LLQQLoginInfo
@synthesize user, password, uin, cip, status, verifyCode, ptwebqq, vfwebqq, clientid, psessionid, verifyCodeKey;


-(id)init
{
    if (self = [super init]) {
        user = nil;
        password = nil;
        uin = 0;
        cip = 0;
        status = nil;
        verifyCodeKey = nil;
        ptwebqq = nil;
        vfwebqq = nil;
        clientid = nil;
        psessionid = nil;
        verifyCode = nil;
    }
    return self;
}

-(void)dealloc
{
    self.user = nil;
    self.password = nil;
    self.status = nil;
    self.verifyCode = nil;
    self.verifyCodeKey = nil;
    self.ptwebqq = nil;
    self.psessionid = nil;
    self.vfwebqq = nil;
    self.clientid = nil;
    [super dealloc];
}

@end
