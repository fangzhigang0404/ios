/**
 * @file    MPDesignerDetailTableViewCell.m
 * @brief   the cell of designer detail.
 * @author  niu
 * @version 1.0
 * @date    2015-01-26
 */

#import "MPDesignerDetailTableViewCell.h"
#import "MPCaseModel.h"
#import "UIImageView+WebCache.h"
#import "MPCaseTool.h"

@interface MPDesignerDetailTableViewCell ()

/// case image.
@property (weak, nonatomic) IBOutlet UIImageView *caseImageView;
/// case title.
@property (weak, nonatomic) IBOutlet UILabel *caseTitleLabel;
/// case detail information.
@property (weak, nonatomic) IBOutlet UILabel *deatilInfoLabel;

@end

@implementation MPDesignerDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.caseTitleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
}

- (void)updateCellForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(getDesignerDetailModelAtIndex:)]) {
        MPCaseModel *model = [self.delegate getDesignerDetailModelAtIndex:index];
        self.caseTitleLabel.text  = (model.title == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.title;
        self.deatilInfoLabel.text  = [NSString stringWithFormat:@"%@ 丨 %@ 丨 %@㎡",
                                    (model.project_style == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.project_style,
                                    (model.room_type == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.room_type,
                                    (model.room_area == nil)?@"0":model.room_area];
        
        [MPCaseTool showCaseImage:_caseImageView
                        caseArray:model.images];
    }
}

@end
