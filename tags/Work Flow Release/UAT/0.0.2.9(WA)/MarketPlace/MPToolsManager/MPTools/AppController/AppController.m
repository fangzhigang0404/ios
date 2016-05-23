//
//  AppController.m
//  MarketPlace
//
//  Created by zzz on 16/1/21.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "AppController.h"
#import "MPNetWorkDetector.h"
#import "MPLoginPageViewController.h"
#import "MPChatThreads.h"
#import "MPChatThread.h"
#import "MPChatRoomViewController.h"

#define OVERDUE_STATUSCODE 401

static NSString * pushNotificationTokenKey = @"MP_PUSHNOTIFICATION_TOKEN_KEY";

@interface AppController()

@end

@implementation AppController

+ (NSString*)AppGlobal_GetAppMainVersion{

//    NSString* version=[NSString stringWithFormat:@"Version %@%@0.0.7.6",BRANCH_PREFIX,ENVIROMENT_PREFIX];
    NSString *version=[NSString stringWithFormat:@"Version %@%@0.0.2.8",BRANCH_PREFIX,ENVIROMENT_PREFIX];
    return version;
}


+ (void)AppGlobal_SetNetworkDetectionEnable:(BOOL) isEnable{
    [MPNetWorkDetector SetNetworkDetectionEnable:isEnable];
    [[NSUserDefaults standardUserDefaults] setValue:@(isEnable) forKey:@"isOpenReachable"];
 
}

+ (UIViewController*)AppGlobal_GetAppRootViewController{
    return [[UIApplication sharedApplication] keyWindow].rootViewController;
}

+ (void)AppGlobal_ProccessLogin {
   
    MPLoginPageViewController* LoginController=[[MPLoginPageViewController alloc]init];
    UIViewController *mainviewcontroller =[AppController AppGlobal_GetAppRootViewController];
    [mainviewcontroller presentViewController:LoginController animated:YES completion:nil];
}

+ (void)AppGlobal_ProccessLogout{
    
    [AppController AppGlobal_unRegisterForPushNotification];
    
    UIWebView *webView = [[UIWebView alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:LOGOUT_PATH]];
    [webView loadRequest:request];
    [[NSNotificationCenter defaultCenter] postNotificationName:MPNotiForLoginOut object:nil];
}

+ (void)AppGlobal_SetpushNotificationTokenKey:(NSString*) deviceTokenString {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:deviceTokenString
                     forKey:pushNotificationTokenKey];
    [userDefaults synchronize];
    
}

+ (void)AppGlobal_registerForPushNotification {
    // iOS8
    UIUserNotificationType type = UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
}

+ (void)AppGlobal_registerPushNotificationWithServer:(NSString*) deviceTokenString {
    //incase device token is already there
    // I am not making a call to "AppGlobal_unRegisterForPushNotification" here purposely
    // as making two async requests which may not execute one by one
    // so if unregister gets execured after register which will device token
    // so here I am removing device token first and then just firing unregister call
    // also unregister only when both tokens are NOT matching

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *prevDeviceTokenString = [userDefaults objectForKey:pushNotificationTokenKey];
    
    if (prevDeviceTokenString && [prevDeviceTokenString compare:deviceTokenString] != NSOrderedSame)
    {
        [userDefaults removeObjectForKey:pushNotificationTokenKey];
        [userDefaults synchronize];

        [[MPChatHttpManager sharedInstance] unRegisterDeviceForPushNotifications:prevDeviceTokenString
                                                                         success:^(BOOL bSuccess)
        {
             NSLog(@"successfully unRegistered a device");
         } failure:^(NSError *error) {
             
             NSLog(@"failed to unRegister a device");
         }];
    }

    
    [[MPChatHttpManager sharedInstance] registerDeviceForPushNotifications:deviceTokenString
                                                                   success:^(BOOL bSuccess)
     {
         if (bSuccess)
         {
             NSLog(@"successfully registered a device");
             
             //storing this token just for unregister device during logout
             [AppController AppGlobal_SetpushNotificationTokenKey:deviceTokenString];
         }
         else
             NSLog(@"failed to register a device");
         
     } failure:^(NSError *error) {
         
         if (error)
             NSLog(@"Failed to register a device with error =%@", error.localizedDescription);
     }];

}

