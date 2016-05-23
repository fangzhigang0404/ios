//
//  MPMyAssetsDetail.m
//  MarketPlace
//
//  Created by Jiao on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMyAssetsDetail.h"

@implementation MPMyAssetsDetail
{
    
    __weak IBOutlet UILabel *designer_amountLabel;
    __weak IBOutlet UIButton *withdrawBtn;
    
}

- (void)awakeFromNib {

}

- (void)refreshWithAmount:(NSString *)amount {
    
    NSLog(@"我 的 钱：%@",amount);
    if ([amount isEqualToString:@"¥ 0.00"] || [amount isEqualToString:@"￥ 0"]) {
        
        withdrawBtn.backgroundColor=[UIColor lightGrayColor];
        withdrawBtn.enabled = NO;
    }else {
    
        withdrawBtn.backgroundColor = ColorFromRGA(0x0E6BFF, 1);
        withdrawBtn.enabled = YES;
    }
    
    designer_amountLabel.text = amount;
}
- (IBAction)tradingDetail:(id)sender {
    if ([self.delegate respondsToSelector:@selector(tradeRecord)]) {
        [self.delegate tradeRecord];
    }
}
- (IBAction)withdrawDetail:(id)sender {
    if ([self.delegate respondsToSelector:@selector(withdrawRecord)]) {
        [self.delegate withdrawRecord];
    }
}

#pragma mark - Withdraw
- (IBAction)withdrawClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(withdraw)]) {
        [self.delegate withdraw];
    }
}

@end
