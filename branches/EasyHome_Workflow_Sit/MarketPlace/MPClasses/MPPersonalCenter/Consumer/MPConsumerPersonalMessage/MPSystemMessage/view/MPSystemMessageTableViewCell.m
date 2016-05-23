//
//  MPSystemMessageTableViewCell.m
//  MarketPlace
//
//  Created by xuezy on 16/3/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPSystemMessageTableViewCell.h"
#import "MPSystemMessageModel.h"
@interface MPSystemMessageTableViewCell ()

@property (strong,nonatomic)IBOutlet UILabel *timeLabel;
@property (strong,nonatomic)IBOutlet UILabel *contentLabel;

@end
@implementation MPSystemMessageTableViewCell

-(void) updateCellForIndex:(NSUInteger) index
{
    if ([self.delegate respondsToSelector:@selector(getSystemMessaggeModelForIndex:)])
    {
        MPSystemMessageModel *model = [self.delegate getSystemMessaggeModelForIndex:index];
        
        self.timeLabel.text = model.sent_time;
        
        self.contentLabel.text = model.body;
    }
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
