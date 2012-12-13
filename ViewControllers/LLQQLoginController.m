//
//  LLQQLoginController.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-4.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQLoginController.h"
#import "LLAuthenticodeAlertInputView.h"
#import "LLNotificationCenter.h"
#import "LLQQLogout.h"
#import "LLDebug.h"
#import "LLQQGlobalCache.h"
#import "LLObjectValidator.h"

#define KEY_USERNAME @"userName"
#define KEY_PASSWORD @"password"
#define KEY_VERIFYCODE @"verifyCode"


@interface LLQQLoginController ()

@end

@implementation LLQQLoginController

- (id)init
{
    QRootElement *root = [[QRootElement alloc] init];
    root.title = @"LeQQ, the webQQ3.0 for iphone";
    root.grouped = YES;
    
    QSection *inputSection = [[QSection alloc] initWithTitle:@"登录"];
    
    QEntryElement *userNameTextElement = [[QEntryElement alloc] initWithTitle:@"QQ号"
                                                                        Value:nil 
                                                                  Placeholder:@"input you QQ number"];
    userNameTextElement.key = KEY_USERNAME;
    userNameTextElement.keyboardType = UIKeyboardTypeNumberPad;
    
    QEntryElement *passwordElement = [[QEntryElement alloc] initWithTitle:@"密码"
                                                                    Value:nil 
                                                              Placeholder:@"password"];
    passwordElement.key = KEY_PASSWORD;
    passwordElement.secureTextEntry = YES;

    [inputSection addElement:userNameTextElement];
    [inputSection addElement:passwordElement];
    [userNameTextElement release];
    [passwordElement release];
    
#ifdef DEBUG_AUTOINPUT_USER_PASSWORD
    userNameTextElement.textValue = @"425982977";
    passwordElement.textValue = @"4171739690";    
#endif
    
    QSection *loginBtnSection = [[QSection alloc] init];    
    
    QButtonElement *loginBtnElement = [[QButtonElement alloc] initWithTitle:@"登录"];
    loginBtnElement.key = @"loginKey";
    loginBtnElement.controllerAction = @"loginButtonClicked:";    
    [loginBtnSection addElement:loginBtnElement];
    [loginBtnElement release];    
    
    QSection *logoutBtnSection = [[QSection alloc] init];    
    QButtonElement *logoutBtnElement = [[QButtonElement alloc] initWithTitle:@"注销"];
    logoutBtnElement.key = @"logoutKey";
    logoutBtnElement.controllerAction = @"logoutButtonClicked:";
    [logoutBtnSection addElement:logoutBtnElement];
    [logoutBtnElement release];
    
    [root addSection:inputSection];
    [root addSection:loginBtnSection];
    [root addSection:logoutBtnSection];
    [inputSection release];
    [loginBtnSection release];
    [logoutBtnSection release];
    
    self = [super initWithRoot:root];
    [root release];
    
    if (self) {
        _userName = nil;
        _password = nil;
        _verifyCode = nil;
        _hub = nil;
        _qqLoginSession = nil;
        _qqLogoutSession = nil;
        _isLogin = NO;
        _box = nil;
    }
    return self;    
}

- (void)dealloc
{
    [_userName release];
    [_password release];
    [_verifyCode release];
    [_hub release];
    [_qqLoginSession release];
    [_qqLogoutSession release];
    [_box release];
    [super dealloc];
}

