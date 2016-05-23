/**
 * @file    MPheadIconTableViewCell.m
 * @brief   the view of MPheadIconTableViewCell cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */


#import "MPheadIconTableViewCell.h"

@implementation MPheadIconTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _headIcon.layer.masksToBounds = YES;
    _headIcon.layer.cornerRadius = 40.0;
    _uploadIcon.layer.masksToBounds = YES;
    _uploadIcon.layer.cornerRadius = 10.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)headIconBtn:(UIButton *)sender {
    
    [self.delegate HeadIconBtnClick:sender];
    
}

@end
