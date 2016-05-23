//
//  MPWKContractModel.h
//  MarketPlace
//
//  Created by Jiao on 16/2/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPWKContractModel : MPModel

@property (nonatomic, copy) NSString *contract_charge;//设计费总额
@property (nonatomic, copy) NSString *contract_create_date;//合同创建时间
@property (nonatomic, copy) NSString *contract_data;//自定义数据
@property (nonatomic, copy) NSString *contract_first_charge;//设计首款
@property (nonatomic, copy) NSString *contract_no;//合同编号
@property (nonatomic, copy) NSString *contract_status;//合同状态
@property (nonatomic, copy) NSString *contract_type;//合同类型
@property (nonatomic, copy) NSString *contract_template_url;//临时连接
@property (nonatomic, copy) NSString *contract_update_date;//合同更新时间
@property (nonatomic, copy) NSString *designer_id;//设计师id

+ (instancetype)getWKContractModelWithDict:(NSDictionary *)dict;
@end
