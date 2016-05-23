//
//  MPWKOrderModel.m
//  MarketPlace
//
//  Created by Jiao on 16/2/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWKOrderModel.h"

@implementation MPWKOrderModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)getWKOrderModelWithDict:(NSDictionary *)dict {
    return [[MPWKOrderModel alloc]initWithDict:dict];
}
@end
