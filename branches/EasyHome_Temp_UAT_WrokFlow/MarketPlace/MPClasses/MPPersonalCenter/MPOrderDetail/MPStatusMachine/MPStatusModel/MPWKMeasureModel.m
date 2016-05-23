/**
 * @file    MPWKMeasureModel.m
 * @brief   the model of measurement.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-29
 *
 */

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
