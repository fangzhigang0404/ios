//
//  MPPayBaseCell.m
//  MarketPlace
//
//  Created by Jiao on 16/3/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPPayBaseCell.h"

@implementation MPPayBaseCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateDetailCellForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(updateCellData)]) {
        [self updateCellDataWithModel:[self.delegate updateCellData]];
    }
    if ([self.delegate respondsToSelector:@selector(updateCellUI)]) {
        [self updateCellUIWithModel:[self.delegate updateCellUI]];
    }
}

- (void)updateCellDataWithModel:(MPStatusModel *)model {
    _orderNumber.text = @"无编号";
    _nameLabel.text = model.designer_realName;
    _mobilePhone.text = model.designer_mobile;
    
}

- (void)updateCellUIWithModel:(MPStatusDetail *)model {
    if (model.selectShow) {
        payBtn.hidden = NO;
    }else {
        payBtn.hidden = YES;
    }
}

- (IBAction)alipayBtnClick:(id)sender {
    NSLog(@"点击了button");
    //先将未到时间执行前的任务取消。
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(gotoPay:) object:sender];
    [self performSelector:@selector(gotoPay:) withObject:sender afterDelay:0.2f];
    
}

- (void)gotoPay:(id)sender {
    MPLog(@"执行了代理");
    if ([self.delegate respondsToSelector:@selector(goToAlipay)]) {
        [self.delegate goToAlipay];
    }
}

- (NSString *)moneyFormat:(NSNumber *)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSMutableString *string = [NSMutableString stringWithString:[formatter stringFromNumber:num]];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSInteger loc = [string rangeOfCharacterFromSet:characterSet].location;
    NSString *resultStr = [NSString stringWithFormat:@"¥ %@",[string substringFromIndex:loc]];
    return resultStr;
}
@end
