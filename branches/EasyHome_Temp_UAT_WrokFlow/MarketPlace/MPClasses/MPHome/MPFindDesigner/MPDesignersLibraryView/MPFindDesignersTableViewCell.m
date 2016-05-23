/**
 * @file    MPFindDesignersTableViewCell.m
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPFindDesignersTableViewCell.h"
#import "MPDesignerInfoModel.h"
#import "UIImageView+WebCache.h"


@interface MPFindDesignersTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workLabel;
@property (weak, nonatomic) IBOutlet UILabel *skillLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageview;
@property (weak, nonatomic) IBOutlet UIImageView *VimageView;
@property (assign, nonatomic) NSUInteger index;

@end
@implementation MPFindDesignersTableViewCell


-(void) updateCellForIndex:(NSUInteger) index
{
    if ([self.delegate respondsToSelector:@selector(getDesignerLibraryModelForIndex:)])
    {
        [self.contentView bringSubviewToFront:self.VimageView];
        self.index = index;
        MPDesignerInfoModel *model = [self.delegate getDesignerLibraryModelForIndex:self.index];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        
        [self.headerImageview sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
        
        if ([model.designer.is_real_name intValue]== 2) {
            self.VimageView.image = [UIImage imageNamed:VERIFIED_V];//已认证
        } else {
            self.VimageView.image = [UIImage imageNamed:@""];
        }

        NSString *design_budget;
        if (([[model.designer.design_price_min description] rangeOfString:@"null"].length == 4 || model.designer.design_price_min == nil)) {
            design_budget = NSLocalizedString(@"no_design_budget", nil);
        } else {
            design_budget = [NSString stringWithFormat:@"%@-%@%@",
                             model.designer.design_price_min,
                             model.designer.design_price_max,
                             NSLocalizedString(@"just_yuan_meter", nil)];
        }
        
        self.priceLabel.text = design_budget;

        self.designerNameLabel.text = (model.nick_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.nick_name;
        
        NSString *works = [NSString stringWithFormat:@"%@ %@",
                           NSLocalizedString(@"worksKey", nil),
                           (model.designer.case_count == nil)?@(0):model.designer.case_count];
        self.workLabel.text = works;
        
        
        NSString *stilledStr = [NSString stringWithFormat:@"%@ %@",
                                NSLocalizedString(@"famous_Key", nil),
                                (model.designer.style_names == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.designer.style_names];
        self.skillLabel.text = stilledStr;        
        if ([AppController AppGlobal_GetIsDesignerMode] == YES) {
            self.chatButton.hidden = YES;
        }else{
            self.chatButton.hidden = NO;
        }
    }
}
- (IBAction)onChatTap:(id)sender {

       [self.delegate startChatWithDesignerForIndex:self.index];

}
- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headerImageview.layer.masksToBounds = YES;
    self.headerImageview.layer.cornerRadius = 30.5f;
}

@end
