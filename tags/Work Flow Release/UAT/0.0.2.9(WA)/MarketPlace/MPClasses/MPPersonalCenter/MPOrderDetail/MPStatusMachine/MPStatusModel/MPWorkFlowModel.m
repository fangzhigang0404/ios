//
//  MPWorkFlowModel.m
//  MarketPlace
//
//  Created by Jiao on 16/2/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWorkFlowModel.h"

@implementation MPWorkFlowModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)getWorkFlowWithDict:(NSDictionary *)dict {
    return [[MPWorkFlowModel alloc]initWithDict:dict];
}
@end
