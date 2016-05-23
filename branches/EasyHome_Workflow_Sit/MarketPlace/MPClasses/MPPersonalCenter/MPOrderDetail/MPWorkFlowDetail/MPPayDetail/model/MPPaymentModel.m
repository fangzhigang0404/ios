//
//  MPPaymentModel.m
//  MarketPlace
//
//  Created by Franco Liu on 16/1/25.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPPaymentModel.h"
#import "MPAPI.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>



@implementation MPPaymentModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
        
        self.Amount = [NSString stringWithFormat:@"%.2f",[[dict objectForKey:@"amount"] doubleValue]];
        self.NotifyURL = [dict objectForKey:@"notifyURL"];
        self.Partner = [dict objectForKey:@"partner"];
        self.ProductDes = [dict objectForKey:@"productDescription"];
        self.ProductName = [dict objectForKey:@"productName"];
        self.Seller = [dict objectForKey:@"seller"];
        self.TradeNO = [dict objectForKey:@"tradeNO"];
        self.it_b_pay = [dict objectForKey:@"it_b_pay"];
        
    }
    return self;
}

+ (instancetype)OrderWithDict:(NSDictionary *)dict{

    return [[MPPaymentModel alloc]initWithDict:dict];
}

+ (void)getPaymentDetailWithType:(MPPayType)type
                 andWKOrderModel:(NSArray <MPWKOrderModel *> *)orderModel
                     withSuccess:(void (^)(MPPaymentModel *model))success
                      andFailure:(void (^)(NSError *error))failure {

    NSString *order_id;
    NSString *order_line_no;
    switch (type) {
        case MPPayForMeasure: {
            for (MPWKOrderModel *order in orderModel) {
                if ([order.order_type isEqualToString:@"0"]) {
                    order_id = order.order_no;
                    order_line_no = order.order_line_no;
                }
            }
            break;
        }
        case MPPayForContractFirst: {
            for (MPWKOrderModel *order in orderModel) {
                if ([order.order_status isEqualToString:@"5"]) {
                    MPLog(@"order_id : %@",order.order_no);
                    MPLog(@"order_line_id : %@",order.order_line_no);
                    order_id = order.order_no;
                    order_line_no = order.order_line_no;
                }
            }
            break;
        }
        case MPPayForContractLast: {
            for (MPWKOrderModel *order in orderModel) {
                if ([order.order_status isEqualToString:@"6"]) {
                    MPLog(@"order_id : %@",order.order_no);
                    MPLog(@"order_line_id : %@",order.order_line_no);
                    order_id = order.order_no;
                    order_line_no = order.order_line_no;
                }
            }
            break;
        }
            
            
        default:
            break;
    }
    
    [MPAPI PayWithOrderId:order_id WithOrderLineID:order_line_no WithSuccess:^(NSDictionary *dict) {
      
        MPPaymentModel * model = [MPPaymentModel OrderWithDict:dict];
        
        if (success) {
            
            success(model);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            
            failure(error);
        }
        
    }];
}

+ (void)payBackWithModel:(MPPaymentModel *)model andBlock:(void(^)(NSString *code))block {
    NSString *partner = ALIPAY_PARTNER;
    NSString *seller = ALIPAY_SELLER;
    NSString *privateKey = ALIPAY_PRIVATE_KEY;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    
    //////////////////////////////////支付//////////////////////////
    
    MPLog(@"%@",model.Amount);
    MPLog(@"%@",model.TradeNO);
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    
    order.seller = model.Seller;
    order.partner = model.Partner;
    order.tradeNO = model.TradeNO;
    order.productName = model.ProductName;
    order.productDescription = model.ProductName;
    order.amount = model.Amount;
    order.notifyURL = model.NotifyURL;
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = model.it_b_pay;
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"markplacePay";
    
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        MPLog(@"orderString :%@",orderString);
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            MPLog(@"reslut = %@",resultDic);
            NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:resultStatus forKey:@"resultStatus"];
            [userDefaults synchronize];
            MPLog(@"resultStatus is %@",resultStatus);
            if (block) {
                block(resultStatus);
            }
        }];
    }
}

+ (void)getDesignerInformationWithDesignerID:(NSString *)designer_id
                                   withHSUID:(NSString *)hs_uid
                                 withSuccess:(void(^)(NSString *, NSString *,NSString *))success
                                  andFailure:(void(^)(NSError *))failure {
    
    NSDictionary * dic = @{HEADER_HS_UID : hs_uid};;
    
    [MPAPI getDesignersInformation:designer_id withRequestHeard:dic WithSuccess:^(NSDictionary *dict) {
        
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
            success([MPPaymentModel judgeNULL:true_name], [MPPaymentModel judgeNULL:mobile_number], [MPPaymentModel judgeNULL:email]);
        }
        
    } failure:^(NSError *error) {
        MPLog(@"error is %@",error.description);
        if (failure) {
            failure(error);
        }
        
    }];
}
+ (NSString *)judgeNULL:(NSString *)str {
    NSMutableString *resultStr = [NSMutableString stringWithString:str];
    [resultStr replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultStr.length)];
    [resultStr replaceOccurrencesOfString:@"<null>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultStr.length)];
    [resultStr replaceOccurrencesOfString:@"null" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultStr.length)];
    return resultStr;
}
@end
