//
//  MPCaseBaseModel.m
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPCaseBaseModel.h"

@implementation MPCaseBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self createModelWithDict:dict];
    }
    return self;
}

- (void)createModelWithDict:(NSDictionary *)dict {
    if ([dict allKeys].count == 0) return;
    
    self.limit = dict[@"limit"];
    self.offset = dict[@"offset"];
    self.count = dict[@"count"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dict[@"cases"]) {
        MPCaseModel *model = [[MPCaseModel alloc] initWithDictionary:dic];
        [array addObject:model];
    }
    self.cases = (id)array;
}

+ (void)getDataWithParameters:(NSDictionary *)dictionary success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {

    [MPAPI getListOfDesignerCasesWithUrl:dictionary header:nil body:nil success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
        MPCaseBaseModel *model = [[MPCaseBaseModel alloc] initWithDictionary:dict];
        if (success) {
            success(model.cases);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getCaseLibrayWithOffset:(NSString *)offset limit:(NSString *)limlt custom_string_area:(NSString *)area custom_string_form:(NSString *)form custom_string_style:(NSString *)style custom_string_type:(NSString *)type custom_string_keywords:(NSString *)keywords success:(void (^)(NSArray *array))success failure:(void(^) (NSError *error))failure {
    [MPAPI crateCaseLibrayWithOffset:offset withLimit:limlt custom_string_area:area custom_string_form:form custom_string_style:style custom_string_type:type custom_string_keywords:keywords success:^(NSDictionary *Dic) {

        NSLog(@"%@",Dic);
        MPCaseBaseModel *model = [[MPCaseBaseModel alloc] initWithDictionary:Dic];
        if (success) {
            success(model.cases);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getCaseDetailInfoWithCaseId:(NSString *)caseid success:(void (^)(MPCaseModel *caseDetailModel))success failure:(void(^) (NSError *error))failure {
    [MPAPI createCaseLibrayDetailWithCaseID:caseid Success:^(NSDictionary *dict) {
        MPCaseModel *model = [[MPCaseModel alloc] initWithDictionary:dict];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getSearchCaseLibrayWithOffset:(NSString *)offset limit:(NSString *)limlt custom_string_area:(NSString *)area custom_string_form:(NSString *)form custom_string_style:(NSString *)style custom_string_type:(NSString *)type success:(void (^)(NSArray *array))success failure:(void(^) (NSError *error))failure {
    
}


@end
