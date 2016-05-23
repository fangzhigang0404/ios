/**
 * @file    MPConsumerPersonelTableViewCell.m
 * @brief   the view of MPConsumerCenterView cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */
#import "MPConsumerPersonelTableViewCell.h"
#import "MPConsumerPersonalCenterViewController.h"
#import "MPMemberModel.h"
#import <UIButton+WebCache.h>
@implementation MPConsumerPersonelTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _headButton.layer.masksToBounds=YES;
    _headButton.layer.cornerRadius = 54.0;
    _imgView.image = [UIImage imageNamed:b_g];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)_btnClick:(UIButton *)sender {
    [self.delegate BtnClickConsumer:_button];
    NSLog(@"-------------------");
}

    

@end
