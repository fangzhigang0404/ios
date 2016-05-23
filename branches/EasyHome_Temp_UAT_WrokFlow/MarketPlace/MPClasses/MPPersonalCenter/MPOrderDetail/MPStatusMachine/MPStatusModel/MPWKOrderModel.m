/**
 * @file    MPWKOrderModel.m
 * @brief   the model of order for payment.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-29
 *
 */

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
