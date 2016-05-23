//
//  MPDeliveryForMeasureCell.m
//  MarketPlace
//
//  Created by Jiao on 16/3/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryForMeasureCell.h"

@implementation MPDeliveryForMeasureCell
{
    __weak IBOutlet UIView *_measureBackView;
    __weak IBOutlet UIImageView *_measureImgView;
}
- (void)awakeFromNib {
    UITapGestureRecognizer *tgr1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deliveryDetailClick:)];
    [_measureBackView addGestureRecognizer:tgr1];
}

- (void)updateCellForIndex:(NSInteger)index {
    [super updateCellForIndex:index];
    if ([self.delegate respondsToSelector:@selector(updateUI)] && [self.delegate updateUI]) {
        NSDictionary *dict = [self.delegate updateUI];
        _sendBtn.hidden = ![dict[@"isDesigner"] boolValue];
       
        [_measureImgView setImage:[UIImage imageNamed:[dict[@"arr_design"] boolValue] ? @"Delivery_measure_2" : @"Delivery_measure_1"]];
        _measureBackView.userInteractionEnabled = [dict[@"arr_design"] boolValue] ? YES : NO;
    }
}

@end
