//
//  MPDesignContractModel.m
//  MarketPlace
//
//  Created by Jiao on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignContractModel.h"
#import <JSONKit.h>
#import "MPWKContractModel.h"

@implementation MPDesignContractModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"contract_status"]) {
        
    }
    if ([key isEqualToString:@"contract_type"]) {
        
    }
    if ([key isEqualToString:@"contract_create_date"]) {
        
    }
    if ([key isEqualToString:@"contract_update_date"]) {
        
    }
}

+(instancetype)designContractWithDict:(NSDictionary *)dict {
    MPDesignContractModel *model =[[MPDesignContractModel alloc]initWithDict:dict];
    return model;
    
}

+ (instancetype)designContractWithModel:(MPWKContractModel *)model {
    NSString *str = [model.contract_data stringByReplacingOccurrencesOfString:@"@jr@" withString:@"\""];
    
    NSDictionary *contract_data;
    if ([str isEqualToString:@""]) {
        contract_data = @{@"name":@"",
                          @"mobile":@"",
                          @"zip":@"",
                          @"email":@"",
                          @"addr":@"",
                          @"addrDe":@"",
                          @"design_sketch":@"",
                          @"render_map":@"",
                          @"design_sketch_plus":@""
                          };
    }else {
        contract_data = [str objectFromJSONString];
    }
    NSDictionary *dic = @{@"isNew":[model.contract_no isEqualToString:@""] ? @(YES) : @(NO),
                          @"contract_no":model.contract_no,
                          @"consumer_id":@"",
                          @"consumer_name":[contract_data objectForKey:@"name"],
                          @"consumer_mobile":[contract_data objectForKey:@"mobile"],
                          @"consumer_zipCode":[contract_data objectForKey:@"zip"],
                          @"consumer_email":[contract_data objectForKey:@"email"],
                          @"consumer_addr":[contract_data objectForKey:@"addr"],
                          @"consumer_addrDe":[contract_data objectForKey:@"addrDe"],
                          @"designer_id":model.designer_id,
                          @"designer_name":@"",
                          @"designer_mobile":@"",
                          @"designer_zipCode":@"",
                          @"designer_email":@"",
                          @"designer_addr":@"",
                          @"designer_addrDe":@"",
                          @"design_sketch":[contract_data objectForKey:@"design_sketch"],
                          @"render_map":[contract_data objectForKey:@"render_map"],
                          @"design_sketch_plus":[contract_data objectForKey:@"design_sketch_plus"],
                          @"contract_charge":model.contract_charge,
                          @"contract_first_charge":model.contract_first_charge,
                          @"balance_payment":[NSString stringWithFormat:@"%f",[model.contract_charge floatValue] - [model.contract_first_charge floatValue]]
                          };
    return [MPDesignContractModel designContractWithDict:dic];
}

+ (void)createDesignContractWithNeedID:(NSString*)needid
                             withModel:(MPDesignContractModel *)model
                               success:(void(^) (MPDesignContractModel *model))success
                               failure:(void(^) (NSError *error))failure {
    NSDictionary * header = [self getHeaderAuthorization];
    
    
    NSDictionary *contractDic = @{@"name":model.consumer_name,
                                @"mobile":model.consumer_mobile,
                                   @"zip":model.consumer_zipCode,
                                 @"email":model.consumer_email,
                                  @"addr":model.consumer_addr,
                                @"addrDe":model.consumer_addrDe,
                         @"design_sketch":model.design_sketch,
                            @"render_map":model.render_map,
                    @"design_sketch_plus":model.design_sketch_plus};
    NSString *a = [contractDic JSONString];
    
    NSString *str = [a stringByReplacingOccurrencesOfString:@"\"" withString:@"@jr@"];
    NSLog(@"contractDic string : %@",str);

    NSDictionary * body = @{@"contract_no": model.contract_no,
                          @"contract_data": str,
                  @"contract_first_charge": [NSString stringWithFormat:@"%@",model.contract_first_charge],
                        @"contract_charge": model.contract_charge,
                  @"contract_template_url": @"www.baidu.com",
                          @"contract_type": @(0),
                            @"designer_id": [AppController AppGlobal_GetMemberInfoObj].acs_member_id};
        
        [MPAPI createContractNeedID:needid WithRequestHeader:header WithBoby:body WithSuccess:^(NSDictionary *dict) {
            
            MPDesignContractModel * model = [MPDesignContractModel designContractWithDict:dict];
            NSLog(@"%@",dict);
            if (success) {
                
                success(model);
            }
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error.debugDescription);
            if (failure) {
                failure(error);
            }
        }];
}

+ (void)getContractNOWithSuccess:(void(^)(NSString *))success andFailure:(void(^)())failure {
    [MPAPI getContractNumberWithSuccess:^(NSDictionary *dict) {
        if (success) {
            success(dict[@"contractNO"]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure();
        }
    }];
}

+ (void)getDesignerInformationWithDesignerID:(NSString *)designer_id
                                   withHSUID:(NSString *)hs_uid
                                 withSuccess:(void(^)(NSString *, NSString *,NSString *))success
                                  andFailure:(void(^)(NSError *))failure {

    NSDictionary * dic = [self getHeaderHsUid];

    [MPAPI getDesignersInformation:designer_id withRequestHeard:dic WithSuccess:^(NSDictionary *dict) {
        
        NSLog(@"dict is -----------------%@",dict);

        if (![dict objectForKey:@"real_name"] || [[dict objectForKey:@"real_name"] isKindOfClass:[NSNull class]]) {
            if (failure) {
                failure(nil);
            }
            return;
        }
        NSString * true_name = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"real_name"] objectForKey:@"real_name"]];
        
        
        NSString *mobile_number = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"real_name"]objectForKey:@"mobile_number"]];
        NSString *email = [NSString stringWithFormat:@"%@",[dict objectForKey:@"email"]];

        if (success) {
            success(true_name, mobile_number, email);
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
        
    }];
}
@end
