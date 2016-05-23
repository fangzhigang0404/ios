//
//  MP3DPlanDetailModel.m
//  MarketPlace
//
//  Created by Jiao on 16/3/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MP3DPlanDetailModel.h"

@implementation MP3DPlanDetailModel

- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.extended_data = [NSString stringWithFormat:@"%@",dict[@"extended_data"]];
        self.fileid = [NSString stringWithFormat:@"%@",dict[@"id"]];
        self.link = [NSString stringWithFormat:@"%@",dict[@"link"]];
        self.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.source = [NSString stringWithFormat:@"%@",dict[@"source"]];
        self.source_id = [NSString stringWithFormat:@"%@",dict[@"source_id"]];
        self.status = [NSString stringWithFormat:@"%@",dict[@"status"]];
        self.type = [[NSString stringWithFormat:@"%@",dict[@"type"]] integerValue];
        
        ///360全景图未定
        if (self.type == PlanTypeFor360) {
            self.submit_id = self.source_id;
        }else {
            self.submit_id = self.fileid;
        }  
    }
    return self;
}

+ (instancetype)get3DPlanDetailWithDict:(NSDictionary *)dict {
    return [[MP3DPlanDetailModel alloc] initWithDict:dict];
}

@end
