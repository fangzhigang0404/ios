//
//  MPMemberModel.m
//  MarketPlace
//
//  Created by leed on 16/1/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMemberModel.h"
#import "MPAPI.h"
#import "MPCenterTool.h"

@implementation MPMemberModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
        
        self.home_phone = [NSString stringWithFormat:@"%@",[dict objectForKey:@"home_phone"]];
        self.birthday = [NSString stringWithFormat:@"%@",[dict objectForKey:@"birthday"]];
        self.zip_code = [NSString stringWithFormat:@"%@",[dict objectForKey:@"zip_code"]];
        
        self.hitachi_account = [NSString stringWithFormat:@"%@",[dict objectForKey:@"hitachi_account"]];
//        self.true_name = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"real_name"] objectForKey:@"real_name"]];
//        self.id_card = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"real_name"] objectForKey:@"certificate_no"]];
        
        self.province = [NSString stringWithFormat:@"%@",[dict objectForKey:@"province"]];
        self.nick_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"nick_name"]];
        self.address =  [NSString stringWithFormat:@"%@",[dict objectForKey:@"address"] ];
        self.mobile_number = [NSString stringWithFormat:@"%@",[dict objectForKey:@"mobile_number"]];
        self.measurement_price = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"measurement_price"] ];
        self.design_price_max = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"design_price_max"] ];
        self.design_price_min = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"design_price_min"] ];
        
        self.style_long_names = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"style_long_names"]];
        self.introduction = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"introduction"]];
        self.experience = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"experience"]];
        self.diy_count = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"diy_count"]];
        self.case_count = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"case_count"]];
        self.theme_pic = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"theme_pic"]];
        self.personal_honour = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"personal_honour"]];

        self.gender= [NSString stringWithFormat:@"%@",[dict objectForKey:@"gender"]];
        if ([self.gender isEqualToString:@"1"]) {
            self.gender = NSLocalizedString(@"wemenKey", nil);
        }if ([self.gender isEqualToString:@"2"]) {
            self.gender = NSLocalizedString(@"menKey", nil);
        }if ([self.gender isEqualToString:@"0"]) {
            self.gender = NSLocalizedString(@"A secret_key", nil);
        }
        self.avatar = [NSString stringWithFormat:@"%@",[dict objectForKey:@"avatar"] ];
        self.acount = [NSString stringWithFormat:@"%@",[dict objectForKey:@"hitachi_account"]];
        self.email = [NSString stringWithFormat:@"%@",[dict objectForKey:@"email"]];
//        self.town = [NSString stringWithFormat:@"%@",[dict objectForKey:@"town"]];
        self.city= [NSString stringWithFormat:@"%@",[dict objectForKey:@"city"]];
        self.district = [NSString stringWithFormat:@"%@",[dict objectForKey:@"district"]];
        self.is_loho = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"designer"] objectForKey:@"is_loho"] ] ;
        self.province_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"province_name"]];
        self.city_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"city_name"]];
//        self.district_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"district_name"]];
        self.district_name = [MPMemberModel addressToForm:[[dict objectForKey:@"district_name"] description]];

    }
    return self;
}


+ (instancetype)MemberWithDict:(NSDictionary *)dict {
    
    return [[MPMemberModel alloc]initWithDict:dict];
    
}

+ (void)MemberInformation:(NSString *)member_id withSuccess:(void(^) (MPMemberModel *model))success failure:(void(^) (NSError *error))failure {

    NSDictionary *header = [self getHeaderAuthorizationHsUid];

    [MPAPI createAccessPersonalInformationWithMemberId:member_id withRequestHeader:header success:^(NSDictionary *informationDict) {
                
        MPMemberModel *model = [MPMemberModel MemberWithDict:informationDict];
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        NSLog(@"error is **************%@",error);
    }];
    
}
+ (void)UpdataMemberInformation:(NSString *)member_id withParam:(NSDictionary *)param withSuccess:(void(^) (MPMemberModel *model))success failure:(void(^) (NSError *error))failure {

    NSDictionary *header = [self getHeaderAuthorizationHsUid];

    [MPAPI UpdataGetMemberInformationWith:member_id withParam:(NSDictionary *)param WithToken:header success:^(NSDictionary *dict) {
        NSLog(@"****************%@",dict);
        MPMemberModel *model = [MPMemberModel MemberWithDict:dict];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)DesignerInformation:(NSString *)member_id withSuccess:(void(^) (MPMemberModel *model))success failure:(void(^) (NSError *error))failure {

    NSDictionary * dic = [self getHeaderHsUid];
    
    [MPAPI getDesignersInformation:[self GetMemberID] withRequestHeard:dic WithSuccess:^(NSDictionary *dict) {
        
        NSLog(@"dict is -----------------%@",dict);
        MPMemberModel *model = [MPMemberModel MemberWithDict:dict];
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
        if (failure) {
            failure(error);
        }
    }];
    
    
}

/// 消息中心 用户登录后获取thread_id
+ (void)PostPersonalMessageMemberIDWithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure{
    
    [MPAPI PostPersonalMessageMemberIDWithSucces:^(NSDictionary *dict) {
        
        if (succes) {
            
        }
        
    }  failure:^(NSError *error) {
        NSLog(@"error is %@",error);
        if (failure) {
            failure(error);
        }
    }];

    
    
}

/// 消息中心 通过thread_id获取消息内容
+ (void)GetPerSonalMessageMemberIDWithThreadID:(NSString *)threadId WithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure{
    
//    [[MPAPI shareAPIManager] GetPerSonalMessageMemberIDWithThreadID:threadId WithSucces:^(NSDictionary *dict) {
//        
//        if (succes) {
//            
//        }
//        
//    } failure:^(NSError *error) {
//        NSLog(@"error is %@",error);
//        if (failure) {
//            failure(error);
//        }
//    }];
//
    
}


+ (void)updataMembersAvatar:(NSDictionary *)heard withFile:(NSData *)dataImage withSuccess:(void(^) (MPMemberModel *model))success failure:(void(^) (NSError *error))failure {
    
    [MPAPI updataMembersAvatar:heard withFile:dataImage witSuccess:^(NSDictionary *dict) {
        NSLog(@"***************%@",dict);
        NSLog(@"上传头像成功");
        
        NSLog(@"dict is -----------------%@",dict);
        MPMemberModel *model = [MPMemberModel MemberWithDict:dict];
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        NSLog(@"上传头像失败: %@",error.description);
    }];

}




+ (void)getSystemThread:(NSString*)memberId withSuccess:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError *error))failure {
    
    NSDictionary * header = [self getHeaderAuthorization];
    [MPAPI retrieveMemberThreads:[self GetMemberID] onlyAttachedToFile:YES header:header success:^(NSDictionary *dict) {
        NSDictionary * dic = dict;
        if (success) {
            success(dic);
        }
    } failure:^(NSError *error) {
        
        
    }];
}


@end
