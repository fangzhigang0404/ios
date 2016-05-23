/**
 * @file    MPMeaNeedInfoCell.m
 * @brief   the view of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-25
 */

#import "MPMeaNeedInfoCell.h"
#import "MPDecorationNeedModel.h"

@interface MPMeaNeedInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *contactsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactsMobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *designBudget;
@property (weak, nonatomic) IBOutlet UILabel *renovationBudget;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

@end

@implementation MPMeaNeedInfoCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)updateMeaNeedInfoCell {
    if ([self.delegate respondsToSelector:@selector(getModelForMeaNeedInfoView)]) {
        MPDecorationNeedModel *model = [self.delegate getModelForMeaNeedInfoView];
        self.contactsNameLabel.text = (model.contacts_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.contacts_name;
        self.contactsMobileLabel.text = (model.contacts_mobile == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.contacts_mobile;
        self.houseSizeLabel.text = [NSString stringWithFormat:@"%@%@%@",
                                    (model.room == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.room,
                                    (model.living_room == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.living_room,
                                    (model.toilet == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.toilet];
        self.houseAreaLabel.text = [NSString stringWithFormat:@"%@㎡",(model.house_area == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.house_area];
        self.designBudget.text = (model.design_budget == nil)?NSLocalizedString(@"no_design_budget", nil):model.design_budget;
        self.renovationBudget.text = (model.decoration_budget == nil)?NSLocalizedString(@"no_design_budget", nil):model.decoration_budget;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@",
                                  (model.province_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.province_name,
                                  (model.city_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.city_name,
                                  (model.district_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.district_name];
        self.communityNameLabel.text = (model.community_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.community_name;
    }
}


@end
