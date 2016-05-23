//
//  MPCaseBaseModel.h
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"
#import "MPCaseModel.h"

@interface MPCaseBaseModel : MPModel

@property (nonatomic, retain) NSArray<MPCaseModel> *cases;
@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *limit;
@property (nonatomic, retain) NSNumber *offset;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

/// 获取案例库列表
+ (void)getCaseLibrayWithOffset:(NSString *)offset limit:(NSString *)limlt custom_string_area:(NSString *)area custom_string_form:(NSString *)form custom_string_style:(NSString *)style custom_string_type:(NSString *)type custom_string_keywords:(NSString *)keywords success:(void (^)(NSArray *array))success failure:(void(^) (NSError *error))failure;

/// 获取案例详情
+ (void)getCaseDetailInfoWithCaseId:(NSString *)caseid success:(void (^)(MPCaseModel *caseDetailModel))success failure:(void(^) (NSError *error))failure;

+ (void)getSearchCaseLibrayWithOffset:(NSString *)offset limit:(NSString *)limlt custom_string_area:(NSString *)area custom_string_form:(NSString *)form custom_string_style:(NSString *)style custom_string_type:(NSString *)type success:(void (^)(NSArray *array))success failure:(void(^) (NSError *error))failure;
@end
