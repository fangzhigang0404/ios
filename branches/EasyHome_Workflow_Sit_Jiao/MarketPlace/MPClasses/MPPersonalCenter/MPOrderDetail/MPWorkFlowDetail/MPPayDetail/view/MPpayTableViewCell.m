//
//  MPpayTableViewCell.m
//  MarketPlace
//
//  Created by leed on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPpayTableViewCell.h"

@implementation MPpayTableViewCell
{
    __weak IBOutlet UILabel *_payLabel;
    __weak IBOutlet UILabel *_measureLabel;
    __weak IBOutlet NSLayoutConstraint *_measureBottomCon;
    __weak IBOutlet UILabel *_mLabel;
    __weak IBOutlet NSLayoutConstraint *_mBottomCon;
}
- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib]; 
}

- (void)updateCellDataWithModel:(MPStatusModel *)model {
    [super updateCellDataWithModel:model];
    _orderNumber.text = model.wk_contractModel.contract_no;
    _totalAmount.text = [self moneyFormat:[NSNumber numberWithFloat:[model.wk_contractModel.contract_charge floatValue]]];
    _firstMoney.text = [self moneyFormat:[NSNumber numberWithFloat:[model.wk_contractModel.contract_first_charge floatValue]]];
    _lastMoney.text = [self moneyFormat:[NSNumber numberWithFloat:[model.wk_contractModel.contract_charge floatValue] - [model.wk_contractModel.contract_first_charge floatValue]]];
    if (self.isFirstPay) {
        NSString *tempStr = [self moneyFormat:[NSNumber numberWithFloat:[model.wk_contractModel.contract_first_charge floatValue] - [model.wk_measureModel.measurement_fee floatValue]]];
        _shouldFirstMoney.text = [NSString stringWithFormat:@"%@",tempStr];
        _measureLabel.text = [self moneyFormat:[NSNumber numberWithFloat:[model.wk_measureModel.measurement_fee floatValue]]];
        _payLabel.text = @"本次应付设计首款:";
    }else {
        _measureLabel.hidden = YES;
        _mLabel.hidden = YES;
        _measureBottomCon.constant = -21;
        _mBottomCon.constant = -21;
        _shouldFirstMoney.text = _lastMoney.text;
        _payLabel.text = @"本次应付设计尾款:";
    }
    
//    NSString *flag = self.isFirstPay ? @"5" : @"6";
//    for (MPWKOrderModel *order in model.wk_orders) {
//        if ([order.order_status isEqualToString:flag]) {
//            NSLog(@"order_id : %@",order.order_no);
//            NSLog(@"order_line_id : %@",order.order_line_no);
//            _orderid = order.order_no;
//            _orderline = order.order_line_no;
//        }
//    }
}

@end
