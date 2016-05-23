//
//  MPLoginTool.m
//  MarketPlace
//
//  Created by WP on 16/5/4.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPLoginTool.h"
#import "MPMemberModel.h"
#import "MPCenterTool.h"

#define MPGETNEWSYSTEMTHREADID @"MPGetnewthreadid"
#define MPSSO_LOHO @"MP_SSO_LOHO"

@implementation MPLoginTool

+ (void)requestForSystemThreadIDWithAcsMemberID:(NSString *)acs_member_id {
    [MPMemberModel getSystemThread:acs_member_id withSuccess:^(NSDictionary *dic) {

        MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
        [member System_thread_id:dic[@"inner_sit_msg_thread_id"]];
        [member System_im_thread_id:dic[@"im_msg_thread_id"]];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MPGETNEWSYSTEMTHREADID
                                                            object:nil];
    } failure:nil];
}

+ (void)requestForDesignerLohoInfo:(NSString *)acs_member_id {

    if ([AppController AppGlobal_GetIsDesignerMode]) {
        [MPMemberModel DesignerInformation:acs_member_id withSuccess:^(MPMemberModel *model) {
            [MPCenterTool saveIsLoho:model.is_loho];
            [[NSNotificationCenter defaultCenter] postNotificationName:MPSSO_LOHO
                                                                object:nil];
        } failure:^(NSError *error) {
            MPLog(@"%@",error);
        }];
    }
}

+ (void)saveNickName:(NSString *)nick_name {
    [MPCenterTool saveNickName:nick_name];
}

+ (void)postNotificationForLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"creat" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MPNotiForLoginIn object:nil];
}

+ (NSDictionary *)getSSOInfoWithString:(NSString *)sso_infoString {
    
    if (sso_infoString != nil) {
        
        NSRange range=[sso_infoString rangeOfString: @"Token=" ];
        if (range.length != 0) {
            
            NSString *jString = [sso_infoString substringFromIndex:range.length];
            jString = [jString stringByRemovingPercentEncoding];
            NSData *data = [jString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:nil];
            
            return dict;
        }
    }
    return @{@"error":@"error"};
}

@end
