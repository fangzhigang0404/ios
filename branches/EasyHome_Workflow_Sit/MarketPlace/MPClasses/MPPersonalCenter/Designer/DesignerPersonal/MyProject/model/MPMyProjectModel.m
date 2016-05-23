/**
 * @file    MPMyProjectModel.m
 * @brief   bei shu order the data model.
 * @author  Xue
 * @version 1.0
 * @date    2016-01-21
 */

#import "MPMyProjectModel.h"
#import "MPAPI.h"
@implementation MPMyProjectModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
        self.projectName = [MPMyProjectModel formatDic:dict[@"needs_name"]];
        self.nameString = [MPMyProjectModel formatDic:dict[@"contacts_name"]];
        self.phone = [MPMyProjectModel formatDic:dict[@"contacts_mobile"]];
    
        self.neighbourhoods = [MPMyProjectModel formatDic:dict[@"community_name"]];
        
        self.houseType = [MPMyProjectModel formatDic:dict[@"house_type"]];
        self.province = [MPMyProjectModel formatDic:dict[@"province_name"]];
        self.city = [MPMyProjectModel formatDic:dict[@"city_name"]];
        
        
//        if ([[dict[@"district_name"] description] isEqualToString:@"none"]) {
//            self.district = @"";
//        }else {
//            self.district = [MPMyProjectModel formatDic:dict[@"district_name"]];
//
//        }
        self.district = [MPMyProjectModel addressToForm:[dict[@"district_name"] description]];
        self.is_beishu = [MPMyProjectModel formatDic:dict[@"is_beishu"]];
        self.beishu_thread_id = [MPMyProjectModel formatDic:dict[@"beishu_thread_id"]];
        self.consumer_id = [MPMyProjectModel formatDic:dict[@"customer_id"]];
        self.needs_id = [MPMyProjectModel formatDic:dict[@"needs_id"]];
        self.avatar = [MPMyProjectModel formatDic:dict[@"avatar"]];
    }
    return self;
}

+ (instancetype)createWithDict:(NSDictionary *)dict {
    
    return [[MPMyProjectModel alloc]initWithDict:dict];
}

+(void)createDesignerMyProjectWithOffset:(NSString *)offset withLimit:(NSString *)limit success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];

    [MPAPI createDesignerMyProjectWithMemberId:[self GetMemberID] withOffset:offset withLimit:limit withMediaTypeID:@"53" withSoftware:@"96" withTaxonomy:@"ezhome/beishu" withRequestHeader:headerDict success:^(NSDictionary *dict) {
        
        NSMutableArray *resultArray=[[NSMutableArray alloc] init];
        
        for (NSDictionary *designerDict in dict[@"beishu_needs_order_list"]) {
        
            NSString *beishu = [NSString stringWithFormat:@"%@",designerDict[@"is_beishu"]];
            
            if ([beishu isEqualToString:@"0"]) {
                [resultArray addObject:[MPMyProjectModel createWithDict:designerDict]];

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

+ (void)getDataWithParameters:(NSDictionary *)dictionary success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    [MPMyProjectModel createDesignerMyProjectWithOffset:dictionary[@"offset"] withLimit:dictionary[@"limit"] success:^(NSMutableArray *array) {
        
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
