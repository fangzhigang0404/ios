/**
 * @file    MPHomeViewCell.h
 * @brief   the cell of home case.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import "UIImageView+WebCache.h"
#import "MPHomeViewCell.h"
#import "MPCaseModel.h"
#import "MPCaseTool.h"

@interface MPHomeViewCell()

/// case imageView.
@property (weak, nonatomic) IBOutlet UIImageView *caseImageView;

/// designer avator.
@property (weak, nonatomic) IBOutlet UIImageView *designerIcon;

/// case title.
@property (weak, nonatomic) IBOutlet UILabel *caseTitleLabel;

/// detail information in case.
@property (weak, nonatomic) IBOutlet UILabel *caseInfoLabel;

/// chat button.
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

/// line view.
@property (weak, nonatomic) IBOutlet UIView *liveView;

/// the view let designer icon become round.
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@end



@implementation MPHomeViewCell
{
    NSInteger _index; //!< _index the index for model in datasource.
}

- (void)awakeFromNib {
    self.designerIcon.clipsToBounds = YES;
    self.designerIcon.layer.cornerRadius = 27.0f;
    [self.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(designerIconClicked:)]];
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        self.liveView.hidden = YES;
        self.chatBtn.hidden = YES;
    }
    self.caseTitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
}

- (IBAction)chatBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(chatButtonClickedAtIndex:)]) {
        [self.delegate chatButtonClickedAtIndex:_index];
    }
}

- (void) updateCellUIForIndex:(NSUInteger)index {
    _index = index;
    if ([self.delegate respondsToSelector:@selector(getDatamodelForIndex:)]) {
        MPCaseModel* model = [self.delegate getDatamodelForIndex:index];
        [self.designerIcon sd_setImageWithURL:[NSURL URLWithString:model.designer_info.avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
        self.caseTitleLabel.text  = (model.title == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.title;
        self.caseInfoLabel.text  = [NSString stringWithFormat:@"%@ 丨 %@ 丨 %@㎡",
                                    (model.project_style == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.project_style,
                                    (model.room_type == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.room_type,
                                    (model.room_area == nil)?@"0":model.room_area];
        
        [MPCaseTool showCaseImage:_caseImageView
                        caseArray:model.images];
    }
}


#pragma mark TapAction
- (void)designerIconClicked:(id)sender{
    if ([self.delegate respondsToSelector:@selector(designerIconClickedAtIndex:)]) {
        [self.delegate designerIconClickedAtIndex:_index];
    }
}


@end
