//
//  MPOrderCurrentStateCell.m
//  MarketPlace
//
//  Created by Jiao on 16/1/27.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPOrderCurrentStateCell.h"
#import "MPOrderCurrentStateModel.h"

@interface MPOrderCurrentStateCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLabel;
@end

@implementation MPOrderCurrentStateCell

- (void)awakeFromNib {
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = self.iconImageView.frame.size.width/2;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)updateCellForIndex:(NSUInteger)index {
    if ([self.delegate respondsToSelector:@selector(getContractModelForIndex:)]) {
        MPOrderCurrentStateModel *model = [self.delegate getContractModelForIndex:index];
        self.iconImageView.image = [UIImage imageNamed:model.imageName];
        self.titleLabel.text = model.title;
        self.detailTitleLabel.text = model.detailTitle;
        self.contentView.alpha = 0.2;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
