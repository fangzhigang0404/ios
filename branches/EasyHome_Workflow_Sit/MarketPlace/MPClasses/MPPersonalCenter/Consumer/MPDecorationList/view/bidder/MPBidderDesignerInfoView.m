/**
 * @file    MPBidderDesignerInfoView.m
 * @brief   the view for bidder designer.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPBidderDesignerInfoView.h"
#import "MPDecorationNeedModel.h"
#import "UIImageView+WebCache.h"

@interface MPBidderDesignerInfoView ()

/// show V image.
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

/// designer avator.
@property (weak, nonatomic) IBOutlet UIImageView *designerIcon;

/// designer name.
@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;

/// good styles for designer.
@property (weak, nonatomic) IBOutlet UILabel *stylesLabel;

/// designer budget.
@property (weak, nonatomic) IBOutlet UILabel *designBudgetLabel;


/// choose button.
@property (weak, nonatomic) IBOutlet UIButton *measureBtn;

/// chat button
@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

/// refuse button.
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;

/// close button.
@property (weak, nonatomic) IBOutlet UIImageView *closeImage;

@end

@implementation MPBidderDesignerInfoView
{
    NSInteger _index;                   //!< _index the index for designer in bidders.
    MPDecorationBidderModel *_model;    //!< _model the model for designer.
    MPDecorationNeedModel *_needModel;  //!< _needModel the model for decoration.
}

- (void)awakeFromNib {
    self.designerIcon.clipsToBounds      = YES;
    self.designerIcon.layer.cornerRadius = 37.0f;
    self.chatBtn.clipsToBounds           = YES;
    self.chatBtn.layer.cornerRadius      = 8;
    self.measureBtn.clipsToBounds        = YES;
    self.measureBtn.layer.cornerRadius   = 8;
    self.refuseBtn.clipsToBounds         = YES;
    self.refuseBtn.layer.cornerRadius    = 8;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 8;
    [self.designerIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickDesignerIcon)]];
    [self.closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeBidderView)]];
}

- (void)updateViewWithModel:(MPDecorationBidderModel *)model
                      index:(NSInteger)index
                  needModel:(MPDecorationNeedModel *)needModel {
    
    _index = index;
    _model = model;
    _needModel = needModel;
    [self.designerIcon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
    self.designerNameLabel.text = (model.user_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.user_name;
    self.stylesLabel.text  = [NSString stringWithFormat:@"%@: %@",
                              NSLocalizedString(@"famouskey", nil),
                              (model.style_names == nil)?NSLocalizedString(@"no_design_budget", nil):model.style_names];
    
    NSString *design_budget;
    if (([[model.design_price_min description] rangeOfString:@"null"].length == 4 || model.design_price_min == nil)) {
        design_budget = NSLocalizedString(@"no_design_budget", nil);
    } else {
        design_budget = [NSString stringWithFormat:@"%@-%@%@/m²",
                         model.design_price_min,
                         model.design_price_max,
                         NSLocalizedString(@"just_yuan_", nil)];
    }
    self.designBudgetLabel.text = [NSString stringWithFormat:@"%@: %@",
                                   NSLocalizedString(@"Design_key",nil),
                                   design_budget];
}

- (IBAction)chooseTAMeasuew{
    if ([self.delegate respondsToSelector:@selector(clickedButtonAtIndex:index:bidderModel:needModel:)]) {
        [self.delegate clickedButtonAtIndex:MPBidderButtonIndexMeasure index:_index bidderModel:_model needModel:_needModel];
    }
}

- (IBAction)chatButton {
    if ([self.delegate respondsToSelector:@selector(clickedButtonAtIndex:index:bidderModel:needModel:)]) {
        [self.delegate clickedButtonAtIndex:MPBidderButtonIndexChat index:_index bidderModel:_model needModel:_needModel];
    }
}

- (IBAction)refuseButton {
    if ([self.delegate respondsToSelector:@selector(clickedButtonAtIndex:index:bidderModel:needModel:)]) {
        [self.delegate clickedButtonAtIndex:MPBidderButtonIndexRefuse index:_index bidderModel:_model needModel:_needModel];
    }
}

- (void)closeBidderView {
    if ([self.delegate respondsToSelector:@selector(clickedButtonAtIndex:index:bidderModel:needModel:)]) {
        [self.delegate clickedButtonAtIndex:MPBidderButtonIndexClose index:_index bidderModel:_model needModel:_needModel];
    }
}

- (void)clickDesignerIcon {
    if ([self.delegate respondsToSelector:@selector(clickedButtonAtIndex:index:bidderModel:needModel:)]) {
        [self.delegate clickedButtonAtIndex:MPBidderButtonIndexHeader index:_index bidderModel:_model needModel:_needModel];
    }
}

@end
