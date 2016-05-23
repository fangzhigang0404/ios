/**
 * @file    MPDesignerDetailHeaderTableViewCell.m
 * @brief   the cell of designer detail.
 * @author  niu
 * @version 1.0
 * @date    2015-01-26
 */

#import "MPDesignerDetailHeaderTableViewCell.h"
#import "MPDesignerInfoModel.h"
#import "UIImageView+WebCache.h"

@interface MPDesignerDetailHeaderTableViewCell ()

/// icon imageView.
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
/// style.
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
/// diy count.
@property (weak, nonatomic) IBOutlet UILabel *diyCountLabel;
/// money information.
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/// V imageView.
@property (weak, nonatomic) IBOutlet UIImageView *isRealImageView;
/// chat button.
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
/// choose button.
@property (weak, nonatomic) IBOutlet UIButton *chooseTaMeasure;

@end

@implementation MPDesignerDetailHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.iconImageView.clipsToBounds = YES;
    self.iconImageView.layer.cornerRadius = 43.0f;
    self.chatButton.clipsToBounds = YES;
    self.chatButton.layer.cornerRadius = 6.0f;
    self.chooseTaMeasure.clipsToBounds = YES;
    self.chooseTaMeasure.layer.cornerRadius = 6.0f;
    self.isRealImageView.hidden = YES;
}

- (void)updateCellForIndex:(NSInteger)index isCenter:(BOOL)isCenter {
    if ([self.delegate respondsToSelector:@selector(getDesignerInfoModel)]) {
        if (isCenter){
            self.chatButton.hidden = YES;
            self.chooseTaMeasure.hidden = YES;
        }
        MPDesignerInfoModel *model      = [self.delegate getDesignerInfoModel];
        
        NSString *diyCounet;
        if (model.designer.experience == nil) {
            diyCounet = NSLocalizedString(@"no_design_budget", nil);
        } else {
            diyCounet = [NSString stringWithFormat:@"%@%@",model.designer.experience,NSLocalizedString(@"just_tip_year", nil)];
        }
        
        self.diyCountLabel.text         = [NSString stringWithFormat:@"%@:%@",
                                           NSLocalizedString(@"just_tip_work_year", nil),
                                           diyCounet];
        
        self.styleLabel.text            = [NSString stringWithFormat:@"%@:%@",
                                           NSLocalizedString(@"just_tip_good_style", nil),
                                           (model.designer.styles == nil)?NSLocalizedString(@"no_design_budget", nil):model.designer.style_names];
        NSString *design_budget;
        if (model.designer.design_price_min == nil) {
            design_budget = NSLocalizedString(@"no_design_budget", nil);
        } else {
            design_budget = [NSString stringWithFormat:@"%@-%@%@/m²",
                             model.designer.design_price_min,
                             model.designer.design_price_max,
                             NSLocalizedString(@"just_yuan_", nil)];
        }
        
        NSString *money;
        if (model.designer.measurement_price == nil) {
            money = NSLocalizedString(@"no_design_budget", nil);
        } else {
            money = [NSString stringWithFormat:@"%@%@",model.designer.measurement_price,NSLocalizedString(@"just_yuan_", nil)];
        }
        self.moneyLabel.text            = [NSString stringWithFormat:@"%@:%@ 丨 %@:%@",
                                           NSLocalizedString(@"Design_key", nil),
                                           design_budget,
                                           NSLocalizedString(@"Amount of room cost_key_", nil),
                                           money];
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
        NSInteger realname = [model.designer.is_real_name integerValue];
        if (realname == 2) {
            self.isRealImageView.hidden = NO;
        } else {
            self.isRealImageView.hidden = YES;
        }
    }
}

- (IBAction)chatButtonAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chatWithDesigner)]) {
        [self.delegate chatWithDesigner];
    }
}

- (IBAction)chaooseTaMeasure:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chooseTAMeasure)]) {
        [self.delegate chooseTAMeasure];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
