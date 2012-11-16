//
//  AppDelegate.m
//  LeQQ
//
//  Created by Xiangle le on 12-10-25.
//  Copyright (c) 2012年 ganxiangle@gmail.com. All rights reserved.
//

#import "AppDelegate.h"
#import "AirTest.h"
#import "LLQQLogin.h"
#import "LLTabBarController.h"
#import "LLDebug.h"
#import "LLBomtomCompassMenu.h"
#import "LLGuetGirlsDownloader.h"
#import "LLQQLoginController.h"
#import "LLQQEncription.h"
#import "LLQQChattingViewController.h"
#import "ASIHTTPRequest+ASIQQHelper.h"
#import "LLFriendsController.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //NSString *enPassword = [LLQQEncription hashPasswordForLogin:@"4171739690" v1:@"!AAA" v2:@"\\x00\\x00\\x00\\x00\\x19\\x63\\xfc\\x01"];
    
    //LLGuetGirlsDownloader *downloader = [[LLGuetGirlsDownloader alloc] init];
    //[downloader downloadAllGuetGirls];
    
    //LLAuthenticodeAlertInputView *alertView = [[LLAuthenticodeAlertInputView alloc] initWithTitle:@"input secret" AuthenticodeImage:nil delegate:nil cancelButtonTitle:@"cancel" otherButtonTitle:@"done"];
    //[alertView show];
        
    LLTabBarController *tabbarController = [[LLTabBarController alloc] init];
    tabbarController.view.backgroundColor = [UIColor whiteColor];

    
    
    [tabbarController addViewController:[[[LLQQLoginController alloc] init] autorelease]
                               tabImage:[UIImage imageNamed:@"Galuca_0001"] title:@"登录"];

    LLFriendsController *friendsController = [[LLFriendsController alloc] init];

    [tabbarController addViewController:[[UINavigationController alloc] initWithRootViewController:friendsController]
                               tabImage:[UIImage imageNamed:@"Galuca_0156"]
                                  title:@"好友"];
     [friendsController release];
    
    [tabbarController addViewController:[[[LLQQChattingViewController alloc] init] autorelease] 
                               tabImage:[UIImage imageNamed:@"Galuca_0002"]  title:@"聊天"];

    [tabbarController addViewController:[[[UIViewController alloc] init] autorelease]
                               tabImage:[UIImage imageNamed:@"Galuca_0004"] title:@"con4"];

    [tabbarController addViewController:[[[UIViewController alloc] init] autorelease]
                               tabImage:[UIImage imageNamed:@"Galuca_0005"] title:@"con5"];
    
    [tabbarController setDelegate:self];
    
    _menu = [[self createBomtomMenuAboveView:tabbarController.tabBar] retain];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window setRootViewController:tabbarController];
    self.window.hidden = NO;
    
    /* setup ASI */
    [ASIHTTPRequest setDefaults];    
    
    return NO;
}

- (LLBomtomCompassMenu*)createBomtomMenuAboveView:(UIView *)view
{
    LLBomtomCompassMenu *menu = [[LLBomtomCompassMenu alloc] initAboveOfView:view];
    [_menu setDelegate:self];
    
    [menu addButtonsToFirstRoundWithImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"mcartoon"], [NSNull null], [UIImage imageNamed:@"menter"], [NSNull null], [UIImage imageNamed:@"mmovie"], nil]];
    
    [menu addButtonsToSecondRoundWithImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"mmusic"], 
                                             [UIImage imageNamed:@"mmyi"], [UIImage imageNamed:@"mmyi"],
                                             [UIImage imageNamed:@"mmyi"], [UIImage imageNamed:@"mmyi"],
                                             [UIImage imageNamed:@"mmyi"], [UIImage imageNamed:@"mmyi"], nil] bindingToInnerMenuItemByTag:kLLBomtomCompassMenuInnerBtnTag_1];
    
    [menu addButtonsToSecondRoundWithImages:[NSArray arrayWithObjects:[UIImage imageNamed:@"mcartoon"], 
                                             [UIImage imageNamed:@"mcartoon"], [UIImage imageNamed:@"mmyi"],
                                             [UIImage imageNamed:@"mcartoon"], [NSNull null],
                                             [UIImage imageNamed:@"mcartoon"], [UIImage imageNamed:@"mcartoon"], nil] bindingToInnerMenuItemByTag:kLLBomtomCompassMenuInnerBtnTag_3];
    
    [menu addButtonToCenterWithImage:[UIImage imageNamed:@"mvideo"] highlightedImage:nil];
    
    return [menu autorelease];
}

- (void)LLBomtomCompassMenu:(LLBomtomCompassMenu *)menu outterMenuButtonDidClicked:(LLBomtomCompassMenuButtonTag)outterTag withInnerMenuButton:(LLBomtomCompassMenuButtonTag)innerBtnTag
{
    DEBUG_LOG_WITH_FORMAT(@"Outter Menu %d, Inner Menu %d", outterTag, innerBtnTag);
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    static NSInteger selectedIndex = 0;
    
    if (tabBarController.selectedIndex == selectedIndex &&
        [viewController.tabBarItem.title isEqualToString:@"con3"]){
        
        DEBUG_LOG_WITH_FORMAT(@"%@ is selected", viewController.tabBarItem.title);
        [_menu showOrHideMenu];
    }
    
    selectedIndex = tabBarController.selectedIndex;    
}

- (void)LLQQLoginProgressNoti:(LLQQLoginProgress)progress failOrSuccess:(BOOL)retcode info:(id)info
{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
