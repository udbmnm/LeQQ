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
#import "LLNotificationCenter.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
        
   _tabarController = [[LLTabBarController alloc] init];
    _tabarController.view.backgroundColor = [UIColor whiteColor];
    
    LLFriendsController *friendsController = [[LLFriendsController alloc] init];
    
    [_tabarController addViewController:[[[UINavigationController alloc] initWithRootViewController:friendsController] autorelease]
                               tabImage:[UIImage imageNamed:@"conversations40x40"]
                                  title:@"好友"];
    
    [_tabarController addViewController:[[[UIViewController alloc] init] autorelease]
                               tabImage:[UIImage imageNamed:@"Galuca_0004"] title:@"con4"];

    [_tabarController addViewController:[[[UIViewController alloc] init] autorelease]
                               tabImage:[UIImage imageNamed:@"Galuca_0005"] title:@"con5"];
    
    [_tabarController setDelegate:self];
    
    _menu = [[self createBomtomMenuAboveView:_tabarController.tabBar] retain];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window setRootViewController:[[[LLQQLoginController alloc] init] autorelease]];
    self.window.hidden = NO;
    
    /* setup ASI */
    [ASIHTTPRequest setDefaults];   
    [LLNotificationCenter add:self
                     selector:@selector(loginNotificationHandler:)
                                         notificationType:kNotificationTypeLoginSuccess];
    
    return NO;
}

-(void)loginNotificationHandler:(NSNotification *)nofi
{
    [self.window setRootViewController:_tabarController];
    [self startTimerForPolling];
}

-(void)startTimerForPolling
{
    NSTimer *pollingTimer = [NSTimer timerWithTimeInterval:QQ_REQUEST_POLLING_TIMEOUT
                                                    target:self
                                                  selector:@selector(timerHandlerForPollingMsg:) 
                                                  userInfo:nil 
                                                   repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:pollingTimer forMode:NSDefaultRunLoopMode];
}

-(void)timerHandlerForPollingMsg:(NSTimer *)theTimer
{
    static LLQQCommonRequest *pollingRequest = nil;
    if (pollingRequest == nil) {
        pollingRequest = [[LLQQCommonRequest alloc] initWithBox:[[LLGlobalCache getGlobalCache] getMoonBox] 
                                                       delegate:self];
    }
    [pollingRequest poll];
}

- (void)LLQQCommonRequestNotify:(LLQQCommonRequestType)requestType isOK:(BOOL)success info:(id)info
{
    if (success == NO) {
        NSString *errorMsg = nil;
        if ([info isKindOfClass:[NSError class]]) {
            NSError *error = info;
            if (error.code == 2) {
                /* when the polling request timeout, count it */
                [[LLGlobalCache getGlobalCache] addPollingTimeoutCountByOne];
                return;
            }
            errorMsg = [NSString stringWithFormat:@"%@", info];
        } else {
            errorMsg = (NSString *)errorMsg;
        } 
        [[[[iToast makeText:errorMsg] setGravity:iToastGravityBottom] setDuration:iToastDurationNormal] show];
        return;
    }    
    
    if (requestType == kQQRequestPoll) {
        LLQQMsg *msg = (LLQQMsg *)info;
        [LLNotificationCenter post:kNotificationTypeNewMessage value:msg];        
    }    
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
