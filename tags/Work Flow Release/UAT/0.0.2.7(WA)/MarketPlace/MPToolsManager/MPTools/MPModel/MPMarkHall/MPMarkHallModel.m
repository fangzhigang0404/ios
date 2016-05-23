/**
 * @file    MPMarkHallModel.m
 * @brief   mark hall the data model.
 * @author  Xue
 * @version 1.0
 * @date    2016-01-13
 */

#import "MPMarkHallModel.h"
#import "MPHttpRequestManager.h"
#import "MPAPI.h"
@implementation MPMarkHallModel

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
        self.renovation_style = [NSString stringWithFormat:@"%@",dict[@"decoration_style"]];
        self.renovation_budget = [NSString stringWithFormat:@"%@",dict[@"decoration_budget"]];
        self.design_budget = [NSString stringWithFormat:@"%@",(dict[@"design_budget"] == nil)?@"":dict[@"design_budget"]];
        self.province = [NSString stringWithFormat:@"%@",dict[@"province"]];
        self.city = [NSString stringWithFormat:@"%@",dict[@"city"]];

//        self.district = [NSString stringWithFormat:@"%@",dict[@"district"]];
        self.district = [MPMarkHallModel addressToForm:[dict[@"district"] description]];

        self.neighbourhoods = [NSString stringWithFormat:@"%@",dict[@"community_name"]];
        self.img_url = [NSString stringWithFormat:@"%@",dict[@"img_url"]];
        
        self.img_name = [NSString stringWithFormat:@"%@",dict[@"img_name"]];
        self.publish_time = [NSString stringWithFormat:@"%@",dict[@"publish_time"]];
        self.tendererName = [NSString stringWithFormat:@"%@",dict[@"needs_name"]];
        self.contacts_mobile = [NSString stringWithFormat:@"%@",dict[@"contacts_mobile"]];
        self.contacts_name = [NSString stringWithFormat:@"%@",dict[@"contacts_name"]];
        self.detail_desc = [NSString stringWithFormat:@"%@",dict[@"detail_desc"]];
        self.bidder_count = [NSString stringWithFormat:@"%@",dict[@"bidder_count"]];
        self.status= [NSString stringWithFormat:@"%@",dict[@"bidding_status"]];
        self.is_public = [NSString stringWithFormat:@"%@",dict[@"is_beishu"]];
        self.after_bidding_status = [NSString stringWithFormat:@"%@",dict[@"after_bidding_status"]];
    }
    return self;
}

+ (instancetype)demandWithDict:(NSDictionary *)dict {
    
    return [[MPMarkHallModel alloc]initWithDict:dict];
}

+(void)requestDataUrl:(NSString *)url withOffset:(NSInteger)offset withLimit:(NSInteger)limit withSort_by:(NSString *)sort_by withSort_order:(NSString *)sort_order andSuccess:(void (^)(NSArray* array))success {
    
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *limitStr = [NSString stringWithFormat:@"%ld",(long)limit];
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:offsetStr,@"offset",limitStr,@"limit",sort_by,@"sort_by",sort_order,@"sort_order",nil];
    
    [MPHttpRequestManager Get:url withParameters:nil withHeader:nil withBody:dict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        NSLog(@"cases is :%@",temp);
        for (NSDictionary *dict in temp[@"needs_list"]) {
            
            
            [resultArray addObject:[MPMarkHallModel demandWithDict:dict]];
        }
        
        if (success) {
            success(resultArray);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"request error:%@",error);
    }];
}



+(void)requestDataUrl:(NSString *)url withHeaderField:(NSDictionary *)headerDict withOffset:(NSInteger)offset withLimit:(NSInteger)limit withSort_by:(NSString *)sort_by withSort_order:(NSString *)sort_order andSuccess:(void (^)(NSArray* array))success {
    
    NSString *offsetStr = [NSString stringWithFormat:@"%ld",(long)offset];
    NSString *limitStr = [NSString stringWithFormat:@"%ld",(long)limit];
    
    NSMutableArray *resultArray=[[NSMutableArray alloc] init];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:offsetStr,@"offset",limitStr,@"limit",sort_by,@"sort_by",sort_order,@"sort_order",nil];
    
    
    [MPHttpRequestManager Get:url withParameters:nil withHeader:headerDict withBody:dict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        NSLog(@"needs is :%@",temp);
        for (NSDictionary *dict in temp[@"needs_list"]) {
            
            [resultArray addObject:[MPMarkHallModel demandWithDict:dict]];
        }
        if (success) {
            success(resultArray);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"request error:%@",error);
    }];
}
+(void)createMarkHallWithOffset:(NSString *)offset withLimit:(NSString *)limit success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure {
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    NSDictionary *headerDict = [NSDictionary dictionaryWithObjectsAndKeys:[userDefaults objectForKey:@"xsession"],@"xsession",@"designer",@"role", nil];
//    [[MPAPI shareAPIManager] createMarkHallWithOffset:nil header:he body:nil success:^(NSDictionary *dict) {
//        
//        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
//        
//        
//        for (NSDictionary *designersDict in dict[@"needs_list"]) {
//        
//            NSString *beishu = [NSString stringWithFormat:@"%@",designersDict[@"is_beishu"]];
//            if ([beishu isEqualToString:@"1"]) {
//                [resultArray addObject:[MPMarkHallModel demandWithDict:designersDict]];
//
//            }
//        }
//        
//        if (success) {
//            success(resultArray);
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];

}

+(void)createMarkDetailWithNeedId:(NSString *)needId success:(void (^)(MPMarkHallModel* model))success failure:(void(^) (NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];
    
    [MPAPI createMarkDetailWithNeedId:needId withHeader:headerDict success:^(NSDictionary *dict) {
        
        NSLog(@"详情信息:%@",dict);
        if (success) {
            success([MPMarkHallModel demandWithDict:dict]);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];

}

+(void)getDataWithParameters:(NSDictionary *)dictionary success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    [MPMarkHallModel createMarkHallWithOffset:dictionary[@"offset"] withLimit:dictionary[@"limit"] success:^(NSMutableArray *array) {
        
        if (success) {
            success(array);
        }
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];

}
@end
