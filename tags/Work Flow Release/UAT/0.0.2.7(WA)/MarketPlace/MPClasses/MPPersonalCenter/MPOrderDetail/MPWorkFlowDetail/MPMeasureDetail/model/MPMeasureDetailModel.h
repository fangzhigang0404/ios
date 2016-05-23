//
//  MPMeasureDetailModel.h
//  MarketPlace
//
//  Created by Jiao on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPMeasureDetailModel : MPModel

+ (void)confirmMeasureWithNeedsID:(NSString *)needs_id
                       andSuccess:(void(^)(NSDictionary *dictionary))success
                       andFaiulre:(void(^)(NSError *error))failure;

+ (void)refuseMeasureWithNeedsID:(NSString *)needs_id
                       andSuccess:(void(^)(NSDictionary *dictionary))success
                       andFaiulre:(void(^)(NSError *error))failure;

//+ (void)getMeasureDetailWithSuccess:(void(^)())success;

@end
