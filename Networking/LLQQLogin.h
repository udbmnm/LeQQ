//
//  LLQQLogin.h
//  LeQQ
//
//  Created by Xiangle le on 12-10-31.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum 
{
    LLQQLOGIN_PROGRESS_NOT_START = 0,
    LLQQLOGIN_PROGRESS_CHECK_VERIFY_CODE = 1,
    LLQQLOGIN_PROGRESS_GET_VERIFY_IMAGE = 2,
    LLQQLOGIN_PROGRESS_LOGIN = 3,
    LLQQLOGIN_PROGRESS_SET_STATUS =4,
    LLQQLOGIN_PROGRESS_COMPLETED = 5
}LLQQLoginProgress;


@protocol LLQQLoginDelegate <NSObject>
@required
/*
 * When one progress in LLQQLogin completed, this methd will notify the receiver.
 * the progress 2 may not be exist, since sometimes you not need to input the verify code.
 * When error, the progress of logining is break, else the 5 progress will be run one by one.
 * 
 * 'progress' will be current login progress, when the progress is 2, the info is the UIImage instance 
 * showing the verify code, the receiver must collect the user input and then return the verifycode
 * in the delegate method.
 * 
 * When error, retcode is NO, else YES is return. 
 * When error, info is the type NSError/NSString indicating the error.
 *
 * When the progress is 5, the 'info' is a dictionary, keys are the 
 * @"uin", @"cip", @"user", @"password", @"status", @"verifyCode", @"verifyCodeKey", @"ptwebqq",
 * @"clientid", @"psessionid", @"vfwebqq"
 * 
 */
- (id)LLQQLoginProgressNoti:(LLQQLoginProgress)progress failOrSuccess:(BOOL)retcode info:(id)info;
@end


@interface LLQQLogin : NSObject
{
    long _uin;
    long _cip;
    NSString *_user;
    NSString *_password;
    NSString *_status;
    LLQQLoginProgress _currentProgress;
    id<LLQQLoginDelegate> _delegate;
    NSString *_verifyCode;
    NSString *_verifyCodeKey;
    
    NSString *_ptwebqq;
    NSString *_clientid;
    NSString *_psessionid;
    NSString *_vfwebqq;
    
}

- (id)initWithUser:(NSString *)user 
          password:(NSString *)password 
            status:(NSString *)status 
          delegate:(id<LLQQLoginDelegate>)delegate;


- (void)startAsynchronous;

@end
