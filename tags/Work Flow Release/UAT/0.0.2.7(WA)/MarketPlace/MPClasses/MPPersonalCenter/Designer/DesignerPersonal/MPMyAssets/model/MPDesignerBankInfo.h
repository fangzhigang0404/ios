//
//  MPDesignerBankInfo.h
//  MarketPlace
//
//  Created by Jiao on 16/2/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPDesignerBankInfo : MPModel
@property (nonatomic, copy) NSString *member_id;
@property (nonatomic, copy) NSString *account_user_name;
@property (nonatomic, copy) NSString *bank_name;
@property (nonatomic, copy) NSString *branch_bank_name;
@property (nonatomic, copy) NSString *deposit_card;
@property (nonatomic, copy) NSString *amount;

/// 获取设计师银行卡信息
+ (void)getDesignerBankInfo:(void(^)(MPDesignerBankInfo *model))success
                andFailure :(void(^)(NSError *error))failure;

+ (void)withdrawWithModel:(MPDesignerBankInfo *)model
              withSuccess:(void(^)(NSString *str))success
              withFailure:(void(^)(NSError *error))failure;
@end
