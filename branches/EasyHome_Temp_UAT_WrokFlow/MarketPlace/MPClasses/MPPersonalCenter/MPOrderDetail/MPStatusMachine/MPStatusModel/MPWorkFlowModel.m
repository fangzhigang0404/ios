/**
 * @file    MPWorkFlowModel.m
 * @brief   the model of work flow.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-29
 *
 */

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
