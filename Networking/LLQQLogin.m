 //
//  LLQQLogin.m
//  LeQQ
//
//  Created by Xiangle le on 12-10-31.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQLogin.h"
#import "LLDebug.h"
#import "LLQQEncription.h"
#import "LLQQLoginInfo.h"
#import "ASIHTTPRequest+ASIHTTPRequest_LLHelper.h"


@implementation LLQQLogin

- (id)init
{
    if (self = [super init]) {
        [self initWithUser:nil password:nil status:nil delegate:nil];
    }
    return self;
}

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
        _verifyCode = nil;
        _verifyCodeKey = nil;
        _ptwebqq = nil;
        _clientid = @"73937879";
        _uin = 0;
        _cip = 0;
        _psessionid = nil;
        _vfwebqq = nil;
        _skey = nil;
        _cookies = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_user release];
    [_password release];
    [_status release];
    [_verifyCode release];
    [_verifyCodeKey release];
    [_ptwebqq release];
    [_clientid release];
    [_psessionid release];
    [_vfwebqq release];
    [_skey release];
    [_cookies release];
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

- (void)updateCookies:(NSArray *)cookies
{
    for (NSHTTPCookie* cookie in cookies) {
        [_cookies setObject:cookie forKey:[cookie name]];
    }
}

- (void)checkTheVerifyCode
{
    _currentProgress = LLQQLOGIN_PROGRESS_CHECK_VERIFY_CODE;
    
    static NSString *urlPattern = @"http://check.ptlogin2.qq.com/check?uin=$(account)&appid=1003903&r=$(now)";
    
    NSString *now =[self randomFloatValue];
    NSString *urlString = [[urlPattern stringByReplacingOccurrencesOfString:@"$(account)" withString:_user]
                           stringByReplacingOccurrencesOfString:@"$(now)" withString:now];                                      
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    //[request setUseCookiePersistence:NO];
    
    [request setFailedBlock:^(void) {
        NSError *error = [request error];
        [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:NO info:error];
    }];
    
    [request setCompletionBlock:^(void){
        [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:YES info:nil];  
        
        NSString *response = [[request responseString] retain];
        NSString *regexString = @"ptui_checkVC\\('(\\d+)','(.+)','(.+)'\\)";
        NSString *vCode = [response stringByMatching:regexString capture:2L];
        NSString *vCodeKey = [response stringByMatching:regexString capture:3L];
        
        //[self updateCookies: [request responseCookies]];

            _verifyCodeKey = [vCodeKey retain];
        
            if ([vCode rangeOfString:@"!"].location == 0) {
                _verifyCode = [vCode retain];
                /* not to get the image for verify code, so skip the progress */
                _currentProgress = LLQQLOGIN_PROGRESS_GET_VERIFY_IMAGE;
            }
            
            [self stepProgressOneByOne];
    }];
    
    [request startAsynchronous];
}


- (void)getTheVerifyCodeImage
{
    _currentProgress = LLQQLOGIN_PROGRESS_GET_VERIFY_IMAGE;
    static NSString *urlPattern = @"http://captcha.qq.com/getimage?aid=1003903&r=$(now)&uin=$(account)";
    
    NSString *urlString = [urlPattern stringByReplacingOccurrencesOfString:@"$(now)" withString:[self randomFloatValue]];
    urlString = [urlString stringByReplacingOccurrencesOfString:@"$(account)" withString:_user];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    //[request setUseCookiePersistence:NO];
    [request setRequestCookies:[NSMutableArray arrayWithArray:[_cookies allValues]]];
    
    [request setFailedBlock:^(void){
        NSError *error = [request error];
        [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:NO info:error];
    }];
    
    [request setCompletionBlock:^(void) {
        //[self updateCookies:[request responseCookies]];
        UIImage *image = [UIImage imageWithData:[request responseData]];        
        /* 
         * pass the image to the receiver,the user has the responsibility to pass the verify code back 
         * vi the -(void)restartWithVerityCode:(NSString*)code 
         */
        [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:YES info:image];
    }];
    
    [request startAsynchronous];
}

