//
//  MPLoginTool.h
//  MarketPlace
//
//  Created by WP on 16/5/4.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPLoginTool : NSObject

+ (void)requestForSystemThreadIDWithAcsMemberID:(NSString *)acs_member_id;

+ (void)requestForDesignerLohoInfo:(NSString *)acs_member_id;

+ (void)saveNickName:(NSString *)nick_name;

+ (void)postNotificationForLogin;

+ (NSDictionary *)getSSOInfoWithString:(NSString *)sso_infoString;

@end
