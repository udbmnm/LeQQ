//
//  AppDelegate.h
//  LeQQ
//
//  Created by Xiangle le on 12-10-25.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLBomtomCompassMenu.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, LLBomtomCompassMenuDelegate>
{
    LLBomtomCompassMenu *_menu;
}

@property (strong, nonatomic) UIWindow *window;

@end
