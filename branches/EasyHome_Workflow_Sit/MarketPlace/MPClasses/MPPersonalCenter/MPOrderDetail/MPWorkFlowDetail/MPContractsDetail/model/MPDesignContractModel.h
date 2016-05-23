//
//  MPDesignContractModel.h
//  MarketPlace
//
//  Created by Jiao on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@class MPWKContractModel;
@interface MPDesignContractModel : MPModel

@property (nonatomic, assign) BOOL isNew;

@property (nonatomic,strong)NSString * contract_no;

@property (nonatomic,copy)NSString *consumer_id;
@property (nonatomic,copy)NSString *consumer_name;
@property (nonatomic,copy)NSString *consumer_mobile;
@property (nonatomic,copy)NSString *consumer_zipCode;
@property (nonatomic,copy)NSString *consumer_email;
@property (nonatomic,copy)NSString *consumer_addr;
@property (nonatomic,copy)NSString *consumer_addrDe;

@property (nonatomic,copy)NSString *designer_id;
@property (nonatomic,copy)NSString *designer_name;
@property (nonatomic,copy)NSString *designer_mobile;
@property (nonatomic,copy)NSString *designer_zipCode;
@property (nonatomic,copy)NSString *designer_email;
@property (nonatomic,copy)NSString *designer_addr;
@property (nonatomic,copy)NSString *designer_addrDe;

@property (nonatomic, copy) NSString *design_sketch;//效果图
@property (nonatomic, copy) NSString *render_map;//渲染图
@property (nonatomic, copy) NSString *design_sketch_plus;//每增加一张效果图费用
@property (nonatomic,copy)NSString *contract_charge;//总额
@property (nonatomic,copy)NSString *contract_first_charge;//设计首款
@property (nonatomic,copy)NSString *balance_payment;//尾款

+ (instancetype)designContractWithModel:(MPWKContractModel *)model;

+ (instancetype)designContractWithDict:(NSDictionary *)dict;

+ (void)createDesignContractWithNeedID:(NSString*)needid
                             withModel:(MPDesignContractModel *)model
                               success:(void(^) (MPDesignContractModel *model))success
                               failure:(void(^) (NSError *error))failure;

+ (void)getContractNOWithSuccess:(void(^)(NSString *contract_no))success
                      andFailure:(void(^)())failure;

+ (void)getDesignerInformationWithDesignerID:(NSString *)designer_id
                                   withHSUID:(NSString *)hs_uid
                                 withSuccess:(void(^)(NSString *realName, NSString *mobile,NSString *email))success
                                  andFailure:(void(^)(NSError *error))failure;
@end