/* callback of the login button */
- (void)loginButtonClicked:(QElement *)element
{
    _userName = [(QEntryElement *)[self.root elementWithKey:KEY_USERNAME] textValue];
    _password = [(QEntryElement *)[self.root elementWithKey:KEY_PASSWORD] textValue]; 
    
    /* user name or password format error, pop up a msg and go back */
    if (!([LLObjectValidator isQQUserNameFormatLegal:_userName] && 
          [LLObjectValidator isQQPasswordFormatLegal:_password]) ) {
        
        [self toastMsgNotify:@"用户或密码格式不正确"];
        return;
    }
    
    if (_hub == nil) {
        _hub = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [self.view addSubview:_hub];
    [_hub setMode:MBProgressHUDModeIndeterminate];
    [_hub setLabelText:@"正在登录..."];
    [_hub show:YES];
    
    if (_qqLoginSession) [_qqLoginSession release];
    
    _qqLoginSession = [[LLQQLogin alloc] initWithUser:_userName 
                                             password:_password 
                                               status:LLQQLOGIN_STATUS_ONLINE 
                                             delegate:self];
    [_qqLoginSession startAsynchronous];
}

- (void)logoutButtonClicked:(QElement *)element
{
    if (_isLogin == NO) {
        [self toastMsgNotify:@"您还未登录"];
        return;
    }
    
    if (_qqLogoutSession) {
        [_qqLogoutSession release];
        _qqLogoutSession = nil;
    }
    
    _qqLogoutSession = [[LLQQLogout alloc] initWithClientID:_box.clientid
                                                 psessionid:_box.psessionid
                                                   delegate:self];
    [_qqLogoutSession startAsynchronous];
    
}

- (void)LLQQLogoutNotifyFailOrSuccess:(BOOL)ret info:(id)info
{
    if (ret == NO) {
        [self toastMsgNotify:[NSString stringWithFormat:@"注销失敗:%@", info]];
    } else {
        [self toastMsgNotify:@"注销成功"];
    }
    _isLogin = NO;  
}

- (void)LLQQLoginProgressNoti:(LLQQLoginProgress)progress failOrSuccess:(BOOL)retcode info:(id)info
{
    if (retcode == NO) {
        /* hide and remove the loading indicator hub */
        [_hub hide:YES];
        [_hub removeFromSuperViewOnHide];
        [self toastMsgNotify:[info isKindOfClass:[NSError class]] ? [NSString stringWithFormat:@"%@", info] : (NSString *)info];
        return;
    }
    
    switch (progress) {
        case LLQQLOGIN_PROGRESS_GET_VERIFY_IMAGE:   
        {
            [_hub hide:YES];
            [_hub removeFromSuperViewOnHide];
            UIImage *img = (UIImage *)info;
            [self showModelViewForVerifyCodeInput:img];
        }
            break;
        case LLQQLOGIN_PROGRESS_COMPLETED:  
            _box = [info retain]; //NOTE: it's not deep copy now, must change it to deep copy later.
            [[LLGlobalCache getGlobalCache] saveMoonBox:_box];
            [LLNotificationCenter post:kNotificationTypeLoginSuccess 
                                 value:_box];            
            
            _hub.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
            _hub.mode = MBProgressHUDModeCustomView;
            _hub.labelText = @"Completed";
            [_hub hide:YES afterDelay:0.4];
            [_hub removeFromSuperViewOnHide];
            
            _isLogin = YES;
            
            break;
        default:
            break;
    }    
}

/* 
 * login fail, show user the error infomation and 
 * remove the loading indicator view.
 */
- (void)toastMsgNotify:(NSString *)errMsg
{
    [[[[iToast makeText:errMsg] setGravity:iToastGravityTop] setDuration:iToastDurationShort] show];
}

/* 
 * Show a View which will show user the verify code in the image 
 */
- (void)showModelViewForVerifyCodeInput:(UIImage *)img
{
    LLAuthenticodeAlertInputView *alertInput = [[LLAuthenticodeAlertInputView alloc] 
                                                initWithTitle:@"请输入验证码"
                                                authenticodeImage:img 
                                                delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitle:@"登录"];
    [alertInput show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;  // after animation
{
    if ([alertView isKindOfClass:[LLAuthenticodeAlertInputView class]]) {
        if (buttonIndex != -1) {
            /* when showing verifycode input view, the hub is hide and remove from super view */
            [self.view addSubview:_hub];
            [_hub show:YES];
            [_qqLoginSession restartWithVerifyCode:[(LLAuthenticodeAlertInputView*)alertView getVerifyCode]];
        }
    }    
}
@end
