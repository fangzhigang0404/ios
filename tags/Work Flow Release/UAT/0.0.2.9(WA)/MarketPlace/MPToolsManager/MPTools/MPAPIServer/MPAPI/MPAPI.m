//
//  MPAPI.m
//  MarketPlace
//
//  Created by WP on 16/1/16.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPAPI.h"
#import "MPHttpRequestManager.h"
#import "MPMarketplaceSettings.h"

@implementation MPAPI

//D3.8
+ (void)createOrderToDesigner:(NSDictionary *)dictionary requestHeader:(NSDictionary *)header  success:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure {
    
    NSString* url=[NSString stringWithFormat:@"%@orders",MPMAIN];
    NSLog(@"%@",url);
    
    [MPHttpRequestManager Post:url withParameters:nil withHeader:header withBody:dictionary andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * returnDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(returnDict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/// D2.6 装修需求详情 1535762
+ (void)createDecorateDetailWithNeedsId:(NSString *)needsId requestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *dict))success failure:(void(^) (NSError *error))failure {
    
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@needs/%@",MPMAIN,needsId] withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

/// 取消（关闭）装修需求
+ (void)createCancleDecorateDemandWithNeedId:(NSString *)needId requestHeader:(NSDictionary *)header Success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@needs/%@/cancel",MPMAIN,needId];
    NSDictionary *param = @{@"is_deleted":@"1"};
    [MPHttpRequestManager Put:url withParameters:param withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


/// 修改装修需求 
+ (void)createModifyDecorateDemandWithNeedsId:(NSString *)needsId withParameters:(NSDictionary *)parametersDict withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    
    [MPHttpRequestManager Put:[NSString stringWithFormat:@"%@needs/%@",MPMAIN,needsId] withParameters:nil withHeader:header withBody:parametersDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 装修需求列表(我的家裝訂單) 
+ (void)createDecorateDemandListWithOffset:(NSString *)offset withMemberId:(NSString *)memberId withLimit:(NSString *)limit withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure {

    NSString *url = [NSString stringWithFormat:@"%@member/%@/needs",MPMAIN,memberId];
    NSDictionary *param  = @{@"offset"          :offset,
                             @"limit"           :limit,
                             @"media_type_id"   :@"53",
                             @"sort_by"         :@"date",
                             @"sort_order"      :@"desc"};

    
    [MPHttpRequestManager Get:url withParameters:param withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",dict);
        if (success) {
            success(dict);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

///D2.1 创建装修需求
+ (void)createMeasureRoomOrderWithUrl:(NSDictionary *)urlDict
                               header:(NSDictionary *)headerDict
                                 body:(NSDictionary *)bodyDict
                              success:(void(^) (NSDictionary *dictionary))success
                              failure:(void(^) (NSError *error))failure {
    
    [MPHttpRequestManager Put:[NSString stringWithFormat:@"%@orders/%@",MPMAIN,urlDict[@"order_id"]] withParameters:nil withHeader:headerDict withBody:bodyDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        
        if (success)
            success(dict);
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

// 消费者查看设计师主页 get设计师信息
+ (void)getDesignerInfoWithUrl:(NSDictionary *)urlDict
                        header:(NSDictionary *)headerDict
                          body:(NSDictionary *)bodyDict
                       success:(void(^) (NSDictionary *dictionary))success
                       failure:(void(^) (NSError *error))failure {
    
    //http://192.168.2.222:6091/member-app/v1/api/designers/1/home
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@designers/%@/home",MPMAIN_DESIGNER,urlDict[@"designer_id"]] withParameters:nil withHeader:headerDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (success) {
            
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)designerBasicInformationMaintinWithParameters:(NSDictionary *)parametes requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {
    
//    http://192.168.2.222:6080/api/v1/members
    
    [MPHttpRequestManager Put:[NSString stringWithFormat:@"%@members",MPMAIN] withParameters:nil withHeader:header withBody:parametes andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (success) {
            
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)designerHomeSettingWithDesigner_id:(NSString *)designer_id withParameters:parametes requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {

    
//    http://192.168.2.222:6080/v1/api/designers/{designer_id}/home 20728731
    
    [MPHttpRequestManager Put:[NSString stringWithFormat:@"%@designers/%@/home",MPMAIN,designer_id] withParameters:nil withHeader:header withBody:parametes andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getListOfAttentionDesignersWithMemberId:(NSString *)member_id requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {

//    http://192.168.2.222:6080/api/v1/members/{member_id}/designers/1536771  20728731
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@members/%@/designers/1536771",MPMAIN,member_id] withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (success) {
            
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)cancelAttentionDesignerWithMember_id:(NSString *)member_id designerId:(NSString *)designer_id requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {

//    http://192.168.2.222:6080/api/v1/members/{member_id}/designers/{designer_id} 20728731 1536771
    
    [MPHttpRequestManager Delete:[NSString stringWithFormat:@"%@members/%@/designers/%@",MPMAIN,member_id,designer_id] withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (success) {
            
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
     
+ (void)getListOfMyTargetsWithNeedsId:(NSString *)needs_id requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {

//http://192.168.2.222:6080/v1/api/needs/{needs_id}/designers?offset=0&limit=10&sort_by=bidding_date,needs_id&sort_order=desc
    
    NSString *url = [NSString stringWithFormat:@"%@needs/%@/designers",MPMAIN,needs_id];
    NSDictionary *param = @{@"offset"       :@"0",
                            @"limit"        :@"10",
                            @"sort_by"      :@"bidding_date,needs_id",
                            @"sort_order"   :@"desc"};
    
    [MPHttpRequestManager Get:url withParameters:param withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (success) {
            
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


//- (void)designerimprovementlist:(void (^)(NSString *))block{
//
////http://192.168.2.222:6080/v1/api/designers/{designer_id}/orders?offset=10&limit=10&sort_by=post_date&sort_order=desc
//    
//
//    
//    
//    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@designers/12/orders?offset=10&limit=10&sort_by=post_date&sort_order=desc",MPMAIN] withParameters:@{@"count":@(10),@"limit":@(10),@"offset":@(0),@"orders":@[@{@"adjustment":@(1000),@"amount":@(1000),@"channel_type":@"type",@"child_order_status":@"01",@"designer_id":@(101),@"designer_name":@"designName",@"measure_order_id":@"101",@"mobile_number":@"13888888888",@"needs_id":@"1001",@"order_id":@(101),@"order_status":@"01",@"order_type":@"1",@"pay_order":@{@"pay_amount":@(1000),@"pay_method":@"method",@"pay_order_id":@(10),@"pay_status":@"status",@"pay_success_date":@(1452088863364),@"pay_trade_number":@"11111"},@"service_date":@(1452088863364),@"user_id":@(101),@"user_name":@"小明"},@{@"adjustment":@(1000),@"amount":@(1000),@"channel_type":@"type",@"child_order_status":@"01",@"designer_id":@(102),@"designer_name":@"designName",@"measure_order_id":@"102",@"mobile_number":@"13888888888",@"needs_id":@"1002",@"order_id":@(102),@"order_status":@"01",@"order_type":@"1",@"pay_order":@{@"pay_amount":@(1000),@"pay_method":@"method",@"pay_order_id":@(11),@"pay_status":@"status",@"pay_success_date":@(1452088863364),@"pay_trade_number":@"22222"},@"service_date":@(1452088863364),@"user_id":@(102),@"user_name":@"小明"}]} withHeaderField:@{@"token":@"1111-1111-1111-1111-1111"} andSuccess:^(NSData *responseData) {
//        
//        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
//        
//        if (block) {
//            
//            block([dict description]);
//        }
//        
//        
//    } andFailure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//
//}

+ (void)designerOrderdetails:(void (^)(NSString *))block{


//http://192.168.2.222:6080/v1/api/needs/{needs_id}?referenced_assets=true&extended_data=true&version=1.15&asset_taxonomy=true
    NSString *url = [NSString stringWithFormat:@"%@needs/1536655",MPMAIN];
    NSDictionary *param = @{@"referenced_assets"    :@"true",
                            @"extended_data"        :@"true",
                            @"version"              :@"1.15",
                            @"asset_taxonomy"       :@"true"};
    NSDictionary *body =@{@"adjustment"         :@(1000),
                           @"amount"            :@(1000),
                          @"channel_type"       :@"type",
                          @"child_order_status" :@"01",
                          @"designer_id"        :@(101),
                          @"designer_name"      :@"designName",
                          @"measure_order_id"   :@"101",
                          @"mobile_number"      :@"13888888888",
                          @"needs_id"           :@"1001",
                          @"order_id"           :@(101),
                          @"order_status"       :@"01",
                          @"order_type"         :@"1",
                          @"pay_order"          :@{@"pay_amount"        :@(1000),
                                                   @"pay_method"        :@"method",
                                                   @"pay_order_id"      :@(12),
                                                   @"pay_status"        :@"status",
                                                   @"pay_success_date"  :@(1452088643323),
                                                   @"pay_trade_number"  :@"33333"},
                          @"service_date"       :@(1452088643322),
                          @"user_id"            :@(101),
                          @"user_name"          :@"小明"};
    NSDictionary *header = @{@"token":@"1111-1111-1111-1111-1111"};
    
    [MPHttpRequestManager Get:url withParameters:param withHeader:header withBody:body andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (block) {
            
            block([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
         NSLog(@"%@",error);
    }];
}




/// 案例库列表.

+ (void)crateCaseLibrayWithOffset:(NSString *)offset withLimit:(NSString *)limit custom_string_area:(NSString *)area custom_string_form:(NSString *)form custom_string_style:(NSString *)style custom_string_type:(NSString *)type custom_string_keywords:(NSString *)keywords success:(void (^)(NSDictionary* Dic))success failure:(void(^) (NSError *error))failure {

    NSString* url=[NSString stringWithFormat:@"%@cases/search",MPMAIN];
    NSDictionary *param = @{@"offset"       :offset,
                            @"limit"        :limit,
                            @"custom_string_area":area,
                            @"custom_string_form":form,
                            @"custom_string_style":style,
                            @"custom_string_type":type,
                            @"custom_string_bedroom":@"",
                            @"custom_string_restroom":@"",
                            @"custom_string_keywords":keywords,
                            @"sort_by"      :@"date",
                            @"sort_order"    :@"desc",
                            @"taxonomy_id"  :@"01"};
    NSLog(@"%@",url);

    [MPHttpRequestManager Get:url withParameters:param andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * designersDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"案例库列表:%@",designersDict);
        if (success) {
            success(designersDict);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 依据案例标识获取案例详情
+ (void)createCaseLibrayDetailWithCaseID:(NSString *)caseId Success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@cases/%@",MPMAIN,caseId] withParameters:nil andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"获取案例详情:%@",dict);
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 依据案例标识修改案例
+ (void)createModifyCaseWithCaseId:(NSString *)caseId withStatus:(NSString *)status withRecommended:(NSString *)recommended withSearch:(NSString *)search withWeight:(NSString *)weight requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {
    
    NSDictionary *body = @{@"id"            :caseId,
                           @"status"        :status,
                           @"is_recommended":recommended,
                           @"search_tag"    :search,
                           @"weight"        :weight};
    
    [MPHttpRequestManager Put:[NSString stringWithFormat:@"%@cases/%@",MPMAIN,caseId] withParameters:nil withHeader:header withBody:body andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 依据案例标识删除案例
+ (void)createDeleteCaseWithcaseId:(NSString *)caseId requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {
    
    [MPHttpRequestManager Delete:[NSString stringWithFormat:@"%@cases/%@",MPMAIN,caseId] withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
}

/// 消费者获取关注的设计师列表（模拟接口） 
+ (void)createFoucsDesignersListWithMemberId:(NSString *)memberId requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {
    
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@members/%@/follow_designers",MPMAIN,memberId] withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            
            failure(error);
        }
    }];
    
}



+ (void)uploadMeasureRoomResultWithParameters:(NSDictionary *)parametes requestHeader:(NSDictionary *)header success:(void(^) (NSString *string))success failure:(void(^) (NSError *error))failure {

    [MPHttpRequestManager Post:[NSString stringWithFormat:@"%@measure/upload",MPMAIN] withParameters:nil withHeader:header withBody:parametes andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success([dict description]);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)createDesignContractWithParameters:(NSDictionary *)parametes requestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *dict))success failure:(void(^) (NSError *error))failure {
    
    [MPHttpRequestManager Post:[NSString stringWithFormat:@"%@contracts",MPMAIN] withParameters:nil withHeader:header withBody:parametes andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            
            //            success([dict description]);
            success (dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getDesignersListWithUrl:(NSDictionary *)urlDict
                         header:(NSDictionary *)headerDict
                           body:(NSDictionary *)bodyDict
                        success:(void(^) (NSDictionary *dict))success
                        failure:(void(^) (NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@designers",MPMAIN_DESIGNER];
    NSDictionary *param = @{@"offset"       :urlDict[@"offset"],
                            @"limit"        :urlDict[@"limit"],
                            @"sort_by"      :@"date",
                            @"sort_order"   :@"desc"};
    [MPHttpRequestManager Get:url withParameters:param withHeader:headerDict withBody:bodyDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * designersDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"设计师信息：%@",designersDict);
        if (success) {
            success(designersDict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 获取会员信息
+  (void)createAccessPersonalInformationWithMemberId:(NSString *)memberId withRequestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *informationDict))success failure:(void(^) (NSError *error))failure {
    
    NSString *url =[NSString stringWithFormat:@"%@members/%@",MPMAIN_DESIGNER,memberId];
    [MPHttpRequestManager Get:url withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * designersDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(designersDict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)createDesignerMyMarkListWithDesignerId:(NSString *)designerId WithOffset:(NSString *)offset withLimit:(NSString *)limit withSort_by:(NSString *)sort_by withSort_order:(NSString *)sort_order withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@designers/%@/bidders",MPMAIN,designerId];
    NSDictionary *param = @{@"offset":offset,
                            @"limit":limit,
                            @"sort_by":sort_by,
                            @"sort_order":sort_order};
    [MPHttpRequestManager Get:url withParameters:param withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * designersDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(designersDict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)createBeishuWithConsumerId:(NSString *)consumerId parmeters:(NSDictionary *)parametersDict withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
//    NSDictionary *requestDict = [NSDictionary dictionaryWithObjectsAndKeys:contacts_name,@"contacts_name",mobile,@"contacts_mobile",province,@"province",city,@"city",district,@"district",neighhourhoods,@"community_name", nil];
    
    NSLog(@"%@",[NSString stringWithFormat:@"%@beishu/needs/%@",MPMAIN,consumerId]);
    
    NSString *url  =[NSString stringWithFormat:@"%@beishu/needs/%@",MPMAIN,consumerId];
    [MPHttpRequestManager Post:url withParameters:nil withHeader:header withBody:parametersDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * designersDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(designersDict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteDesignerWithNeedId:(NSString *)needId designerId:(NSString *)designerId withParameters:(NSDictionary *)parametersDict withRequestHeader:(NSDictionary *)header success:(void(^) (NSDictionary *dictionary))success failure:(void(^) (NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@needs/%@/designers/%@",MPMAIN,needId,designerId];
    NSDictionary *param = @{@"bidding_status":@"03"};
    
    [MPHttpRequestManager Put:url withParameters:param withHeader:header withBody:parametersDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 北舒套餐列表
+ (void)createDesignerMyProjectWithMemberId:(NSString *)memberId withOffset:(NSString *)offset withLimit:(NSString *)limit withMediaTypeID:(NSString *)mediaTypeId withSoftware:(NSString *)software withTaxonomy:(NSString *)taxonomy  withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    NSString *url =[NSString stringWithFormat:@"%@beishu/%@/needs",MPMAIN,memberId];
    
    NSDictionary *param = @{@"offset"           :offset,
                            @"limit"            :limit,
                            @"media_type_id"    :mediaTypeId,
                            @"software"         :software,
                            @"asset_taxonomy"   :taxonomy,
                            @"sort_by"          :@"date",
                            @"sort_order"       :@"desc"};
    [MPHttpRequestManager Get:url withParameters:param withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * designersDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"北舒套餐:%@",designersDict);
        if (success) {
            success(designersDict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

/// 应标大厅
+ (void)createMarkHallWithUrl:(NSDictionary *)urlDict
                       header:(NSDictionary *)headerDict
                         body:(NSDictionary *)bodyDict
                      success:(void(^) (NSDictionary *dict))success
                      failure:(void(^) (NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@search/needs",MPMAIN];
    NSDictionary *param = @{@"offset"           :urlDict[@"offset"],
                            @"limit"            :urlDict[@"limit"],
                            @"custom_string_area":urlDict[@"custom_string_area"],
                            @"custom_string_form":urlDict[@"custom_string_form"],
                            @"custom_string_style":urlDict[@"custom_string_style"],
                            @"custom_string_type":urlDict[@"custom_string_type"],
                            @"custom_string_bedroom":urlDict[@"custom_string_bedroom"],
                            @"custom_string_restroom":urlDict[@"custom_string_restroom"],
                            @"asset_taxonomy"   :@"ezhome/fullflow/audit/success",
                            @"sort_by":@"date",
                            @"sort_order":@"desc"};
    NSLog(@"应标大厅：%@ ,参数：%@，请求头:%@",url,param,headerDict);
    [MPHttpRequestManager Get:url withParameters:param withHeader:headerDict withBody:bodyDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * designersDict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"应标大厅：%@",designersDict);
        if (success) {
            success(designersDict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)createMarkDetailWithNeedId:(NSString *)needId withHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@needs/%@",MPMAIN,needId] withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


+ (void)uploadPhoto:(NSString *)photoUrl withsuccess:(void(^) (NSDictionary *dictionary))success failure:(void(^) (NSError *error))failure {
    
    
    NSString *url = [NSString stringWithFormat:@"%@server/upload", [MPMarketplaceSettings sharedInstance].acsDomain];
    
    [MPHttpRequestManager Get:url withParameters:nil andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

+ (void)downloadPhoto:(NSString *)photoUrl withsuccess:(void(^) (NSDictionary *dictionary))success failure:(void(^) (NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@server/download", [MPMarketplaceSettings sharedInstance].acsDomain];
    [MPHttpRequestManager Get:url withParameters:nil andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}


/// 上传照片
+ (void)createUploadPhotosWithUrl:(NSString *)url withFiles:(NSArray *)array withHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/v2/files/upload",url];
    NSDictionary *param = @{@"unzip"    :@"false",
                            @"public"   :@"true"};
    
    NSLog(@"uploadphonto url :%@",urlString);
    
    [MPHttpRequestManager Post:urlString withParameters:param withFiles:array withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/// 上传实名认证照片
+ (void)UploadRealNameAuthenticationWith:(NSString *)URl Withparam:(NSDictionary *)dict WithHeader:(NSDictionary *)headerdict success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure{

    [MPHttpRequestManager Post:[NSString stringWithFormat:@"%@realnames/members/%@",MPMAIN_DESIGNER,URl] withParameters:nil withHeader:headerdict withBody:dict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error is %@",error);
    }];
}


/// 下载照片
+ (void)downloadfield:(NSString *)fiel_id andtitle:(NSString *)title success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure{
    
    NSString *urlString = [NSString stringWithFormat:@"http://%@/api/v2/files/download/path",title];

    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:member.acs_x_session,@"X-Session",[MPMarketplaceSettings sharedInstance].afc,@"X-AFC",nil];
    NSDictionary *param  = @{@"file_ids":fiel_id};
    
    [MPHttpRequestManager Get:urlString withParameters:param withHeader:dic andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"########fileURL:%@",temp[@"download_url"]);
        if (success) {
            success(temp);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

///依据订单id获取订单详情

+ (void)retrieveOrderByOrderId:(NSString *)ordeid withHeadfield:(NSDictionary *)token withsuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure{
    
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@orders/%@",MPMAIN,ordeid] withParameters:nil withHeader:token andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (success) {
            success(temp);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// D3.4获取设计师订单列表
+ (void)GetorderListOFdesignerWithDesignerID:(NSString *)designer_id withOffset:(NSString *)offset withLimit:(NSString *)limit requestHeader:(NSDictionary *)header  success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
////    NSDictionary *dictUrl=[dictionary objectForKey:@"url"];
//    NSString* offset = [dictionary  objectForKey:@"offset"];
//    NSString* limit = [dictionary  objectForKey:@"limit"];
//    NSString* designer_id = [dictionary  objectForKey:@"designer_id"];
//    
//    NSString* url=[NSString stringWithFormat:@"%@designers/%@/orders?offset=%@&limit=%@&sort_order=desc",MPMAIN,designer_id,offset,limit];
    NSString* url=[NSString stringWithFormat:@"%@designers/%@/orders",MPMAIN,designer_id];

    NSDictionary *param = @{@"offset"   :offset,
                            @"limit"    :limit,
                            @"sort_by"  :@"desc",
                            @"sort_order":@"date"};
    
    NSLog(@"%@......%@",url,header);
    
    [MPHttpRequestManager Get:url withParameters:param withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"temp===%@",temp);
        
        if (success) {
            success(temp);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
    
}

// D3.11 设计师同意或者拒绝订单
+ (void)DesignerRefuseORagreOder:(NSString *)orderid WihtPrametrs:(NSDictionary *)Prametrs With:(NSDictionary *)HeaderField success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure{


    NSString * url = [NSString stringWithFormat:@"%@orders/%@",MPMAIN,orderid];
    
    [MPHttpRequestManager Put:url withParameters:nil withHeader:HeaderField withBody:Prametrs andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"temp===%@",temp);
         NSDictionary *responseHeaders=[NSDictionary dictionaryWithDictionary:[(NSHTTPURLResponse*)task.response allHeaderFields]];
        if (success) {
            
            success (responseHeaders);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

+ (void)MemberGetContractContract:(NSString *)Contractid WithrequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure{

    NSString * url = [NSString stringWithFormat:@"%@contracts/%@",MPMAIN,Contractid];
    
    [MPHttpRequestManager Get:url withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        
        if (success) {
            
            success(temp);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@",error);

    }];
    
}

+ (void)UpdataGetMemberInformationWith:(NSString *)member_id withParam:(NSDictionary *)param WithToken:(NSDictionary *)token success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    

    [MPHttpRequestManager Put:[NSString stringWithFormat:@"%@members/%@",MPMAIN_DESIGNER,member_id] withParameters:nil withHeader:token withBody:param andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
        if (success) {
            success(temp);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)getListOfDesignerCasesWithUrl:(NSDictionary *)urlDict
                               header:(NSDictionary *)headerDict
                                 body:(NSDictionary *)bodyDict
                              success:(void(^) (NSDictionary *dictionary))success
                              failure:(void(^) (NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@designers/%@/cases",MPMAIN,urlDict[@"designer_id"]];
    NSDictionary *param = @{@"limit"        :urlDict[@"limit"],
                            @"offset"       :urlDict[@"offset"],
                            @"sort_by"      :@"date",
                            @"sort_order"   :@"desc"};
    [MPHttpRequestManager Get:url withParameters:param withHeader:headerDict withBody:bodyDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 消费者选TA量房
+ (void)measureByConsumerSelfChooseDesignerWithParam:(NSDictionary *)param requestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@orders",MPMAIN];
    NSDictionary *parameters = @{@"is_need":@"true"};
    
    [MPHttpRequestManager Post:url withParameters:parameters withHeader:header withBody:param andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {        
        if (failure) {
            failure(task,error);
        }

    }];
}

/// 消费者自选量房 NO NEED_ID
+ (void)measureByConsumerSelfChooseDesignerNoNeedIdWithParam:(NSDictionary *)param requestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSURLSessionDataTask *task, NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@orders",MPMAIN];
    NSDictionary *parameters = @{@"is_need":@"false"};
    
    [MPHttpRequestManager Post:url withParameters:parameters withHeader:header withBody:param andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task ,error);
        }
    }];
}

/// 消费者发布需求
+ (void)issueDemandWithParam:(NSDictionary *)param requestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {

    NSString *url = [NSString stringWithFormat:@"%@needs",MPMAIN];
    [MPHttpRequestManager Post:url withParameters:nil withHeader:header withBody:param andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSLog(@"%@",responseData);
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 同意或拒绝量房
+ (void)confirmOrRefuseMeasure:(BOOL)confirm withNeedsID:(NSString *)needs_id withHeader:(NSDictionary *)header andSuccess:(void(^)(NSDictionary *))success andFailure:(void(^) (NSError *))failure {
    NSString *url;
    if (confirm) {
        url = [NSString stringWithFormat:@"%@orders/%@",MPMAIN,needs_id];
    }else {
        url = [NSString stringWithFormat:@"%@refused/%@",MPMAIN,needs_id];
    }
    
    [MPHttpRequestManager Put:url withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }

    }];
    
}

+ (void)createDesignerRealNameWithDesignerId:(NSString *)designerid withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    NSLog(@"实名认证参数：%@*****%@",[NSString stringWithFormat:@"%@designers/%@/home",MPMAIN_DESIGNER,designerid],header);
    
    NSString *url = [NSString stringWithFormat:@"%@designers/%@/home",MPMAIN_DESIGNER,designerid];
    
    [MPHttpRequestManager Get:url withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/// 设计师应标.
+ (void)createDesignerBiddingMarkWithNeedId:(NSString *)needId withDesignerId:(NSString *)designerId withParameters:(NSDictionary *)parameterDict withRequestHeader:(NSDictionary *)header success:(void (^)(NSDictionary* dict))success failure:(void(^) (NSURLSessionDataTask *task,NSError *error))failure {
    NSLog(@"应标：%@*****%@",[NSString stringWithFormat:@"%@needs/%@/designers/%@",MPMAIN,needId,designerId],header);

    [MPHttpRequestManager Post:[NSString stringWithFormat:@"%@needs/%@/designers/%@",MPMAIN,needId,designerId] withParameters:nil withHeader:header withBody:parameterDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"success:%@",dict);
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(task,error);
        }
    }];
}

+ (void)ServicePayForOrder:(NSDictionary *)urlDict
                               header:(NSDictionary *)headerDict
                                 body:(NSDictionary *)bodyDict
                              success:(void(^) (NSString *url))success
                              failure:(void(^) (NSError *error))failure {

    NSString *url = [NSString stringWithFormat:@"%@pay/alipay/web/path",MPMAIN];
    NSDictionary *param = @{@"orderId"        :urlDict[@"orderId"],
                            @"orderLineId"       :urlDict[@"orderLineId"],
                            @"channel_type"      :@"web",
                            @"paymethod"   :@"1"};
    
  
    NSLog(@"%@",url);
    
    [MPHttpRequestManager Get:url withParameters:param withHeader:nil withBody:nil andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
    
        //aStr = [[NSString alloc] initWithData:aData encoding:NSASCIIStringEncoding];
        
     NSString* returnUrl= [[NSString alloc] initWithData:responseData encoding:NSASCIIStringEncoding];
        if (success) {
            success(returnUrl);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 我的资产
/// 获取设计师银行卡信息
+ (void)getDesignersBankInfoWithDesignerID:(NSString *)designerID
                                withHeader:(NSDictionary *)header
                                andSuccess:(void(^)(NSDictionary *))success
                                andFailure:(void(^)(NSError *))failure {
//http://192.168.2.222:6091/transaction-app/v1/api/withdraw/{designer_id}
    
    NSString *url = [NSString stringWithFormat:@"%@withdraw/%@",MPMAIN_TRANSACTION,designerID];
    [MPHttpRequestManager Get:url withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"成功：%@",dict);
        if (success) {
            
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"失败：%@",error);

        if (failure) {
            failure(error);
        }
    }];
//    
//    
//    NSDictionary *dic = @{@"member_id":@"412312",
//                          @"account_user_name":@"设计师",
//                          @"bank_name":@"平安银行",
//                          @"branch_bank_name":@"北苑支行",
//                          @"deposit_card":@"1111222233334",
//                          @"amount":@(123456789),
//                          @"guarantee_amount":@(100)};
//    if (success) {
//        success(dic);
//    }
}

+ (void)getContractNumberWithSuccess:(void(^)(NSDictionary *dict))success failure:(void(^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@contracts/one",MPMAIN];
    [MPHttpRequestManager Get:url withParameters:nil andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        
        if (success) {
            success(dict);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)createContractNeedID:(NSString *)needid WithRequestHeader:(NSDictionary *)header WithBoby:(NSDictionary *)bobyDict WithSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure{
    
//    NSString *temp=@"http://192.168.120.113:8080/design-app/v1/api/";
    [MPHttpRequestManager Post:[NSString stringWithFormat:@"%@contracts?need_id=%@",MPMAIN,needid] withParameters:nil withHeader:header withBody:bobyDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];

        
        if (success) {
            success(dict);
        }
        
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}



+ (void)PayWithOrderId:(NSString *)orderid WithOrderLineID:(NSString *)orderlineid WithSuccess:(void(^)(NSDictionary * dict))success failure:(void(^) (NSError *error))failure{


    
    
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@pay/alipay/app/parameters?orderId=%@&orderLineId=%@&channel_type=mobile&paymethod=1",MPMAIN,orderid,orderlineid] withParameters:nil andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        
        if (success) {
            
            success(dict);
        }
        
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
        
    }];
    
    
}


+ (void) getCloudFilesForNeedId:(NSString *)needId
                        success:(void(^) (MPChatHomeStylerCloudfiles *dict))success
                        failure:(void(^) (NSError *error))failure
{
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    NSString *url = [NSString stringWithFormat:@"%@im/needs/%@/designers/%@/cloud_files",MPMAIN, needId, member.acs_member_id];
    //NSString *url = [NSString stringWithFormat:@"%@im/needs/%@/designers/%@/cloud_files",MPMAIN_PAYMENT, @"1540268", @"20730187"];

    NSDictionary *dictHeader = @{@"X-Token":member.X_Token};

    [MPHttpRequestManager Get:url withParameters:nil
                   withHeader:dictHeader
                     withBody:nil
                   andSuccess:^(NSURLSessionDataTask *task, NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         
         
         MPChatHomeStylerCloudfiles* cfiles = [MPChatHomeStylerCloudfiles fromFoundationObj:[dict objectForKey:@"cloud_files"]];
         if (success) {
             success(cfiles);
         }
     }
                   andFailure:^(NSURLSessionDataTask *task, NSError *error) {
                       if (failure)
                           failure(error);
                   }];
}


+ (void) getProjectMaterialsForNeedId:(NSString *)needId
                               header:(NSDictionary *)header
                              success:(void(^) (MPProjectMaterials *dict))success
                              failure:(void(^) (NSError *error))failure
{
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    NSString *url = [NSString stringWithFormat:@"%@im/needs/%@/materials/%@",MPMAIN, needId, member.acs_member_id];
        
    [MPHttpRequestManager Get:url withParameters:nil
                   withHeader:header
                     withBody:nil
                   andSuccess:^(NSURLSessionDataTask *task, NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         
         
         MPProjectMaterials* mats = [MPProjectMaterials fromFoundationObj:[dict objectForKey:@"materials"]];
         if (success) {
             success(mats);
         }
     }
                   andFailure:^(NSURLSessionDataTask *task, NSError *error) {
                       if (failure)
                           failure(error);
                   }];
}


+ (void) getProjectInfoForNeedId:(NSString *)needId
                     forDesigner:(NSString*)designerId
                          header:(NSDictionary *)header
                         success:(void(^) (MPChatProjectInfo *dict))success
                         failure:(void(^) (NSError *error))failure {

    NSString *url = [NSString stringWithFormat:@"%@im/needs/%@/designers/%@",MPMAIN, needId, designerId];
        
    [MPHttpRequestManager Get:url withParameters:nil
                   withHeader:header
                     withBody:nil
                   andSuccess:^(NSURLSessionDataTask *task, NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         
         
         MPChatProjectInfo* info = [MPChatProjectInfo fromRawResposnseObj:[dict objectForKey:@"requirement"]];
         if (success) {
             success(info);
         }
     }
                   andFailure:^(NSURLSessionDataTask *task, NSError *error) {
                       if (failure)
                           failure(error);
                   }];

}
+ (void)getMembersInformation:(NSString *)member_id withRequestHeard:(NSDictionary *)heard WithSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@members/%@",MPMAIN_DESIGNER,member_id];
    [MPHttpRequestManager Get:url withParameters:nil withHeader:heard andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];

}

#pragma mark - Current Status
///根据needs_id与designer_id获取当前状态
+ (void)getCurrentStatusWithNeedID:(NSString *)needs_id
                    withDesignerID:(NSString *)designer_id
                        andSuccess:(void(^)(NSDictionary *))success
                        andFailure:(void(^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@im/needs/%@/designers/%@",MPMAIN, needs_id, designer_id];
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    NSDictionary *dictHeader = @{@"X-Token":member.X_Token};
    [MPHttpRequestManager Get:url withParameters:nil withHeader:dictHeader andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getDesignersInformation:(NSString *)member_id withRequestHeard:(NSDictionary *)heard WithSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@designers/%@/home",MPMAIN_DESIGNER,member_id];
    [MPHttpRequestManager Get:url withParameters:nil withHeader:heard andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        if (success) {
            success(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];

}
+ (void)updataGetdesignersInformation:(NSString *)member_id withParam:(NSDictionary *)param withRequestHeard:(NSDictionary *)heard witSuccess:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@designers/%@/home",MPMAIN_DESIGNER,member_id];
    
   [MPHttpRequestManager Put:url withParameters:nil withHeader:heard withBody:param andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                            options:0
                                                              error:nil];
       if (success) {
           success(dict);
       }

   } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
       if (failure)
           failure(error);
   }];
}
+ (void)getDesignersCerInformation:(NSString *)member_id withRequestHeard:(NSDictionary *)heard witSuccess:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure {

    NSString *url = [NSString stringWithFormat:@"%@realnames/members/%@",MPMAIN_DESIGNER,member_id];
    [MPHttpRequestManager Get:url withParameters:nil withHeader:heard andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        if (success) {
            success(dict);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);

    }];

}
+ (void)updataCerInformation:(NSString *)member_id withParam:(NSDictionary *)dic withRequestHeard:(NSDictionary *)heard witSuccess:(void (^)(NSDictionary *dict))success failure:(void(^) (NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@realnames/members/%@",MPMAIN_DESIGNER,member_id];
    [MPHttpRequestManager Put:url withParameters:nil withHeader:heard withBody:dic andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        if (success) {
            success(dict);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}
+ (void)updataMembersAvatar:(NSDictionary *)header withFile:(NSData *)file witSuccess:(void (^)(NSDictionary *))success failure:(void(^) (NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@members/updateavatar",MPMAIN_DESIGNER];
    
    NSDictionary *fileDic = [NSDictionary dictionaryWithObjectsAndKeys:file,@"data",@"file",@"name",@"file",@"fileName",@"image/png",@"type", nil];
    [MPHttpRequestManager Put:url withParameters:nil withHeader:header withFiles:[NSArray arrayWithObject:fileDic] andSuccess:^(NSURLResponse *response, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        if (success) {
            success(dict);
        }

    } andFailure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

/// 设计师交易记录.
+ (void)getDesignerTransactionRecord:(NSString *)designer_id withParameter:(NSDictionary *)paramDict withSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];

    NSDictionary *dictHeader = @{@"X-Token":member.X_Token};
    NSString *url = [NSString stringWithFormat:@"%@finance/queryOrderList/%@",MPMAIN_TRANSACTION,designer_id];
    [MPHttpRequestManager Get:url withParameters:paramDict withHeader:dictHeader withBody:nil andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        if (success) {
            success(dict);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getDesignersWithdraw:(NSString *)designer_id withParameter:(NSDictionary *)paramDict withSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSDictionary *dictHeader = @{@"X-Token":member.X_Token};
    NSString *url = [NSString stringWithFormat:@"%@finance/designerWithdrawalsTransLog/%@",MPMAIN_TRANSACTION,designer_id];
    [MPHttpRequestManager Get:url withParameters:paramDict withHeader:dictHeader withBody:nil andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        if (success) {
            success(dict);
        }
        
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure)
            failure(error);
    }];

}

+ (void)putDesignersWithdraw:(NSString *)designer_id withParameter:(NSDictionary *)paramDict withSuccess:(void (^)(NSDictionary* dict))success failure:(void(^) (NSError *error))failure {
    
    NSString *url = [NSString stringWithFormat:@"%@withdraw/balance/%@",MPMAIN_TRANSACTION,designer_id];
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSDictionary *dictHeader = @{@"X-Token":member.X_Token};
    [MPHttpRequestManager Put:url withParameters:nil withHeader:dictHeader withBody:paramDict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];
        NSLog(@"提现操作:%@",dict);
        if (success) {
            success(dict);
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"提现失败:%@",error);

        if (failure)
            failure(error);
    }];
}

+ (void)Get3DfileListAssetID:(NSString *)assetid WithNeedID:(NSString *)needid WihtDesingerID:(NSString * )desingerid WithHeader:(NSDictionary *)header WithSuccess:(void(^)(NSDictionary * dict))success failure:(void(^)(NSError * error))failure{
    
    
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@hs/prints/%@?needs_id=%@&desinger_id=%@",MPMAIN,assetid,needid,desingerid] withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        if (success) {
            success(dict);
        }
        
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)GetProjectNeedID:(NSString *)needid WithHeard:(NSDictionary *)heard WithDesingeid:(NSString *)desingeid WithSuccess:(void(^)(NSDictionary * dict))success failure:(void(^)(NSError *error))failure{
    
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@hs/prints/references/%@?limit=10&offset=0&designer_id=%@",MPMAIN,needid,desingeid] withParameters:nil withHeader:heard
                   andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
                       
                       NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
                       if (success) {
                           
                           success(dict);
                           
                       }
                   } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
                       
                       if (failure) {
                           failure(error);
                       }
                   }];
    
}

+ (void)SubmitDeliverablesAsset:(NSString *)asset WithNeedID:(NSString *)needid WithDesignerID:(NSString *)designerid WithFileID:(NSString *)fileid WithType:(NSString *)type WithHeader:(NSDictionary *)headerdict WithSuccess:(void(^)(NSDictionary * dict))success failure:(void(^)(NSError *error))failure{
    
//    NSString *utl = @"http://192.168.120.105:8080/design-app/v1/api/";

    [MPHttpRequestManager Post:[NSString stringWithFormat:@"%@hs/prints/%@/references/%@?designer_id=%@&file_ids=%@&type=%@",MPMAIN,asset,needid,designerid,fileid,type] withParameters:nil withHeader:headerdict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        if (success) {
            success(dict);
        }
        
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
    }];
    
}

+ (void)GetProjectDataNeedID:(NSString *)needID WithDesingerID:(NSString *)desingerID WithHeaderDict:(NSDictionary *)headerdict WithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure{

   
    [MPHttpRequestManager Get:[NSString stringWithFormat:@"%@hs/prints/delivery/%@?designer_id=%@",MPMAIN,needID,desingerID] withParameters:nil withHeader:headerdict andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        if (succes) {
            succes(dict);
        }
        
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
        
    }];
    
}

/// System message, Thread_id after the user login.
+ (void)PostPersonalMessageMemberIDWithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure
{
    NSDictionary *header = @{@"X-Token":[AppController AppGlobal_GetMemberInfoObj].X_Token};
    NSString *url = [NSString stringWithFormat:@"%@message/member/%@",MPMAIN,[AppController AppGlobal_GetMemberInfoObj].acs_member_id];
    
    [MPHttpRequestManager Post:url withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        
        if (succes) {
            succes(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            
            failure(error);
        }
    }];
    
    
    
}
/// System message, through thread_id get news content.
+ (void)GetPerSonalMessageMemberIDWithThreadID:(NSString *)threadId withParameters:(NSDictionary *)parameterDict WithSucces:(void(^)(NSDictionary * dict))succes failure:(void(^)(NSError *error))failure
{
    
    NSDictionary *header = @{@"X-Token":[AppController AppGlobal_GetMemberInfoObj].X_Token};
    
    NSString *url = [NSString stringWithFormat:@"%@message/member/%@/sysmessages?limit=%@&offset=%@",MPMAIN,[AppController AppGlobal_GetMemberInfoObj].acs_member_id,parameterDict[@"limit"],parameterDict[@"offset"]];
    
    [MPHttpRequestManager Get:url withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:NSJSONReadingMutableContainers
                                                               error:nil];
        NSLog(@"消息中心的数据:%@",dict);
        if (succes) {
            succes(dict);
        }
    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            
            failure(error);
        }
        
    }];

    
}


+(void) retrieveMemberThreads:(NSString*)memberId
            onlyAttachedToFile:(BOOL)fileOnly
                        header:(NSDictionary *)header
                       success:(void(^)(NSDictionary* dict))success
                       failure:(void(^)(NSError *error))failure{

    NSAssert(memberId != nil, @"member id must be passed");
    
    NSString *entityTypes = @"ASSET,WORKFLOW_STEP,NONE";
    
    if (fileOnly)
        entityTypes = @"FILE";
    
    NSString *url = [NSString stringWithFormat:@"%@message/member/%@",MPMAIN, memberId];
    
    [MPHttpRequestManager Post:url withParameters:nil withHeader:header andSuccess:^(NSURLSessionDataTask *task, NSData *responseData) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:0
                                                               error:nil];

        
        if (success) {
            
            success(dict);
            
        }

    } andFailure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
    }];

    
    
}

@end
