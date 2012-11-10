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
        [self toastMsgNotify:@"用户或密码格式不正确"];
        return;
    }
    
    if (_hub == nil) {
        _hub = [[MBProgressHUD alloc] initWithView:self.view];
    }
    
    [self.view addSubview:_hub];
    [_hub setLabelText:@"正在登录..."];
    [_hub show:YES];
    
    _qqLoginSession = [[LLQQLogin alloc] initWithUser:_userName 
                                             password:_password 
                                               status:LLQQLOGIN_STATUS_ONLINE 
                                             delegate:self];
    [_qqLoginSession startAsynchronous];
}

- (BOOL)checkUserNameAndPasswordFormat
{
    if (_userName.length < 4 || _password.length < 1) {
        return NO;
    }
    
    return YES;
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
        case LLQQLOGIN_PROGRESS_CHECK_VERIFY_CODE:            
            break;
        case LLQQLOGIN_PROGRESS_GET_VERIFY_IMAGE:   
        {
            [_hub hide:YES];
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
            _hub.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
            _hub.mode = MBProgressHUDModeCustomView;
            _hub.labelText = @"Completed";
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
