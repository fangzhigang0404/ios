//
//  AppDelegate.m
//  MarketPlace
//
//  Created by xuezy on 15/12/15.
//  Copyright © 2015年 xuezy. All rights reserved.
//

#import "AppDelegate.h"
#import "AppController.h"
#import "MPWebSocketManager.h"
#import "MPWebSocketManagerBroadcaster.h"
#import "MPMarketplaceSettings.h"
#import "MPChatHttpManager.h"
#import "MPChatTestUser.h"
#import "MPFileUtility.h"
#import "MPMemberUnreadMsgCountManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MPDesignerlist.h"

#define MPAPPLICATIONBECOMEFRONT @"MPApplicationBecomeFront"

static NSString * key = @"MarketPlace For the first open";

@interface AppDelegate ()<UITabBarControllerDelegate, MPMemberUnreadMsgCountManagerDelegate>
{
    NSInteger       _curSelectedTabIndexBeforeLogin;
}

@property (strong, nonatomic)MPWebSocketManager *wsManager;

@end


@implementation AppDelegate
{
    UIViewController *vc;
    UITabBarController *tbVC;
    NSInteger _isbidder;
}
-(MPWebSocketManager *)wsManager
{
    if (_wsManager==nil) {
        _wsManager=[MPWebSocketManager sharedInstance];
    }
    return _wsManager;
}


-(void)initTabbar
{
    tbVC.delegate = nil;
    self.window.rootViewController = nil;
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        _isbidder = 0;
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MPDesigner" bundle: nil ];
        tbVC= [storyBoard instantiateViewControllerWithIdentifier:@"Designer"];
        
    }else{
        
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"MPConsumer" bundle: nil ];
        tbVC = [storyBoard instantiateViewControllerWithIdentifier:@"Consumer"];
             
    }
    tbVC.delegate = self;
    self.window.rootViewController = tbVC;
}


- (void)update {
    
    [self initTabbar];
    
}


- (void)initializeMarketplace {
    
    
    
    BOOL useChinaServers = YES;
    
#ifdef RUNNING_PRODUCTION
    BOOL isStaging = NO;
#else
    BOOL isStaging = YES;
#endif
 
    
    
    
    if (isStaging)
    {
        [[MPMarketplaceSettings sharedInstance]
         initializeMarketplaceWithAFC:@"HW1ONB"
         appID:@"96"
         mediaIdProject:@"53"
         mediaIdCase:@"58"
         isStaging:YES
         useChinaServer:useChinaServers];
    }
    else
    {
        [[MPMarketplaceSettings sharedInstance]
         initializeMarketplaceWithAFC:@"HW1ON1"
         appID:@"96"
         mediaIdProject:@"53"
         mediaIdCase:@"58"
         isStaging:NO
         useChinaServer:useChinaServers];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _isbidder = 0;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:@(NO) forKey:@"isOpenReachable"];
    [userDefaults synchronize];
    
    [self initializeMarketplace];
    
    [[MPChatHttpManager sharedInstance] doTest];
    [[MPMemberUnreadMsgCountManager sharedInstance] setDelegate:self];
    
    //open web socket after Launch application
    //    [self.wsManager openSocketWithSession:Session withMemberID:MemberID withAppID:AppID andDeviceID:DeviceID];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:@"creat" object:nil];
    
    [self initTabbar];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    /********************************Number of messages********************************************************/
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"100",@"message_Number", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"message" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    /********************************Number of messages********************************************************/
    
    //create cache folder
    [MPFileUtility createRootCacheDirectory];
    
    // register for push notifications
    NSLog(@"Registering for push notifications...");
    [AppController AppGlobal_registerForPushNotification];
    //[self registerForPushNotification];
    
    
    [AppController AppGlobal_SetNetworkDetectionEnable:YES];
    
    //check if this launched when user taps on notification
    
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (userInfo)
        [self handlePushNotification:userInfo];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[MPMemberUnreadMsgCountManager sharedInstance] unregisterForMessageUpdate];
    [self unRegisterForLoginNotifications];
    [self.wsManager closeChatConnection];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MPAPPLICATIONBECOMEFRONT object:nil];
    //open  web socket when app do into active
    //     [self.wsManager openWebSocket];
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self registerForLoginNotifications];
    [self connectWithChatServer];
    [[MPMemberUnreadMsgCountManager sharedInstance] registerForMessageUpdate];
    [[MPMemberUnreadMsgCountManager sharedInstance] setMemberId:[AppController AppGlobal_GetMemberInfoObj].acs_member_id];
    [[MPMemberUnreadMsgCountManager sharedInstance] getMemberThreadUnreadCount];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //NSRange range = [[url absoluteString] rangeOfString:@"openapp://"];
    //NSString *token = [[url absoluteString] substringFromIndex:range.length];
    
    //[AppController AppGlobal_UrlOpenAppData:token];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"111result = %@",resultDic);
        }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    // NSRange range = [[url absoluteString] rangeOfString:@"openapp://"];
    //NSString *token = [[url absoluteString] substringFromIndex:range.length];
    // [AppController AppGlobal_UrlOpenAppData:token];
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }

    return YES;
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
        
        if (tabBarController.selectedIndex == 1 && [AppController AppGlobal_GetIsDesignerMode]) {
            if (_isbidder == 0) {
                [MPAlertView showAlertWithMessage:@"功能开发中,敬请期待" sureKey:^{
                    UIView * view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 100, SCREEN_HEIGHT/2 - 50, 200, 50)];
                    label.text = @"功能开发中,敬请期待...";
                    label.textColor = [UIColor whiteColor];
                    label.textAlignment = NSTextAlignmentCenter;
                    [view1 addSubview:label];
                    [tabBarController.selectedViewController.view addSubview:view1];
                    _isbidder ++;
                }];
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT)];
                imageView.image = [UIImage imageNamed:@"linshitest"];
                [tabBarController.selectedViewController.view addSubview:imageView];
                UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
                view.backgroundColor = [UIColor blackColor];
                view.alpha = 0.5;
                [tabBarController.selectedViewController.view addSubview:view];
            }
            return;
        }
    }
    
    BOOL status = [AppController AppGlobal_GetLoginStatus];
    _curSelectedTabIndexBeforeLogin = tabBarController.selectedIndex;
    if (status == NO && tabBarController.selectedIndex > 0)
    {
        tabBarController.selectedIndex = 0;
        [AppController AppGlobal_ProccessLogin];
    }
}

