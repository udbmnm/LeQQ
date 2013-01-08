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
#import "LLGroupsAndDiscusController.h"

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
    
    /* friends, groups, recentlist view controller, in first TAB*/
    LLFriendsController *friendsController = [[[LLFriendsController alloc] init] autorelease];
    LLGroupsAndDiscusController *groupAndDicusController = [[[LLGroupsAndDiscusController alloc] init] autorelease];
    
    /* first TAB view controller */
    _firstRootViewCon = [[UIViewController alloc] init];
    [_firstRootViewCon addChildViewController:friendsController];
    [_firstRootViewCon addChildViewController:groupAndDicusController];
    [_firstRootViewCon.view addSubview:friendsController.view];
    _currentChildViewConInFirstTAB = friendsController;
        
    /* the segment to switch view controller in three cons at first TAB */
    UISegmentedControl *segment = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"好友", @"群/讨论组", @"最近联系", nil]] autorelease];
    [segment setSegmentedControlStyle:UISegmentedControlStyleBar];
    [segment addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventValueChanged];
    segment.selectedSegmentIndex = 0;
    _firstRootViewCon.navigationItem.titleView = segment;
    [segment release];  
    
    /* wrap the first TAB root view controller with navigation controller */
    UINavigationController *firstNavController = [[[UINavigationController alloc] initWithRootViewController:_firstRootViewCon] autorelease];    
    firstNavController.view.backgroundColor = [UIColor clearColor];
    
    /* add TABs */
    [_tabarController addViewController:firstNavController
                               tabImage:[UIImage imageNamed:@"conversations40x40"]
                                  title:@"好友"];
    
    [_tabarController addViewController:[[[UIViewController alloc] init] autorelease]
                               tabImage:[UIImage imageNamed:@"Galuca_0004"] 
                                  title:@"con4"];
    
    [_tabarController addViewController:[[[UIViewController alloc] init] autorelease]
                               tabImage:[UIImage imageNamed:@"Galuca_0005"] 
                                  title:@"con5"];
    
    [_tabarController setDelegate:self];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window setRootViewController:_tabarController];    
    self.window.hidden = NO;
    [self.window.rootViewController presentModalViewController:[[[LLQQLoginController alloc] init] autorelease] 
                                                      animated:NO];
    
    /* setup ASI */
    [ASIHTTPRequest setDefaults];   
    [LLNotificationCenter add:self
                     selector:@selector(loginNotificationHandler:)
                                         notificationType:kNotificationTypeLoginSuccess];
    
    return NO;
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

#pragma mark -segment controll callback
- (void)segmentClicked:(id)sender
{
    int index = [(UISegmentedControl *)sender selectedSegmentIndex];
    NSLog(@"segment's index:%d", [(UISegmentedControl *)sender selectedSegmentIndex]);    
    
    [_currentChildViewConInFirstTAB.view removeFromSuperview];
    [_firstRootViewCon.view addSubview:[[[_firstRootViewCon childViewControllers] objectAtIndex:index] view]];
    
}

#pragma mark -login success callback
-(void)loginNotificationHandler:(NSNotification *)nofi
{
    [self.window.rootViewController dismissModalViewControllerAnimated:YES];
    [self startTimerForPolling];
}

#pragma mark -pulling timer
-(void)startTimerForPolling
{
    NSAssert([[LLGlobalCache getGlobalCache] getMoonBox] != nil, @"Not login now");
    
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
    DEBUG_LOG_WITH_FORMAT(@"polling>");
    [pollingRequest poll];
}

#pragma mark -callback for polling request, distribute the msgs
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
        id msg = (LLQQMsg *)info;
        /* 
         * the receiver can show a notification animation for new msg, 
         * and the chatting view will add the msg 
         */
        if ([msg isKindOfClass:[LLQQMsg class]]) {
            [[LLQQMsgManager getShareManager] addNewMsg:msg];
            switch ([(LLQQMsg*)msg srcType]) {
                case kQQMsgSourceUser:
                    [LLNotificationCenter post:kNotificationTypeUnreadMessageFromFriend value:msg];    
                    break;
                
                default:
                    break;
            }
        }
        
    }    
}

#pragma mark -tabbar callback
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

#pragma mark -the bottom menu
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

@end
