//
//  MPStatusModel.h
//  MarketPlace
//
//  Created by Jiao on 16/2/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"
#import "MPWorkFlowModel.h"
#import "MPWKMeasureModel.h"
#import "MPWKOrderModel.h"
#import "MPWKContractModel.h"

@interface MPStatusModel : MPModel
@property (nonatomic, copy) NSString *needs_id;//需求id
@property (nonatomic, copy) NSString *designer_id;//设计师id
@property (nonatomic, copy) NSString *hs_uid;//homestyler uid
@property (nonatomic, copy) NSString *join_time;
@property (nonatomic, copy) NSString *designer_mobile;
@property (nonatomic, copy) NSString *designer_realName;
@property (nonatomic, copy) NSString *designer_email;
@property (nonatomic, strong) MPWorkFlowModel *workFlowModel;
@property (nonatomic, strong) MPWKMeasureModel *wk_measureModel;
@property (nonatomic, strong) NSArray <MPWKOrderModel *> *wk_orders;
@property (nonatomic, strong) MPWKContractModel *wk_contractModel;


+ (instancetype)getCurrentStatusModelWithDict:(NSDictionary *)dict;
@end

@interface MPStatusDetail : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL selectShow;
+ (instancetype)getStatusDetailWithDict:(NSDictionary *)dict;
@end