//
//  LLQQLogin.m
//  LeQQ
//
//  Created by Xiangle le on 12-10-31.
//  Copyright (c) 2012年 GUET/Wondershare. All rights reserved.
//

#import "LLQQLogin.h"
#import "LLDebug.h"
#import "ASIHTTPRequest.h"

@implementation LLQQLogin

- (id)initWithUser:(NSString *)user 
          password:(NSString *)password 
            status:(NSString *)status 
          delegate:(id<LLQQLoginDelegate>)delegate
{
    if (self = [super init]) {
        _user = [user copy];
        _password = [password copy];
        _status = [status copy];
        _delegate = delegate;
        _currentProgress = LLQQLOGIN_PROGRESS_NOT_START;
    }
    return self;
}

- (void)dealloc
{
    [_user release];
    [_password release];
    [_status release];
    [super dealloc];
}

- (void)startAsynchronous
{
    [self stepProgressOneByOne];
}

- (void)stepProgressOneByOne
{
    switch (_currentProgress) {
        case LLQQLOGIN_PROGRESS_NOT_START:
            [self checkTheVerifyCode];
            break;        
        case LLQQLOGIN_PROGRESS_CHECK_VERIFY_CODE:    
            [self getTheVerifyCodeImage];
            break;
        case LLQQLOGIN_PROGRESS_GET_VERIFY_IMAGE:
            [self login];
            break;
        case LLQQLOGIN_PROGRESS_LOGIN:
            [self setStatus];
        default:
            break;
    }
}

- (void)checkTheVerifyCode
{
    _currentProgress = LLQQLOGIN_PROGRESS_CHECK_VERIFY_CODE;
    
    static NSString *urlPattern = @"http://check.ptlogin2.qq.com/check?uin=$(account)&appid=1003903&r=$(now)";
    
    NSString *now =[NSString stringWithFormat:@"%ld", 
                    [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] longValue]];
    NSString *urlString = [[urlPattern stringByReplacingOccurrencesOfString:@"$(account)" withString:_user]
                           stringByReplacingOccurrencesOfString:@"$(now)" withString:now];                                      
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setTimeOutSeconds: 2.0];
    
    [request setFailedBlock:^(void) {
        NSError *error = [request error];
        [_delegate LLQQLoginProgressNoti:LLQQLOGIN_PROGRESS_CHECK_VERIFY_CODE failOrSuccess:NO info:error];
    }];
    
    [request setCompletionBlock:^(void){
        [_delegate LLQQLoginProgressNoti:LLQQLOGIN_PROGRESS_CHECK_VERIFY_CODE failOrSuccess:YES info:nil];  
        NSString *response = [request responseString];
        NSLog(@"---->\n%@", response);
        
        [self stepProgressOneByOne];
    }];
    
    [request startAsynchronous];
}

- (void)getTheVerifyCodeImage
{
    
    
    
}

- (void)login
{
    
}

- (void)setStatus
{
    
}

- (void)getPassportDic
{
    
}




@end
