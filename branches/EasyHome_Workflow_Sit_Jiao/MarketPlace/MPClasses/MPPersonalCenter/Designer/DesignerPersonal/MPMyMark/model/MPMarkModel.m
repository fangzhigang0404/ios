//
//  MPMarkModel.m
//  MarketPlace
//
//  Created by xuezy on 16/1/21.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMarkModel.h"
#import "MPAPI.h"
#import "MPStatusModel.h"
@implementation MPMarkModel

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
        self.decoration_style = [NSString stringWithFormat:@"%@",dict[@"renovation_style"]];
        self.renovation_budget = [NSString stringWithFormat:@"%@",dict[@"renovation_budget"]];
        self.province = [NSString stringWithFormat:@"%@",dict[@"province"]];
        self.city = [NSString stringWithFormat:@"%@",dict[@"city"]];
        
        self.district = [NSString stringWithFormat:@"%@",dict[@"district"]];
        
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
        
        self.designer_id = [NSString stringWithFormat:@"%@",[dict[@"bidder"] objectForKey:@"designer_id"]];
        
        self.bidding_status = [NSString stringWithFormat:@"%@",[dict[@"bidder"]  objectForKey:@"status"]];
        self.user_name =[NSString stringWithFormat:@"%@",dict[@"user_name"]];
        self.acs_member_id = [MPMarkModel formatDic:dict[@"acs_member_id"]];
        
//        self.wk_stepsArray = [NSArray arrayWithArray:[dict[@"bidder"] objectForKey:@"wk_steps"]];
        
        
//        if (self.wk_stepsArray.count>0) {
            self.thread_id = [NSString stringWithFormat:@"%@",[dict[@"bidder"] objectForKey:@"design_thread_id"]];
        NSLog(@"是什么值:%@",self.thread_id);
            self.thread_id = ([self.thread_id rangeOfString:@"null"].length == 4 || self.thread_id == nil)?@"":self.thread_id;
            
//        }else {
//            self.thread_id = @"";
//        }
//        NSLog(@"thread_id@@@@@@@@@@@:%@",self.thread_id);
        NSLog(@"值:%@",self.thread_id);

    }
    return self;
}
//- (NSString *)formatDic:(id)obj {
//    
//    if ([obj isKindOfClass:[NSNull class]]) {
//        return @"";
//    }
//    
//    NSString *string =[NSString stringWithFormat:@"%@",obj];
//    NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"null" withString:@""];
//    
//    return strUrl;
//}

+ (instancetype)demandWithDict:(NSDictionary *)dict {
    
    return [[MPMarkModel alloc]initWithDict:dict];
}

+(void)createDesignerMyMarkListWithOffset:(NSString *)offset withLimit:(NSString *)limit success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure {
    

    NSDictionary *headerDict = [self getHeaderAuthorization];

    [MPAPI createDesignerMyMarkListWithDesignerId:[self GetMemberID] WithOffset:offset withLimit:limit withSort_by:@"date" withSort_order:@"desc" withRequestHeader:headerDict success:^(NSDictionary *dict) {
        
        NSLog(@"********%@",dict);
        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
        
        for (NSDictionary *designersDict in dict[@"bidding_needs_list"]) {
            NSString *beishu = [NSString stringWithFormat:@"%@",designersDict[@"is_beishu"]];
            if (![designersDict[@"bidder"] isKindOfClass:[NSNull class]] && [beishu isEqualToString:@"1"]) {
                [resultArray addObject:[MPMarkModel demandWithDict:designersDict]];

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

+(void)getDataWithParameters:(NSDictionary *)dictionary success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    [MPMarkModel createDesignerMyMarkListWithOffset:dictionary[@"offset"] withLimit:dictionary[@"limit"] success:^(NSMutableArray *array) {
        
        if (success) {
            success(array);
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
        
        
        if ([[dict debugDescription] isEqualToString:@"sort_by is null"]) {
            if (success) {
                success(nil);
            }
            return ;
        }
        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
        
        
        for (NSDictionary *designersDict in dict[@"order_list"]) {
            
            if (![designersDict isKindOfClass:[NSNull class]]) {
                [resultArray addObject:[MPMarkModel demandWithDict:designersDict]];

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
