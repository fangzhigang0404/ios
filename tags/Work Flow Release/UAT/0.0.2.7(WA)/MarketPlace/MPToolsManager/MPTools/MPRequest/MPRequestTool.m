//
//  MPRequestTool.m
//  MarketPlace
//
//  Created by WP on 16/4/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPRequestTool.h"
#import "MPAlertView.h"

#define OVERDUE_STATUSCODE 401
#define HEADER_TOKEN_KEY @"Authorization"

@implementation MPRequestTool

+ (BOOL)statueIsOverdue:(NSInteger)statusCode {
    if (statusCode == OVERDUE_STATUSCODE) {
        [MPAlertView showAlertWithMessage:@"您的登录已过期" sureKey:^{
            [AppController AppGlobal_ProccessLogout];
            [AppController AppGlobal_SetLoginStatus:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"creat" object:nil];
        }];
        return YES;
    }
    return NO;
}

+ (NSDictionary *)addAuthorizationForHeader:(NSDictionary *)header {
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    NSString *value = [NSString stringWithFormat:@"Basic %@",member.X_Token];
    NSMutableDictionary * headerNew  = [header mutableCopy];
    [headerNew setObject:value forKey:HEADER_TOKEN_KEY];
    header = [headerNew copy];
    MPLog(@"%@",header);
    return header;
}

@end
