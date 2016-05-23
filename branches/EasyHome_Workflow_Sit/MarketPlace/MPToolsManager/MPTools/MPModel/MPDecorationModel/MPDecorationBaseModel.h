//
//  MPDecorationBaseModel.h
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"
#import "MPDecorationNeedModel.h"

@interface MPDecorationBaseModel : MPModel

@property (nonatomic, retain) NSNumber *count;

@property (nonatomic, retain) NSNumber *offset;

@property (nonatomic, retain) NSNumber *limit;

@property (nonatomic, retain) NSArray<MPDecorationNeedModel> *needs_list;

/// Using the dictionary to initialize the model
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/// mark hall.
+ (void)createMarkHallWithUrlDict:(NSDictionary *)dictionary
                          success:(void (^)(NSArray *array))success
                          failure:(void (^)(NSError *error))failure;

+ (void)issueDemandWithParam:(NSDictionary *)param
               requestHeader:(NSDictionary *)header
                     success:(void (^)(NSDictionary* dict))success
                     failure:(void(^) (NSError *error))failure;

+ (void)measureByConsumerSelfChooseDesignerNoNeedIdWithParam:(NSDictionary *)param
                                               requestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success
                                                     failure:(void(^) (NSURLSessionDataTask *task, NSError *error))failure;

+ (void)createModifyDecorateDemandWithNeedsId:(NSString *)needsId
                               withParameters:(NSDictionary *)parametersDict
                            withRequestHeader:(NSDictionary *)header
                                      success:(void(^) (NSDictionary *dict))success
                                      failure:(void(^) (NSError *error))failure;

+ (void)createCancleDecorateDemandWithNeedId:(NSString *)needId
                               requestHeader:(NSDictionary *)header
                                     Success:(void (^)(NSString* string))success
                                     failure:(void(^) (NSError *error))failure;

+ (void)createDecorateDetailWithNeedsId:(NSString *)needsId
                                success:(void(^) (NSDictionary *dict))success
                                failure:(void(^) (NSError *error))failure;

+ (void)measureByConsumerSelfChooseDesignerWithParam:(NSDictionary *)param
                                       requestHeader:(NSDictionary *)header
                                             success:(void (^)(NSDictionary* dict))success
                                             failure:(void(^) (NSURLSessionDataTask *task, NSError *error))failure;

+ (void)deleteDesignerWithNeedId:(NSString *)needId
                      designerId:(NSString *)designerId
                  withParameters:(NSDictionary *)parametersDict
               withRequestHeader:(NSDictionary *)header
                         success:(void(^) (NSDictionary *dictionary))success
                         failure:(void(^) (NSError *error))failure;

@end
