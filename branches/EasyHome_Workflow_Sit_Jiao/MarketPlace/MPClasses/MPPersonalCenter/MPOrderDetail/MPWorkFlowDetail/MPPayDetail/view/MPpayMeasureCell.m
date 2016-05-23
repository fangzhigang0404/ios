//
//  MPpayMeasureCell.m
//  MarketPlace
//
//  Created by Jiao on 16/3/1.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPpayMeasureCell.h"
#import "MPWKOrderModel.h"

@implementation MPpayMeasureCell
{
    __weak IBOutlet UILabel *_measureFeeLabel;
    
}
- (void)awakeFromNib {
    // Initialization code    
}

- (void)updateCellDataWithModel:(MPStatusModel *)model {
    [super updateCellDataWithModel:model];
    _measureFeeLabel.text = [self moneyFormat:[NSNumber numberWithFloat:[model.wk_measureModel.measurement_fee floatValue]]];
    
    for (MPWKOrderModel *order in model.wk_orders) {
        if ([order.order_type isEqualToString:@"0"]) {
            NSLog(@"order_id : %@",order.order_no);
            NSLog(@"order_line_id : %@",order.order_line_no);
            _orderid = order.order_no;
            _orderline = order.order_line_no;
        }
    }
}

@end
