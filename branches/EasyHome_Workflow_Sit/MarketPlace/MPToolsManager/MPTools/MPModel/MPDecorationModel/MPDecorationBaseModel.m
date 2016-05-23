//
//  MPDecorationBaseModel.m
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDecorationBaseModel.h"

@implementation MPDecorationBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (![dictionary isKindOfClass:[NSNull class]]) {
            [self dictionaryChangeToModel:dictionary];
        }
    }
    return self;
}

- (void)dictionaryChangeToModel:(NSDictionary *)dict {
    if ([dict allKeys].count == 0) return;
    
    self.count = dict[@"count"];
    self.limit = dict[@"limit"];
    self.offset = dict[@"offset"];
    
    NSMutableArray * arrayNeeds = [NSMutableArray array];
    for (NSDictionary *dic in dict[@"needs_list"]) {
        MPDecorationNeedModel * model = [[MPDecorationNeedModel alloc] initWithDictionary:dic];
        [arrayNeeds addObject:model];
    }
    self.needs_list = (id)arrayNeeds;
}

+ (void)getDataWithParameters:(NSDictionary *)dictionary success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    WS(weakSelf);
    NSDictionary *headerDict = [self getHeaderAuthorization];
    [MPAPI createDecorateDemandListWithOffset:dictionary[@"offset"] withMemberId:[self GetMemberID] withLimit:dictionary[@"limit"] withRequestHeader:headerDict success:^(NSDictionary *dict) {
        
        MPDecorationBaseModel *model = [[MPDecorationBaseModel alloc] initWithDictionary:dict];
        if (success) {
            
            if ([dictionary[@"is_need"] isEqualToString:@"yes"]) {
                
                success([weakSelf checkNeeds:model.needs_list]);
            } else {
                success(model.needs_list);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (NSArray *)checkNeeds:(NSArray *)array {
    NSMutableArray *arr1 = [NSMutableArray array];
    NSMutableArray *arr2 = [NSMutableArray array];
    for (MPDecorationNeedModel *modelNeed in array) {
        if (!([[modelNeed.is_beishu description] isEqualToString:@"0"]) && !([modelNeed.wk_template_id isEqualToString:@"2"])) {
            [arr1 addObject:modelNeed];
            [arr2 addObject:[NSNumber numberWithBool:YES]];
        }
    }
    return @[[arr1 copy],[arr2 copy]];
}

+ (void)createMarkHallWithUrlDict:(NSDictionary *)dictionary success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {

    NSDictionary *headerDict = [self getHeaderAuthorization];

    [MPAPI createMarkHallWithUrl:dictionary header:headerDict body:nil success:^(NSDictionary *dict) {
        
        NSMutableArray *array = [NSMutableArray array];
        MPDecorationBaseModel *model = [[MPDecorationBaseModel alloc] initWithDictionary:dict];
        for (MPDecorationNeedModel *needModel in model.needs_list) {
            if ([needModel.is_beishu isEqualToString:@"1"]) {
                [array addObject:needModel];
            }
        }
        
        if (success) {
            success(array);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)issueDemandWithParam:(NSDictionary *)param
               requestHeader:(NSDictionary *)header
                     success:(void (^)(NSDictionary* dict))success
                     failure:(void(^) (NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];
    [MPAPI issueDemandWithParam:param requestHeader:headerDict success:^(NSDictionary *dict) {
        if (success) {
            success(dict);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)measureByConsumerSelfChooseDesignerNoNeedIdWithParam:(NSDictionary *)param
                                               requestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success
                                                     failure:(void(^) (NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];

    [MPAPI measureByConsumerSelfChooseDesignerNoNeedIdWithParam:param requestHeader:headerDict success:^(NSDictionary *dict) {
        
        NSArray *array = dict[@"bidders"];
        NSString *thread_id;
        if ([array isKindOfClass:[NSArray class]] && array.count > 0) {
            thread_id = array[0][@"design_thread_id"];
        }
        
        if (thread_id == nil || [thread_id isKindOfClass:[NSNull class]] ||[thread_id rangeOfString:@"null"].length == 4) {
            thread_id = @"";
        }

        [[NSNotificationCenter defaultCenter] postNotificationName:MPMeasureSuccess
                                                            object:@{@"needs_id"  : dict[@"needs_id"],
                                                                     @"thread_id" : thread_id}];

        if (success) {
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

+ (void)createModifyDecorateDemandWithNeedsId:(NSString *)needsId
                               withParameters:(NSDictionary *)parametersDict
                            withRequestHeader:(NSDictionary *)header
                                      success:(void(^) (NSDictionary *dict))success
                                      failure:(void(^) (NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];

    [MPAPI createModifyDecorateDemandWithNeedsId:needsId withParameters:parametersDict withRequestHeader:headerDict success:^(NSDictionary *dict) {
        if (success) {
            success(dict);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)createCancleDecorateDemandWithNeedId:(NSString *)needId
                               requestHeader:(NSDictionary *)header
                                     Success:(void (^)(NSString* string))success
                                     failure:(void(^) (NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];

    [MPAPI createCancleDecorateDemandWithNeedId:needId requestHeader:headerDict Success:^(NSString *string) {
        if (success) {
            success(string);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)createDecorateDetailWithNeedsId:(NSString *)needsId
                                success:(void(^) (NSDictionary *dict))success
                                failure:(void(^) (NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];
    
    [MPAPI createDecorateDetailWithNeedsId:needsId requestHeader:headerDict success:^(NSDictionary *dict) {
        if (success) {
            success(dict);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)measureByConsumerSelfChooseDesignerWithParam:(NSDictionary *)param
                                       requestHeader:(NSDictionary *)header
                                             success:(void (^)(NSDictionary* dict))success
                                             failure:(void(^) (NSURLSessionDataTask *task, NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];

    [MPAPI measureByConsumerSelfChooseDesignerWithParam:param requestHeader:headerDict success:^(NSDictionary *dict) {
        if (success) {
            success(dict);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task, error);
        }
    }];
}

+ (void)deleteDesignerWithNeedId:(NSString *)needId
                      designerId:(NSString *)designerId
                  withParameters:(NSDictionary *)parametersDict
               withRequestHeader:(NSDictionary *)header
                         success:(void(^) (NSDictionary *dictionary))success
                         failure:(void(^) (NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];

    [MPAPI deleteDesignerWithNeedId:needId
                         designerId:designerId
                     withParameters:nil withRequestHeader:headerDict
                            success:^(NSDictionary *dictionary) {
        if (success) {
            success(dictionary);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