- (void)btnclick:(UIButton *)sender
{
    tbVC.selectedIndex = 0;
    [vc dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - push notifications

// invoked if app is active when a notification comes in
// if app was suspended in the background it is woken up and this method is also called
// use UIApplication’s applicationState property to find out whether your app was suspended or not.
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    if ( application.applicationState == UIApplicationStateActive )
        NSLog(@"Received push notification while active in foreground: %@", userInfo);
    else
    {
        NSLog(@"Received push notification while active in background: %@", userInfo);
        [self handlePushNotification:userInfo];
    }
}


- (void)handlePushNotification:(NSDictionary *)userInfo
{
    //Process notification
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return;
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"didRegisterForRemoteNotificationsWithDeviceToken");
    NSLog(@"%@",deviceToken);
    NSString *deviceTokenString = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"Sending Device registration request to Marketplace:%@",deviceTokenString);
    [AppController AppGlobal_registerPushNotificationWithServer:deviceTokenString];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // just get user info, we're not able to get the device token
    // simulator / user refused / etc
    NSLog(@"Failed to get APNS token, error: %@", error);
}

#pragma mark - ------

- (UITabBarItem*) tabBarItemForUnreadCount
{
    if (![[AppController AppGlobal_GetMemberInfoObj] MemberGetLoginStatus])
        return [[tbVC.tabBar items] objectAtIndex:1];
    
    if ([AppController AppGlobal_GetIsDesignerMode])
        return [[tbVC.tabBar items] objectAtIndex:2];
    else
        return [[tbVC.tabBar items] objectAtIndex:1];
}


#pragma mark - login related notification receivers

- (void) registerForLoginNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLoginNotification:)
                                                 name:MPNotiForLoginIn
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLogoutNotification:)
                                                 name:MPNotiForLoginOut
                                               object:nil];
}


- (void) unRegisterForLoginNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPNotiForLoginIn
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPNotiForLoginOut
                                                  object:nil];
}

- (void) receiveLoginNotification:(NSNotification*)notification
{
    tbVC.selectedIndex = 0;
    [self connectWithChatServer];
}


- (void) receiveLogoutNotification:(NSNotification*)notification
{
    tbVC.selectedIndex = 0;
    [self.wsManager closeChatConnection];
}


#pragma mark - private methods

- (void) connectWithChatServer
{
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    
    if (member)
    {
        BOOL bStatus = [member MemberGetLoginStatus];
        
        if (bStatus)
        {
            [self.wsManager openChatConnectionForUser:member.acs_member_id
                                          withSession:member.acs_x_session
                                             delegate:[[MPWebSocketManagerBroadcaster alloc] init]];
        }
    }
}

@end