//
//  MPMyProjectInfoTableViewCell.m
//  MarketPlace
//
//  Created by xuezy on 16/3/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMyProjectInfoTableViewCell.h"
@interface MPMyProjectInfoTableViewCell ()

@end

@implementation MPMyProjectInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
