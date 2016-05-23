//
//  MPDeliveryBaseCell.m
//  MarketPlace
//
//  Created by Jiao on 16/3/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryBaseCell.h"

@implementation MPDeliveryBaseCell

- (void)awakeFromNib {
    // Initialization codeUITapGestureRecognizer *
}

- (void)updateCellForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(updateUI)] && [self.delegate updateUI]) {
        NSDictionary *dict = [self.delegate updateUI];
        _nameLabel.text = dict[@"title"];
        
        _sendBtn.enabled = [dict[@"button"] boolValue];
        _sendBtn.backgroundColor = [dict[@"button"] boolValue] ? COLOR(0, 132, 255, 1) : COLOR(153, 153, 153, 1);
    }
}

- (IBAction)sendBtnClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(sendDelivery)]) {
        [self.delegate sendDelivery];
    }
}

- (void)deliveryDetailClick:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(goToDeliveryDetailForIndex:)]) {
//        sender.view.tag
        [self.delegate goToDeliveryDetailForIndex:sender.view.tag%200];
    }
}
@end
