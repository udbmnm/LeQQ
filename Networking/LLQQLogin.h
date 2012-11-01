//
//  LLQQLogin.h
//  LeQQ
//
//  Created by Xiangle le on 12-10-31.
//  Copyright (c) 2012年 GUET/Wondershare. All rights reserved.
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
- (void)LLQQLoginProgressNoti:(LLQQLoginProgress)progress failOrSuccess:(BOOL)retcode info:(id)info;
@end


@interface LLQQLogin : NSObject
{
    NSString *_user;
    NSString *_password;
    NSString *_status;
    LLQQLoginProgress _currentProgress;
    id<LLQQLoginDelegate> _delegate;
    NSString *_verifyCode;
    NSString *_verifyCodeKey;
}

- (id)initWithUser:(NSString *)user 
          password:(NSString *)password 
            status:(NSString *)status 
          delegate:(id<LLQQLoginDelegate>)delegate;


- (void)startAsynchronous;


/* 
 * Theck the verify code, if fail, return NSError,
 * if success, return the verify code, 
 * or return nil, you must request an image presenting the verify 
 * code.
 */
//- (void)checkTheVerifyCode;

/* 
 * request the image for verify code
 */
//- (void)getTheVerifyCodeImage;

//- (BOOL)login;

//- (BOOL)setStatus;


/* 
 * the passport includes the 
 * ptwebqq
 * skey
 * clientid
 * cip
 * uin
 * psessionid
 * vfwebqq
 */
//- (NSDictionary *)getPassportDic;
@end
