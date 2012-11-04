//
//  LLQQLoginInfo.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-4.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLQQLoginInfo : NSObject
{
    long uin;
    long cip; 
    NSString *user;
    NSString *password;
    NSString *status;
    NSString *verifyCode;
    NSString *verifyCodeKey;
    
    NSString *ptwebqq;
    NSString *clientid;
    NSString *psessionid;
    NSString *vfwebqq;
}

@property (nonatomic, assign) long uin;
@property (nonatomic, assign) long cip;
@property (nonatomic, copy) NSString *user;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *verifyCode;
@property (nonatomic, copy) NSString *verifyCodeKey;
@property (nonatomic, copy) NSString *ptwebqq;
@property (nonatomic, copy) NSString *clientid;
@property (nonatomic, copy) NSString *psessionid;
@property (nonatomic, copy) NSString *vfwebqq;

@end
