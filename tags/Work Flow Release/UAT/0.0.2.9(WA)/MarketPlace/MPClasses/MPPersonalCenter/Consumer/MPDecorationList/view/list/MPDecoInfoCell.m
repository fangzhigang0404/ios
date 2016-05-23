/**
 * @file    MPDecoInfoCell.m
 * @brief   the view for decoration.
 * @author  niu
 * @version 1.0
 * @date    2016-02-23
 */

#import "MPDecoInfoCell.h"
#import "MPDecorationNeedModel.h"

@interface MPDecoInfoCell ()

/// design budget.
@property (weak, nonatomic) IBOutlet UILabel *designBudgetLabel;

/// decoration budget.
@property (weak, nonatomic) IBOutlet UILabel *decorationBudgetLabel;

/// house type.
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;

/// decoration style.
@property (weak, nonatomic) IBOutlet UILabel *decorationStyleLabel;

/// address.
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/// publish time label.
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

/// styles.
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;

@end

@implementation MPDecoInfoCell

- (void)awakeFromNib {
    // Initialization code.
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.styleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)updateCellAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(getModelForDecoInfoViewAtIndex:)]) {
        MPDecorationNeedModel *model = [self.delegate getModelForDecoInfoViewAtIndex:index];
        self.decorationBudgetLabel.text = (model.decoration_budget == nil)?NSLocalizedString(@"no_design_budget", nil):model.decoration_budget;
        self.designBudgetLabel.text = (model.design_budget == nil)?NSLocalizedString(@"no_design_budget", nil):model.design_budget;
        NSString *endTime = [NSString stringWithFormat:@"%@%@",model.end_day,
                             NSLocalizedString(@"day_key", nil)];
        if ([model.is_public integerValue] != 0) endTime = NSLocalizedString(@"just_already_end", nil);
        self.houseTypeLabel.text = endTime;
        self.decorationStyleLabel.text = (model.decoration_style == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.decoration_style;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",model.province_name,model.city_name,model.district_name];
        self.publishTimeLabel.text = model.publish_time;
    }
}




@end
