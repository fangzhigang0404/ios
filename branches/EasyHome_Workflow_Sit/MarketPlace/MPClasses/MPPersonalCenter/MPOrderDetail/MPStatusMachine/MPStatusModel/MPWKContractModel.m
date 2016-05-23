//
//  MPWKContractModel.m
//  MarketPlace
//
//  Created by Jiao on 16/2/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWKContractModel.h"

@implementation MPWKContractModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.contract_charge = [self formatStr:dict forKey:@"contract_charge"];
        self.contract_create_date = [self formatStr:dict forKey:@"contract_create_date"];
        self.contract_data = [self formatStr:dict forKey:@"contract_data"];
        self.contract_first_charge = [self formatStr:dict forKey:@"contract_first_charge"];
        self.contract_no = [self formatStr:dict forKey:@"contract_no"];
        self.contract_status = [self formatStr:dict forKey:@"contract_status"];
        self.contract_type = [self formatStr:dict forKey:@"contract_type"];
        self.contract_template_url = [self formatStr:dict forKey:@"contract_template_url"];
        self.contract_update_date = [self formatStr:dict forKey:@"contract_update_date"];
        self.designer_id = [self formatStr:dict forKey:@"designer_id"];
    }
    return self;
}
- (NSString *)formatStr:(id)obj forKey:(NSString *)key {

    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",[obj objectForKey:key]];
}

+ (instancetype)getWKContractModelWithDict:(NSDictionary *)dict {
    return [[MPWKContractModel alloc]initWithDict:dict];
}
@end
