//
//  LLQQLoginController.h
//  LeQQ
//
//  Created by Xiangle le on 12-11-4.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "QuickDialogController.h"
#import "LLQQLogin.h"
#import "LLQQLoginInfo.h"


@interface LLQQLoginController : QuickDialogController <LLQQLoginDelegate>
{
    NSString *_userName;
    NSString *_password;
    NSString *_verifyCode;
    LLQQLoginInfo *_info;
    MBProgressHUD *_hub;
}

- (id)init;
@end
