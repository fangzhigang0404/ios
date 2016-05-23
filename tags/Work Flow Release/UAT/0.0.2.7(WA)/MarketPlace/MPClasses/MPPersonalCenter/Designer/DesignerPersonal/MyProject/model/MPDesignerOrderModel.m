//
//  MPDesignerOrderModel.m
//  MarketPlace
//
//  Created by xuezy on 16/2/24.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignerOrderModel.h"
#import "MPAPI.h"
#import "MPStatusModel.h"
 

@implementation MPDesignerOrderModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
    
        
        self.needName=[NSString stringWithFormat:@"%@", dict[@"needs_name"]];
        self.headImage = [dict objectForKey:@"img"];
        self.needs_id = [NSString stringWithFormat:@"%@",dict[@"needs_id"]];
        self.house_type = [NSString stringWithFormat:@"%@",dict[@"house_type"]];
        self.room = [NSString stringWithFormat:@"%@",dict[@"room"]];
        self.living_room = [NSString stringWithFormat:@"%@",dict[@"living_room"]];
        self.toilet = [NSString stringWithFormat:@"%@",dict[@"toilet"]];
        self.house_area = [NSString stringWithFormat:@"%@",dict[@"house_area"]];
        self.decoration_style = [NSString stringWithFormat:@"%@",dict[@"decoration_style"]];
        self.renovation_budget = [NSString stringWithFormat:@"%@",dict[@"renovation_budget"]];
        self.province = [NSString stringWithFormat:@"%@",dict[@"province_name"]];
        self.city = [NSString stringWithFormat:@"%@",dict[@"city_name"]];
        
        self.district = [NSString stringWithFormat:@"%@",dict[@"district_name"]];
        
        self.neighbourhoods = [NSString stringWithFormat:@"%@",dict[@"community_name"]];
        self.img_url = [NSString stringWithFormat:@"%@",dict[@"img_url"]];
        
        self.img_name = [NSString stringWithFormat:@"%@",dict[@"img_name"]];
        self.publish_time = [NSString stringWithFormat:@"%@",dict[@"publish_time"]];
        self.tendererName = [NSString stringWithFormat:@"%@",dict[@"needs_name"]];
        self.contacts_mobile = [NSString stringWithFormat:@"%@",dict[@"contacts_mobile"]];
        self.contacts_name = [NSString stringWithFormat:@"%@",dict[@"contacts_name"]];
        self.detail_desc = [NSString stringWithFormat:@"%@",dict[@"detail_desc"]];
        self.bidder_count = [NSString stringWithFormat:@"%@",dict[@"bidder_count"]];
        self.status= [NSString stringWithFormat:@"%@",dict[@"status"]];
        self.dayNumber = [NSString stringWithFormat:@"%@",dict[@"end_day"]];
        self.workflow_step_id = [NSString stringWithFormat:@"%@",dict[@"workflow_step_id"]];
        
         if (![dict[@"bidders"] isKindOfClass:[NSNull class]])
         {
             self.designer_id = [NSString stringWithFormat:@"%@",[[dict[@"bidders"] objectAtIndex:0] objectForKey:@"designer_id"]];
             self.wk_sub_node_id = [NSString stringWithFormat:@"%@",[[dict[@"bidders"] objectAtIndex:0] objectForKey:@"wk_cur_sub_node_id"]];
             
             self.bidding_status = [NSString stringWithFormat:@"%@",[[dict[@"bidders"] objectAtIndex:0] objectForKey:@"status"]];
             
         }
        
       
    }
    return self;
}

+ (instancetype)demandWithDict:(NSDictionary *)dict {
    
    return [[MPDesignerOrderModel alloc]initWithDict:dict];
}

+(void)createDesignerMyMarkListWithOffset:(NSString *)offset withLimit:(NSString *)limit success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];
    
    [MPAPI createDesignerMyMarkListWithDesignerId:[self GetMemberID] WithOffset:offset withLimit:limit withSort_by:@"date" withSort_order:@"desc" withRequestHeader:headerDict success:^(NSDictionary *dict) {
        
        NSLog(@"********%@",dict);
        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
        
        for (NSDictionary *designersDict in dict[@"bidding_needs_list"]) {
            NSString *beishu = [NSString stringWithFormat:@"%@",designersDict[@"is_beishu"]];
            if (![designersDict[@"bidder"] isKindOfClass:[NSNull class]] && [beishu isEqualToString:@"1"]) {
                [resultArray addObject:[MPDesignerOrderModel demandWithDict:designersDict]];
                
            }
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

+(void)createDesignerOrdersListWithParameters:(NSDictionary *)dictionary success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure {
    NSDictionary *headerDict = [self getHeaderAuthorization];
    
    [MPAPI GetorderListOFdesignerWithDesignerID:[self GetMemberID] withOffset:dictionary[@"offset"] withLimit:dictionary[@"limit"] requestHeader:headerDict success:^(NSDictionary *dict) {
        
        NSLog(@"我的项目普通订单:%@",dict);
        
        if ([[dict debugDescription] isEqualToString:@"sort_by is null"]) {
            if (success) {
                success(nil);
            }
            return ;
        }
        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
        
        
        for (NSDictionary *designersDict in dict[@"order_list"]) {
            
            if (![designersDict isKindOfClass:[NSNull class]]) {
                [resultArray addObject:[MPDesignerOrderModel demandWithDict:designersDict]];
                
            }
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
