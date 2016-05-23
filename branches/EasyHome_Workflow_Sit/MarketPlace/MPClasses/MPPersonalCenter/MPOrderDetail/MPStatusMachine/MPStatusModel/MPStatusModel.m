//
//  MPStatusModel.m
//  MarketPlace
//
//  Created by Jiao on 16/2/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPStatusModel.h"
#import "MPRegionManager.h"

@implementation MPStatusModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.workFlowModel = [[MPWorkFlowModel alloc]init];
        self.wk_measureModel = [[MPWKMeasureModel alloc]init];
        self.wk_orders = [[NSArray alloc]init];
        self.wk_contractModel = [[MPWKContractModel alloc]init];
    }
    return self;
}
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.needs_id = [self strFormat:dict[@"needs_id"]];
        self.designer_id = [self strFormat:dict[@"bidders"][0][@"designer_id"]];
        self.hs_uid = [self strFormat:dict[@"bidders"][0][@"uid"]];
        self.join_time = [self strFormat:dict[@"bidders"][0][@"join_time"]];
        
        NSDictionary *workFlowDic = @{@"wk_template_id":[self strFormat:dict[@"wk_template_id"]],
                                      @"wk_cur_node_id":[self strFormat:dict[@"bidders"][0][@"wk_cur_node_id"]],
                                      @"wk_cur_sub_node_id":[self strFormat:dict[@"bidders"][0][@"wk_cur_sub_node_id"]]};
        self.workFlowModel = [MPWorkFlowModel getWorkFlowWithDict:workFlowDic];
        
        NSDictionary *regionDic = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:[self strFormat:dict[@"province"]] withCityCode:[self strFormat:dict[@"city"]] andDistrictCode:[self strFormat:dict[@"district"]]];
        NSDictionary *wk_measureDic = @{@"contacts_name":[self strFormat:dict[@"contacts_name"]],
                                        @"contacts_mobile":[self strFormat:dict[@"contacts_mobile"]],
                                        @"design_budget":[self strFormat:dict[@"design_budget"]],
                                        @"decoration_budget":[self strFormat:dict[@"decoration_budget"]],
                                        @"house_type":[self strFormat:dict[@"house_type"]],
                                        @"house_area":[self strFormat:dict[@"house_area"]],
                                        @"living_room":[self strFormat:dict[@"living_room"]],
                                        @"room":[self strFormat:dict[@"room"]],
                                        @"toilet":[self strFormat:dict[@"toilet"]],
                                        @"decoration_style":[self strFormat:dict[@"decoration_style"]],
                                        @"measure_time":[self strFormat:dict[@"bidders"][0][@"measure_time"]],
                                        @"province":regionDic[@"province"],
                                        @"city":regionDic[@"city"],
                                        @"district":[regionDic[@"district"] isEqualToString:@"0"] ? @"" : regionDic[@"district"],
                                        @"community_name":[self strFormat:dict[@"community_name"]],
                                        @"measurement_fee":[self strFormat:dict[@"bidders"][0][@"measurement_fee"]],
                                        };
        self.wk_measureModel = [MPWKMeasureModel getWKMeasureModelWithDict:wk_measureDic];
        
        NSArray *orderArr = [NSArray arrayWithArray:dict[@"bidders"][0][@"orders"]];
        NSMutableArray *wk_ordersArr = [NSMutableArray array];
        for (NSDictionary *orderDic in orderArr) {
            [wk_ordersArr addObject:[MPWKOrderModel getWKOrderModelWithDict:orderDic]];
        }
        self.wk_orders = [NSArray arrayWithArray:wk_ordersArr];
        
        self.wk_contractModel = [MPWKContractModel getWKContractModelWithDict:dict[@"bidders"][0][@"design_contract"]];
    }
    return self;
}
+ (instancetype)getCurrentStatusModelWithDict:(NSDictionary *)dict {
    return [[MPStatusModel alloc]initWithDict:dict];
}

- (NSString *)strFormat:(id)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@",obj];
}
@end

@implementation MPStatusDetail

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.message = dict[@"message"];
        self.selectShow = [dict[@"selectShow"] boolValue];
    }
    return self;
}

+ (instancetype)getStatusDetailWithDict:(NSDictionary *)dict {
    return [[MPStatusDetail alloc]initWithDict:dict];
}

@end