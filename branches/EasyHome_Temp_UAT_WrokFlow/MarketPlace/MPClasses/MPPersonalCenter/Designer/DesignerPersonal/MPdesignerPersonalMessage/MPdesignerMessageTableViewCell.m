/**
 * @file    MPdesignerMessageTableViewCell.m
 * @brief   the view of designer Message Center cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */
#import "MPdesignerMessageTableViewCell.h"

@implementation MPdesignerMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
    _headIconBtnClick.layer.masksToBounds = YES;
    _headIconBtnClick.layer.cornerRadius = 40.0;
    _upBtn.layer.masksToBounds = YES;
    _upBtn.layer.cornerRadius = 10.0;
    
}

- (IBAction)headBtnClick:(id)sender {
    
    [self.delegate headBtnClick:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
