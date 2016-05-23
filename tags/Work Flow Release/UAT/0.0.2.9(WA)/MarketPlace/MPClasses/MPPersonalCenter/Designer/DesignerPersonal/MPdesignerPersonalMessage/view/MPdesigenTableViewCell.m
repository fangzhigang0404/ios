/**
 * @file    MPdesigenTableViewCell.m
 * @brief   the view of designer Message Center cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPdesigenTableViewCell.h"

@implementation MPdesigenTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}
- (void)setModel:(MPMemberModel *)model {
    if (_model != model) {
        model = _model;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