+ (void)AppGlobal_unRegisterForPushNotification {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceTokenString = [userDefaults objectForKey:pushNotificationTokenKey];
    
    if (deviceTokenString)
    {
        [[MPChatHttpManager sharedInstance] unRegisterDeviceForPushNotifications:deviceTokenString
                                                                         success:^(BOOL bSuccess)
         {
             [userDefaults removeObjectForKey:pushNotificationTokenKey];
             [userDefaults synchronize];
             
             
         } failure:^(NSError *error)
         {
             
         }];
    }
}

+ (MPMember*)AppGlobal_GetMemberInfoObj {
    
    MPMember* member=[[MPMember alloc]init];
    return member;
}

+ (void) AppGlobal_SetLoginStatus:(BOOL) status {
 
    MPMember* member=[[MPMember alloc]init];
    [member MemberSetLoginStatus:status];

    // Clean Web View cookies
    [self clearCookie];
}

+ (BOOL) AppGlobal_GetLoginStatus {
    MPMember* member=[[MPMember alloc]init];
    return [member MemberGetLoginStatus];
}

+ (BOOL) AppGlobal_GetIsDesignerMode {
    
    MPMember* member=[[MPMember alloc]init];
    return [member MemberIsDesignerMode];
}

+ (void)chatWithVC:(UIViewController *)viewController
        ReceiverID:(NSString *)receiver_id
        ReceiverHomeStyleID:(NSString *)receiverhs_uid
      receiverName:(NSString *)receiver_name
           assetID:(NSString *)asset_id
          isQRScan:(BOOL)isQRscan {
    
    [MBProgressHUD showHUDAddedTo:viewController.view animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray* members = @[[MPMember shareMember].acs_member_id,receiver_id,ADMIN_USER_ID];
        [[MPChatHttpManager sharedInstance] retrieveMultipleMemberThreads:members
                                                               withOffset:0
                                                                 andLimit:10
                                                                  success:^(MPChatThreads *threads) {
            NSLog(@"%@",threads);
            MPChatRoomViewController *vc;
            if (threads.threads.count > 0) {
                MPChatThread *thread = threads.threads[0];
                vc = [[MPChatRoomViewController alloc]
                                                    initWithThread:thread.thread_id
                                                    withReceiverId:receiver_id
                                                  withReceiverName:receiver_name
                                                       withAssetId:asset_id
                                                    loggedInUserId:[MPMember shareMember].acs_member_id];
                
            } else {
                vc = [[MPChatRoomViewController alloc]
                                                initWithReceiverId:receiver_id
                                                  withHomeStylerId:receiverhs_uid
                                                  withReceiverName:receiver_name
                                                       withAssetId:asset_id
                                                    loggedInUserId:[MPMember shareMember].acs_member_id];
                
            }
            vc.fromQRCode = isQRscan;
            [MBProgressHUD hideAllHUDsForView:viewController.view animated:YES];

            dispatch_async(dispatch_get_main_queue(), ^{
                vc.hidesBottomBarWhenPushed = YES;
                [viewController.navigationController pushViewController:vc
                                                               animated:YES];
                                                                      });
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideAllHUDsForView:viewController.view animated:YES];
            [MPAlertView showAlertForNetError];
        }];
    });
}

+ (void)openSettingPrivacy {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=Privacy"]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=Privacy"]];
    }
}

+ (BOOL)isHaveNetwork {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == NotReachable) {
        return NO;
    }
    return YES;
}

+ (void)clearCookie {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
}

@end
