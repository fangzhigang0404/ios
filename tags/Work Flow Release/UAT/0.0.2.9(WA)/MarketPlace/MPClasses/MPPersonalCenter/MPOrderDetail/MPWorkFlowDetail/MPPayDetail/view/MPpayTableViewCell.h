//
//  MPpayTableViewCell.h
//  MarketPlace
//
//  Created by leed on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//支付设计首款尾款

#import "MPPayBaseCell.h"

@interface MPpayTableViewCell : MPPayBaseCell

{
    __weak IBOutlet UILabel *_totalAmount;
    __weak IBOutlet UILabel *_firstMoney;
    __weak IBOutlet UILabel *_lastMoney;
    __weak IBOutlet UILabel *_shouldFirstMoney;
}
@property (nonatomic, assign) BOOL isFirstPay;
@end
