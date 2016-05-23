/**
 * @file    MPDecoBeishuCell.m
 * @brief   the view for cell.
 * @author  niu
 * @version 1.0
 * @date    2016-02-18
 */

#import "MPDecoBeishuCell.h"
#import "MPDecorationNeedModel.h"
#import "UIImageView+WebCache.h"
#import "MPRegionManager.h"

@interface MPDecoBeishuCell ()

/// the label for show community name.
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

/// the label for show need id.
@property (weak, nonatomic) IBOutlet UILabel *needIdLabel;

/// the label for show name.
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

/// the label for show address.
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/// the label for show community name.
@property (weak, nonatomic) IBOutlet UILabel *communityNLabel;

/// the button for calling.
@property (weak, nonatomic) IBOutlet UIButton *phoneNumButton;

/// designer avator.
@property (weak, nonatomic) IBOutlet UIImageView *designerIcon;

/// designer name.
@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;

/// chat button.
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end

@implementation MPDecoBeishuCell
{
    MPDecorationNeedModel *_model; //!< _model the model for decoration.
}

- (void)awakeFromNib {
    // Initialization code
    self.chatButton.layer.cornerRadius   = 6;
    self.chatButton.clipsToBounds        = YES;
    self.designerIcon.clipsToBounds      = YES;
    self.designerIcon.layer.cornerRadius = 25.0f;
}

- (void)updateCellForIndex:(NSUInteger)index {

    if ([self.delegate respondsToSelector:@selector(getDecorationModelAtIndex:)]) {
        _model = [self.delegate getDecorationModelAtIndex:index];
        self.communityNameLabel.text = _model.community_name;
        self.communityNLabel.text    = _model.community_name;
        self.needIdLabel.text        = [_model.needs_id description];
        self.nameLabel.text          = _model.contacts_name;
        
        self.addressLabel.text       = [NSString stringWithFormat:@"%@ %@ %@",
                                        (_model.province_name == nil || [_model.province_name rangeOfString:@"null"].length == 4)?NSLocalizedString(@"just_tip_no_data", nil):_model.province_name,
                                        (_model.city_name== nil || [_model.city_name rangeOfString:@"null"].length == 4)?NSLocalizedString(@"just_tip_no_data", nil):_model.city_name,
                                        (_model.district_name == nil || [_model.district_name rangeOfString:@"null"].length == 4)?NSLocalizedString(@"just_tip_no_data", nil):_model.district_name];
        
        [self.phoneNumButton setTitle:_model.contacts_mobile forState:UIControlStateNormal];
        if (_model.bidders.count > 0) {
            MPDecorationBidderModel *modelBidder = _model.bidders[0];
            self.designerNameLabel.text = (modelBidder.user_name == nil)?NSLocalizedString(@"just_tip_no_info", nil):modelBidder.user_name;
            [self.designerIcon sd_setImageWithURL:[NSURL URLWithString:modelBidder.avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
        }
    }
}

- (IBAction)chatButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chatWithDesigner:)]) {
        [self.delegate chatWithDesigner:_model];
    }
}

- (IBAction)phoneNumBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(callPhoneNumber:)]) {
        [self.delegate callPhoneNumber:sender.titleLabel.text];
    }
}

@end
