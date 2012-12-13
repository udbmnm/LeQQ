//
//  LLQQLoginController.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-4.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "QuickDialogController.h"
#import "LLQQLogin.h"
#import "LLQQMoonBox.h"
#import "LLQQLogout.h"


@interface LLQQLoginController : QuickDialogController <LLQQLoginDelegate, LLQQLogoutDelegate, UIAlertViewDelegate>
{
    NSString *_userName;
    NSString *_password;
    NSString *_verifyCode;
    MBProgressHUD *_hub;
    LLQQLogin *_qqLoginSession;
    LLQQLogout *_qqLogoutSession;
    
    LLQQMoonBox *_box;
    BOOL _isLogin;
}

- (id)init;
@end
