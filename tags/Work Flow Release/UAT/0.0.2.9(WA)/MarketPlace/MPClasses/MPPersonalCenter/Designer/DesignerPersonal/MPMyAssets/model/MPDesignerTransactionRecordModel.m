//
//  MPDesignerTransactionRecordModel.m
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignerTransactionRecordModel.h"
#import "MPAPI.h"
@implementation MPDesignerTransactionRecordModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
        self.name = [NSString stringWithFormat:@"%@",dict[@"name"]];
        self.name= [MPDesignerTransactionRecordModel formatDic:self.name];
        self.create_date = [NSString stringWithFormat:@"%@",dict[@"create_date"]];
        self.adjustment = [NSString stringWithFormat:@"%.2f",[dict[@"adjustment"] floatValue]];
        self.order_line_id = [NSString stringWithFormat:@"%@",dict[@"order_line_id"]];
        self.title = [NSString stringWithFormat:@"%@",dict[@"title"]];
        self.type = [NSString stringWithFormat:@"%@",dict[@"type"]];

    }
    return self;
}

+ (instancetype)demandWithDict:(NSDictionary *)dict {
    
    return [[MPDesignerTransactionRecordModel alloc]initWithDict:dict];
}

+(void)getDesignerTransactionTecord:(NSString *)designer_id withParameter:(NSDictionary *)paramDict success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure {
    
    [MPAPI getDesignerTransactionRecord:designer_id withParameter:paramDict withSuccess:^(NSDictionary *dict) {
        
        NSLog(@"我的资产的信息:%@",dict);
        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
        
        for (NSDictionary *designersDict in dict[@"designer_trans_list"]) {
            
                [resultArray addObject:[MPDesignerTransactionRecordModel demandWithDict:designersDict]];
            
        }
        
        if (success) {
            success(resultArray);
        }

    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }

    }];
}
@end
