/**
 * @file    MPBiddingTableViewCell.m.
 * @brief   the view for cell.
 * @author  Xue.
 * @version 1.0.
 * @date    2016-02-24.
 */

#import "MPBiddingTableViewCell.h"
#import "MPDecorationNeedModel.h"
@interface MPBiddingTableViewCell ()
/// the label for show project name.
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// the label for show bidding people count.
@property (weak, nonatomic) IBOutlet UILabel *biddingCounLabel;

/// the label for show bidding people name.
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// the label for show bidding decoration budget.
@property (weak, nonatomic) IBOutlet UILabel *decoration_budgetLabel;

/// the label for show decoration budget title.
@property (weak, nonatomic) IBOutlet UILabel *decoration_budget_title_Label;

/// the label for show bidderInfo.
@property (weak, nonatomic) IBOutlet UILabel *bidderInfoLabel;

@end
@implementation MPBiddingTableViewCell

-(void) updateCellForIndex:(NSUInteger) index
{
    if ([self.delegate respondsToSelector:@selector(getBidingModelForIndex:)])
    {
        MPDecorationNeedModel *model = [self.delegate getBidingModelForIndex:index];
        self.titleLabel.text = model.community_name;
//        self.biddingCounLabel.text = [NSString stringWithFormat:@"%@%@",model.bidder_count,NSLocalizedString(@"designers should target", nil)];
        self.decoration_budgetLabel.text = [NSString stringWithFormat:@"%@",model.decoration_budget];
        self.bidderInfoLabel.text = [NSString stringWithFormat:@"%@/%@%@%@ %@㎡",model.decoration_style,model.room,model.living_room,model.toilet,model.house_area];
        self.nameLabel.text = [NSString stringWithFormat:@"%@",model.contacts_name];
        self.decoration_budget_title_Label.text = NSLocalizedString(@"just_decoration_budget", nil);
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
