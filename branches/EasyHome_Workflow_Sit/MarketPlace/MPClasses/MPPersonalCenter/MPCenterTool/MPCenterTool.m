//
//  MPCenterTool.m
//  MarketPlace
//
//  Created by WP on 16/4/7.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPCenterTool.h"
#import "MPMemberModel.h"
#import "MPCenterInfo.h"
#import "UIButton+WebCache.h"

#define USERINFO @"MPUserInformation"
#define AUDITSTATUS @"mp_designer_auditstatus"

@implementation MPCenterTool

#pragma mark - person info.
+ (void)savePersonCenterInfo:(MPMemberModel *)model {
    MPCenterInfo *info = [self getCenterInfo:model];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
    [self writeInUserDefaults:data key:USERINFO];
}

+ (MPMemberModel *)getPersonCenterInfo {
    NSData *data = [self readValueForKey:USERINFO];
    MPCenterInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return [self getMemberModel:info];
}

#pragma mark - set head button.
+ (void)setHeadIcon:(UIButton *)btn
             avator:(NSString *)netAvator {
    
    NSString *cacheAvator = [self getCacheAvator];
    if([AppController isHaveNetwork]){
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:netAvator] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]options:SDWebImageRetryFailed] ;
    } else {
        if (cacheAvator) { /// no net can not to set SDWebImageRetryFailed.
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:cacheAvator] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
        } else {
            [btn setBackgroundImage:[UIImage imageNamed:ICON_HEADER_DEFAULT] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - audit_status
+ (void)saveAuditStatus:(NSString *)audit_status {
    [self writeInUserDefaults:audit_status key:AUDITSTATUS];
}

+ (NSString *)getAuditStatus {
    return [self readValueForKey:AUDITSTATUS];
}

#pragma mark - nick_name;
+ (NSString *)getNickName {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
    MPCenterInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return info.nick_name;
}

+ (void)saveNickName:(NSString *)nick_name {
    MPCenterInfo *info = [[MPCenterInfo alloc] init];
    info.nick_name = nick_name;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
    [self writeInUserDefaults:data key:USERINFO];
}

#pragma mark - loho
+ (NSString *)getIsLoho {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
    MPCenterInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return info.is_loho;
}

#pragma mark - method
+ (void)writeInUserDefaults:(id)value key:(NSString *)key {
    NSUserDefaults * UserDefaults = [NSUserDefaults standardUserDefaults];
    [UserDefaults setObject:value forKey:key];
    [UserDefaults synchronize];
}

+ (id)readValueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString *)getCacheAvator {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
    MPCenterInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return info.avatar;
}

+ (MPCenterInfo *)getCenterInfo:(MPMemberModel *)model {
    
    MPCenterInfo *info = [[MPCenterInfo alloc] init];
    info.nick_name          = model.nick_name;
    info.avatar             = model.avatar;
    info.is_loho            = model.is_loho;
    info.hitachi_account    = model.hitachi_account;
    info.gender             = model.gender;
    info.mobile_number      = model.mobile_number;
    info.email              = model.email;
    info.province           = model.province;
    info.city               = model.city;
    info.district           = model.district;
    info.design_price_max   = model.design_price_max;
    info.design_price_min   = model.design_price_min;
    info.measurement_price  = model.measurement_price;
    info.acount             = model.acount;
    return info;
}

+ (MPMemberModel *)getMemberModel:(MPCenterInfo *)model {
    
    MPMemberModel *info = [[MPMemberModel alloc] init];
    info.nick_name          = model.nick_name;
    info.avatar             = model.avatar;
    info.is_loho            = model.is_loho;
    info.hitachi_account    = model.hitachi_account;
    info.gender             = model.gender;
    info.mobile_number      = model.mobile_number;
    info.email              = model.email;
    info.province           = model.province;
    info.city               = model.city;
    info.district           = model.district;
    info.design_price_max   = model.design_price_max;
    info.design_price_min   = model.design_price_min;
    info.measurement_price  = model.measurement_price;
    info.acount             = model.acount;
    return info;
}

@end
