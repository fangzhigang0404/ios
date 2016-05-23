/**
 * @file    MPDesignerCenterTableViewCell.m
 * @brief   the view of designer Message Center cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPDesignerCenterTableViewCell.h"

@implementation MPDesignerCenterTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _headIconBtn.layer.cornerRadius = 54.0;
    _headIconBtn.layer.masksToBounds = YES;
    _cerfication.hidden = YES;
    
}
- (IBAction)headIconBtnClick:(id)sender {
    
    [self.delegate headIconBtnClick:sender cerficationBtnClick:nil];
    
}
- (IBAction)cerficationBtnClick:(id)sender {
    
    [self.delegate headIconBtnClick:nil cerficationBtnClick:sender];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
