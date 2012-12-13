//
//  AppDelegate.h
//  LeQQ
//
//  Created by Xiangle le on 12-10-25.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLBomtomCompassMenu.h"
#import "LLQQCommonRequest.h"
#import "LLTabBarController.h"
#import "LLQQLoginController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, 
LLBomtomCompassMenuDelegate,LLQQCommonRequestDelegate>
{
    LLBomtomCompassMenu *_menu;
    LLTabBarController *_tabarController;
    LLQQLoginController *_loginController;
    UIViewController *_firstRootViewCon;
    UIViewController *_currentChildViewConInFirstTAB;
}

@property (strong, nonatomic) UIWindow *window;

@end
