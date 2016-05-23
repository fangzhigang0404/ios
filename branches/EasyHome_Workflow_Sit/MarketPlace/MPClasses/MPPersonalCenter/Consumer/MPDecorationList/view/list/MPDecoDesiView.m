/**
 * @file    MPDecoDesiView.m
 * @brief   the view for bidder designer.
 * @author  niu
 * @version 1.0
 * @date    2016-02-23
 */

#import "MPDecoDesiView.h"
#import "MPDecorationNeedModel.h"
#import "UIImageView+WebCache.h"
#import "MPStatusModel.h"
#import "MPStatusMachine.h"

@interface MPDecoDesiView ()

/// designer avator.
@property (weak, nonatomic) IBOutlet UIImageView *designerIcom;

/// designer name.
@property (weak, nonatomic) IBOutlet UILabel *designerName;

/// designer status.
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation MPDecoDesiView
{
    NSInteger _section;                 //!< _section the section of indexPath.
    MPDecorationBidderModel *_model;    //!< _model the model for bidder designer.
    MPDecorationNeedModel *_needModel;  //!< _needModel the model for decoration.
}

- (void)awakeFromNib {
    self.designerIcom.clipsToBounds = YES;
    self.designerIcom.layer.cornerRadius = 25.0f;
    [self addTap];
}

/// add GestureRecognizer
- (void)addTap {
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(didSeletedDesignerAtIndex:bidderModel:needModel:)]) {
        [self.delegate didSeletedDesignerAtIndex:_section bidderModel:_model needModel:_needModel];
    }
}

- (void)updateViewAtIndex:(NSInteger)index {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getBidderDesignerModelAtIndex:)]) {
        _section = index;
        _needModel = [self.delegate getBidderDesignerModelAtIndex:index];
        _model = _needModel.bidders[index - 1];
        [self.designerIcom sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
        self.designerName.text = _model.user_name;
        
        NSInteger node = [_model.wk_cur_node_id integerValue];
        if (node == -1 && [_model.template_id isEqualToString:@"1"])
            self.statusLabel.text = NSLocalizedString(@"In the standard", nil);

        else if (node == -1) self.statusLabel.text = @"Error Status";

        else self.statusLabel.text = [MPStatusMachine getCurrentSubNodeName:_model.wk_cur_sub_node_id];
    }
}


@end
