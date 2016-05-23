//
//  MPWKMeasureModel.m
//  MarketPlace
//
//  Created by Jiao on 16/2/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWKMeasureModel.h"

@implementation MPWKMeasureModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)getWKMeasureModelWithDict:(NSDictionary *)dict {
    return [[MPWKMeasureModel alloc]initWithDict:dict];
}
@end
