//
//  MPDesignerWithdrawModel.m
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignerWithdrawModel.h"

@interface MPDesignerWithdrawModel ()

@end
@implementation MPDesignerWithdrawModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
  
        self.bank_name = [NSString stringWithFormat:@"%@",dict[@"bank_name"]];
        self.timeString = [NSString stringWithFormat:@"%@",dict[@"date"]];
        self.transLog_id = [NSString stringWithFormat:@"%@",dict[@"transLog_id"]];
        self.amount = [NSString stringWithFormat:@"%@",dict[@"amount"]];
        self.status = [NSString stringWithFormat:@"%@",dict[@"status"]];
        self.remark = [NSString stringWithFormat:@"%@",dict[@"remark"]];
        
    }
    return self;
}

+ (instancetype)demandWithDict:(NSDictionary *)dict {
    
    return [[MPDesignerWithdrawModel alloc]initWithDict:dict];
}

+(void)getDesignerWithDraw:(NSString *)designer_id withParameter:(NSDictionary *)paramDict success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure {
    
    [MPAPI getDesignersWithdraw:designer_id withParameter:paramDict withSuccess:^(NSDictionary *dict) {
        
        NSLog(@"我的提现:%@",dict);
        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
        

        for (NSDictionary *designersDict in dict[@"translog_list"]) {
            
            [resultArray addObject:[MPDesignerWithdrawModel demandWithDict:designersDict]];
            
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
