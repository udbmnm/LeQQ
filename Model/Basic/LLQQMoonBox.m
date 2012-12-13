//
//  LLQQMoonBox.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-4.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQMoonBox.h"

@implementation LLQQMoonBox
@synthesize user, password, uin, cip, index, port, status, verifyCode, skey, ptwebqq, vfwebqq, clientid, psessionid, verifyCodeKey;


-(id)init
{
    if (self = [super init]) {
        user = nil;
        password = nil;
        uin = (long)-1;
        cip = (long)-1;
        index = (long)-1;
        port = (long)-1;
        status = nil;
        verifyCodeKey = nil;
        skey = nil;
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
    self.skey = nil;
    self.ptwebqq = nil;
    self.psessionid = nil;
    self.vfwebqq = nil;
    self.clientid = nil;
    [super dealloc];
}

@end