- (void)login
{
    _currentProgress = LLQQLOGIN_PROGRESS_LOGIN;
    
    static NSString *urlPattern = @"http://ptlogin2.qq.com/login?u=$(account)&p=$(password)&verifycode=$(VCode)&webqq_type=10&remember_uin=1&login2qq=1&aid=1003903&u1=$(loginurl)&h=1&ptredirect=0&ptlang=2052&from_ui=1&pttype=1&dumy=&fp=loginerroralert&action=7-24-1937704&mibao_css=m_webqq&t=1&g=1";
    static NSString *loginURL = @"http%3A%2F%2Fweb3.qq.com%2Floginproxy.html%3Flogin2qq%3D1%26webqq_type%3D10";
    
    NSString *urlString = nil;
    NSString *enPassword = [LLQQEncription hashPasswordForLogin:_password v1:[_verifyCode uppercaseString] v2:_verifyCodeKey];
    
    urlString = [urlPattern stringByReplacingOccurrencesOfString:@"$(account)"  withString:_user];
    urlString = [urlString  stringByReplacingOccurrencesOfString:@"$(password)" withString:enPassword];
    urlString = [urlString  stringByReplacingOccurrencesOfString:@"$(VCode)"    withString:[_verifyCode uppercaseString]];
    urlString = [urlString  stringByReplacingOccurrencesOfString:@"$(loginurl)" withString:loginURL];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURLString:urlString];
    //[request setUseCookiePersistence:NO];
    [request setRequestCookies:[NSMutableArray arrayWithArray:[_cookies allValues]]];

    [request setFailedBlock:^(void){
        NSError *error = [request error];
        [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:NO info:error];
    }];
    
    [request setCompletionBlock:^(void){
        NSString *response = [request responseString];
        NSString *regexString = @"ptuiCB\\('(\\d+)',\\s?'(.*)',\\s?'(.*)',\\s?'(.*)',\\s?'(.*)',\\s?'(.*)'\\)";
        NSString *retcode = [response stringByMatching:regexString capture:1L];
        NSString *info = [response stringByMatching:regexString capture:5L];
        
        if (NO == [retcode isEqualToString:@"0"]) {
            [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:NO info:info];
        } else {
            //[self updateCookies:[request responseCookies]];

            for (NSHTTPCookie *cookie in [request responseCookies]) {
                if ([cookie.name isEqualToString:@"skey"]) {
                    _skey = [cookie.value copy];
                } else if ([cookie.name isEqualToString:@"ptwebqq"]) {
                    _ptwebqq = [cookie.value copy];
                }
            }
                
            [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:YES info:nil];
            [self stepProgressOneByOne];
        }
    }];
    
    [request startAsynchronous];
}

- (void)setStatus
{
    _currentProgress = LLQQLOGIN_PROGRESS_SET_STATUS;
    
    static NSString *urlString = @"http://d.web2.qq.com/channel/login2";
    
    NSString *content = @"{\"status\":\"$(status)\",\"ptwebqq\":\"$(ptwebqq)\",\"passwd_sig\":\"\",\"clientid\":\"$(clientid)\",\"psessionid\":null}";
    content = [content stringByReplacingOccurrencesOfString:@"$(status)" withString:_status];
    content = [content stringByReplacingOccurrencesOfString:@"$(ptwebqq)" withString:_ptwebqq];
    content = [content stringByReplacingOccurrencesOfString:@"$(clientid)" withString:_clientid];  
    
    NSLog(@"content is %@", content);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURLString:urlString];
    //[request setUseCookiePersistence:NO];
    [request setRequestCookies:[NSMutableArray arrayWithArray:[_cookies allValues]]];
    [request setPostValue:content forKey:@"r"];
    [request setPostValue:_clientid forKey:@"clientid"];
    [request setPostValue:@"null" forKey:@"psessionid"];
    
    //[request setShouldAttemptPersistentConnection:YES];    
    [request addRequestHeader:@"Referer" value:@"http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3"];
    
    [request setFailedBlock:^(void) {
        NSError *error = [request error];
        [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:NO info:error];
    }];
    
    [request setCompletionBlock:^(void) {
        if (request.responseStatusCode != 200) {
        }
             
        NSString *response = [request responseString];
        NSDictionary *dic = [response JSONValue];
        if (dic && [[dic objectForKey:@"retcode"] isEqualToString:@"0"]) {
            NSDictionary *resultDic = [dic objectForKey:@"result"];
            
            long cip = [[resultDic objectForKey:@"cip"] longValue];
            NSString *status = [resultDic objectForKey:@"status"];
            long uin = [[resultDic objectForKey:@"uin"] longValue];
            NSString *psessionid = [resultDic objectForKey:@"psessionid"];
            NSString *vfwebqq = [resultDic objectForKey:@"vfwebqq"];
            
            [_delegate LLQQLoginProgressNoti:_currentProgress failOrSuccess:YES info:nil];   
            [self stepProgressOneByOne];
        } else {
            [_delegate LLQQLoginProgressNoti:_currentProgress 
                               failOrSuccess:NO 
                                        info:[@"Error code:" stringByAppendingString:[dic objectForKey:@"retcode"]]];
        }        
    }];
    
    [request startAsynchronous];
}

- (void)getPassportDic
{
    _currentProgress = LLQQLOGIN_PROGRESS_COMPLETED;
    
    LLQQLoginInfo *info = [[LLQQLoginInfo alloc] init];
    info.uin = _uin;
    info.cip = _cip;
    info.user = _user;
    info.password = _password;
    info.status = _status;
    info.verifyCode = _verifyCode;
    info.verifyCodeKey = _verifyCodeKey;
    info.ptwebqq = _ptwebqq;
    info.clientid = _clientid;
    info.psessionid = _psessionid;
    info.vfwebqq = _vfwebqq;
    
    [_delegate LLQQLoginProgressNoti:LLQQLOGIN_PROGRESS_COMPLETED failOrSuccess:YES info:[info autorelease]];                                 
    
}

- (NSString *)randomFloatValue
{
    return [NSString stringWithFormat:@"%.2f", 
     [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] longValue]/100.0 ];
}

- (void)restartWithVerifyCode:(NSString *)code
{
    _verifyCode = [code copy];
    [self stepProgressOneByOne];
}
@end
