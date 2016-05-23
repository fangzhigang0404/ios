//
//  AppController.h
//  MarketPlace
//
//  Created by zzz on 16/1/21.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMember.h"
#import <Foundation/Foundation.h>

@interface AppController : NSObject

 
+(NSString*)AppGlobal_GetAppMainVersion;
+(void)AppGlobal_SetNetworkDetectionEnable:(BOOL) isEnable;
+(void)AppGlobal_ProccessLogin;
+(void)AppGlobal_ProccessLogout;
//+(void)AppGlobal_UrlOpenAppData:(NSString*) inputData;
+ (void)AppGlobal_registerForPushNotification;
+ (void)AppGlobal_unRegisterForPushNotification;
+ (void)AppGlobal_registerPushNotificationWithServer:(NSString*) deviceTokenString;


//+(NSDictionary*)AppGlobal_GetMemberInfo;
+(MPMember*)AppGlobal_GetMemberInfoObj;
+(void) AppGlobal_SetLoginStatus:(BOOL) status;
+(BOOL) AppGlobal_GetLoginStatus;
+(BOOL) AppGlobal_GetIsDesignerMode;

/// open chat room.
+ (void)chatWithVC:(UIViewController *)viewController
        ReceiverID:(NSString *)receiver_id
ReceiverHomeStyleID:(NSString *)receiverhs_uid
      receiverName:(NSString *)receiver_name
           assetID:(NSString *)asset_id
          isQRScan:(BOOL)isQRscan;

/// have net or not.
+ (BOOL)isHaveNetwork;

/// clear cookie.
+ (void)clearCookie;

/// open privacy.
+ (void)openSettingPrivacy;

@end
