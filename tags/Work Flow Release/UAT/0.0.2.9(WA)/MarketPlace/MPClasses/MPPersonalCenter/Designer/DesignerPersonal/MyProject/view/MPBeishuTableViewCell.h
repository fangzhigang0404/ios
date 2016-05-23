//
//  MPBeishuTableViewCell.h
//  MarketPlace
//
//  Created by xuezy on 16/1/20.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMyProjectModel.h"

@interface MPBeishuTableViewCell : UITableViewCell

@property (nonatomic,strong)IBOutlet UILabel *projectNumberLabel;
@property (nonatomic,strong)IBOutlet UILabel *nameLabel;
@property (nonatomic,strong)IBOutlet UILabel *phoneLable;
@property (nonatomic,strong)IBOutlet UILabel *addressLabel;
@property (nonatomic,strong)IBOutlet UIButton *chatButton;
@property (nonatomic,strong)IBOutlet UILabel *communityLabel;
@property (nonatomic,strong)IBOutlet UILabel *titleLabel;
@property (nonatomic,strong)IBOutlet UILabel *memberNameLabel;
@property (nonatomic,strong)IBOutlet UIImageView *memberAvatar;
@property (nonatomic,strong)MPMyProjectModel *model;
- (void)upLoadData;
@end
