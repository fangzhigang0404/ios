//
//  MPMemberModel.h
//  MarketPlace
//
//  Created by leed on 16/1/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPMemberModel : MPModel

@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *avatar;
@property (nonatomic,copy)NSString *first_name;
@property (nonatomic,copy)NSString *gender;
@property (nonatomic,copy)NSString *mobile_number;
@property (nonatomic,copy)NSString *nick_name;
@property (nonatomic,copy)NSString *user_email;
@property (nonatomic,copy)NSString *certificate_code;
@property (nonatomic,copy)NSString *certificate_type;
@property (nonatomic,copy)NSString *true_name;
@property (nonatomic,copy)NSString *acount;
@property (nonatomic,copy)NSString *email;
@property (nonatomic,copy)NSString *hitachi_account;
@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *town;
@property (nonatomic,copy)NSString *district;
@property (nonatomic,copy)NSString *province_name;
@property (nonatomic,copy)NSString *city_name;
@property (nonatomic,copy)NSString *district_name;

@property (nonatomic,copy)NSString *home_phone;
@property (nonatomic,copy)NSString *birthday;
@property (nonatomic,copy)NSString *zip_code;

@property (nonatomic,copy)NSString *id_card;
@property (nonatomic,copy)NSString *measurement_price;
@property (nonatomic,copy)NSString *design_price_max;
@property (nonatomic,copy)NSString *design_price_min;
@property (nonatomic,copy)NSString *is_loho;

@property (nonatomic,copy)NSString *style_long_names;
@property (nonatomic,copy)NSString *introduction;
@property (nonatomic,copy)NSString *experience;
@property (nonatomic,copy)NSString *case_count;
@property (nonatomic,copy)NSString *personal_honour;
@property (nonatomic,copy)NSString *diy_count;
@property (nonatomic,copy)NSString *theme_pic;


+ (instancetype)MemberWithDict:(NSDictionary *)dict;

+ (void)MemberInformation:(NSString *)member_id withSuccess:(void(^) (MPMemberModel *model))success failure:(void(^) (NSError *error))failure;
+ (void)UpdataMemberInformation:(NSString *)member_id withParam:(NSDictionary *)param withSuccess:(void(^) (MPMemberModel *model))success failure:(void(^) (NSError *error))failure;
+ (void)DesignerInformation:(NSString *)member_id withSuccess:(void(^) (MPMemberModel *model))success failure:(void(^) (NSError *error))failure;

+ (void)updataMembersAvatar:(NSDictionary *)heard withFile:(NSData *)dataImage withSuccess:(void(^) (MPMemberModel *model))success failure:(void(^) (NSError *error))failure;

+ (void)GetPerSonalMessageMemberIDWithThreadID:(NSString *)threadId WithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure;

+ (void)PostPersonalMessageMemberIDWithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure;

+ (void)getSystemThread:(NSString*)memberId withSuccess:(void(^)(NSDictionary* dic))success failure:(void(^)(NSError *error))failure;

@end
