//
//  LLQQLoginController.m
//  LeQQ
//
//  Created by Xiangle le on 12-11-4.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "LLQQLoginController.h"
#import "LLNotificationCenter.h"
#import "LLAuthenticodeAlertInputView.h"

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
                                                                        Value:nil Placeholder:@"input you QQ number"];
    userNameTextElement.key = KEY_USERNAME;
    userNameTextElement.keyboardType = UIKeyboardTypeNumberPad;
    
    QEntryElement *passwordElement = [[QEntryElement alloc] initWithTitle:@"密码" Value:nil Placeholder:@"password"];
    passwordElement.key = KEY_PASSWORD;
    passwordElement.secureTextEntry = YES;

    [inputSection addElement:userNameTextElement];
    [inputSection addElement:passwordElement];
    [userNameTextElement release];
    [passwordElement release];
    
    QSection *loginBtnSection = [[QSection alloc] init];    
    
    QButtonElement *loginBtnElement = [[QButtonElement alloc] initWithTitle:@"登录"];
    loginBtnElement.key = @"loginKey";
    loginBtnElement.controllerAction = @"loginButtonClicked:";    
    [loginBtnSection addElement:loginBtnElement];
    [loginBtnElement release];
    
    [root addSection:inputSection];
    [root addSection:loginBtnSection];
    [inputSection release];
    [loginBtnSection release];
    
    self = [super initWithRoot:root];
    [root release];
    
    if (self) {
        _userName = nil;
        _password = nil;
        _verifyCode = nil;
        _info = nil;
        _hub = nil;
        _qqLoginSession = nil;
    }
    return self;    
}

- (void)dealloc
{
    [_userName release];
    [_password release];
    [_verifyCode release];
    [_info release];
    [_hub release];
    [_qqLoginSession release];
    [super dealloc];
}

/* callback of the login button */
- (void)loginButtonClicked:(QElement *)element
{
    _userName = [(QEntryElement *)[self.root elementWithKey:KEY_USERNAME] textValue];
    _password = [(QEntryElement *)[self.root elementWithKey:KEY_PASSWORD] textValue]; 
    
    /* user name or password format error, pop up a msg and go back */
    if ([self checkUserNameAndPasswordFormat] == NO) {
        return;
    }
    
    if (_hub == nil) {
        _hub = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [_hub show:YES];
    
    _qqLoginSession = [[LLQQLogin alloc] initWithUser:@"425982977"//_userName 
                                                       password:@"4171739690" //_password 
                                                         status:LLQQLOGIN_STATUS_ONLINE 
                                                       delegate:self];
    [_qqLoginSession startAsynchronous];
}

- (BOOL)checkUserNameAndPasswordFormat
{
    return YES;
}

- (void)LLQQLoginProgressNoti:(LLQQLoginProgress)progress failOrSuccess:(BOOL)retcode info:(id)info
{
    if (retcode == NO) {
        [self loginErrorWithMsg:[info isKindOfClass:[NSError class]] ? [NSString stringWithFormat:@"%@", info] : (NSString *)info];
    }
    
    switch (progress) {
        case LLQQLOGIN_PROGRESS_CHECK_VERIFY_CODE:            
            break;
        case LLQQLOGIN_PROGRESS_GET_VERIFY_IMAGE:   
        {
            UIImage *img = (UIImage *)info;
            [self showModelViewForVerifyCodeInput:img];
        }
            break;
        case LLQQLOGIN_PROGRESS_LOGIN:            
            break;
        case LLQQLOGIN_PROGRESS_SET_STATUS:            
            break;
        case LLQQLOGIN_PROGRESS_COMPLETED:     
            _info = [(LLQQLoginInfo *)info retain];
            [LLNotificationCenter post:kNotificationTypeLoginSuccess 
                                  info:[NSDictionary dictionaryWithObject:_info forKey:@"loginInfo"]];
            break;
        default:
            break;
    }
    
}

/* 
 * login fail, show user the error infomation and 
 * remove the loading indicator view.
 */
- (void)loginErrorWithMsg:(NSString *)errMsg
{
    [_hub hide:YES];
    
    
    
    
    
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
            [_qqLoginSession restartWithVerifyCode:[(LLAuthenticodeAlertInputView*)alertView getVerifyCode]];
        }
    }
    
}
@end
