//
//  MPMeasureDetailModel.m
//  MarketPlace
//
//  Created by Jiao on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMeasureDetailModel.h"
#import "MPAPI.h"

@implementation MPMeasureDetailModel

+ (void)confirmMeasureWithNeedsID:(NSString *)needs_id
                       andSuccess:(void(^)(NSDictionary *))success
                       andFaiulre:(void(^)(NSError *))failure {
    
    [MPMeasureDetailModel confirmOrRefuse:YES
                              withNeedsID:needs_id
                               andSuccess:success andFailure:failure];
}

+ (void)refuseMeasureWithNeedsID:(NSString *)needs_id
                      andSuccess:(void (^)(NSDictionary *))success
                      andFaiulre:(void (^)(NSError *))failure {
    
    [MPMeasureDetailModel confirmOrRefuse:NO
                              withNeedsID:needs_id
                               andSuccess:success andFailure:failure];
}

#pragma mark - Public Method
+ (void)confirmOrRefuse:(BOOL)flag
            withNeedsID:(NSString *)needs_id
             andSuccess:(void(^)(NSDictionary *))success
             andFailure:(void(^)(NSError *))failure {
    
    NSDictionary *headerDict =[self getHeaderAuthorization];
    
    [MPAPI confirmOrRefuseMeasure:flag withNeedsID:needs_id withHeader:headerDict andSuccess:^(NSDictionary *dictionary) {
        if (success) {
            success(dictionary);
        }
    } andFailure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
