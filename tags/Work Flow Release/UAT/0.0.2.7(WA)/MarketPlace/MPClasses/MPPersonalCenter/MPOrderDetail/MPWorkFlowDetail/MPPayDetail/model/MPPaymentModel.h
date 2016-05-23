//
//  MPPaymentModel.h
//  MarketPlace
//
//  Created by Franco Liu on 16/1/25.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"
#import "MPWKOrderModel.h"

typedef enum : NSUInteger {
    MPPayForNone = 0,
    MPPayForMeasure,
    MPPayForContractFirst,
    MPPayForContractLast
}MPPayType ;

@interface MPPaymentModel : MPModel
@property(nonatomic, copy)NSString * Amount;
@property(nonatomic, copy)NSString * NotifyURL;
@property(nonatomic, copy)NSString * Partner;
@property(nonatomic, copy)NSString * ProductDes;
@property(nonatomic, copy)NSString * ProductName;
@property(nonatomic, copy)NSString * Seller;
@property(nonatomic, copy)NSString * TradeNO;
@property(nonatomic, copy)NSString * it_b_pay;

+ (void)getPaymentDetailWithType:(MPPayType)type
                 andWKOrderModel:(NSArray <MPWKOrderModel *> *)orderModel
                        withSuccess:(void (^)(MPPaymentModel *model))success
                         andFailure:(void (^)(NSError *error))failure;

+ (void)payBackWithModel:(MPPaymentModel *)model andBlock:(void(^)(NSString *code))block;

+ (void)getDesignerInformationWithDesignerID:(NSString *)designer_id
                                   withHSUID:(NSString *)hs_uid
                                 withSuccess:(void(^)(NSString *realName, NSString *mobile,NSString *email))success
                                  andFailure:(void(^)(NSError *error))failure;
@end
