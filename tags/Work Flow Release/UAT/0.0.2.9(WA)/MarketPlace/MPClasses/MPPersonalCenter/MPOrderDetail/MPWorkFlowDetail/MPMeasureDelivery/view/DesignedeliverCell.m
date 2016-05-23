//
//  DesignedeliverCell.m
//  MarketPlace
//
//  Created by zzz on 16/3/16.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "DesignedeliverCell.h"

@implementation DesignedeliverCell

- (void)awakeFromNib {
    // Initialization code

    
}

- (IBAction)HousingBtn:(id)sender {

    [self.delegate SeliveryBtn:sender];
}

- (IBAction)SentBtn:(id)sender {

    
    [self.delegate SentBtn:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
