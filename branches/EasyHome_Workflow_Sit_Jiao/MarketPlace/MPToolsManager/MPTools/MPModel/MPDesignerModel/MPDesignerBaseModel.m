//
//  MPDesignerBaseModel.m
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignerBaseModel.h"

@implementation MPDesignerBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (![dict isKindOfClass:[NSNull class]]) {
            [self getModelWithDict:dict];
        }
    }
    return self;
}

- (void)getModelWithDict:(NSDictionary *)dict {
    if ([dict allKeys].count == 0) return;

    self.count = dict[@"count"];
    self.limit = dict[@"limit"];
    self.offset = dict[@"offset"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dic in dict[@"designer_list"]) {
        MPDesignerInfoModel *model = [[MPDesignerInfoModel alloc] initWithDictionary:dic];
        [array addObject:model];
    }
    self.designer_list = (id)array;
}

+ (void)getDataWithParameters:(NSDictionary *)dictionary success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    
    [MPAPI getDesignersListWithUrl:dictionary header:nil body:nil success:^(NSDictionary *dict) {
        

        MPDesignerBaseModel *model = [[MPDesignerBaseModel alloc] initWithDictionary:dict];
        if (success) {
            success(model.designer_list);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)getDesignerInfoWithParam:(NSDictionary *)param
                         success:(void (^)(MPDesignerInfoModel* model))success
                         failure:(void(^) (NSError *error))failure {

    NSDictionary *dictHeader = @{@"hs_uid" : param[@"hs_uid"]};
    [MPAPI getDesignerInfoWithUrl:param header:dictHeader body:nil success:^(NSDictionary *dictionary) {
        MPDesignerInfoModel *model = [[MPDesignerInfoModel alloc] initWithDictionary:dictionary];
        NSLog(@"%@",dictionary);
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
