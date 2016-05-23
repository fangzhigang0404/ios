//
//  MPDecoTopView.m
//  MarketPlace
//
//  Created by WP on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDecoTopView.h"
#import "MPDecorationNeedModel.h"
#import "MPStatusMachine.h"

@interface MPDecoTopView ()

/// community name.
@property (weak, nonatomic) IBOutlet UILabel *communityNameLabel;

/// need id.
@property (weak, nonatomic) IBOutlet UILabel *needIdLabel;

/// status.
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

/// house type.
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;

/// bidders count.
@property (weak, nonatomic) IBOutlet UILabel *biddersCountLabel;

/// decoration detail information.
@property (strong, nonatomic) IBOutlet UILabel *baseInfoLabel;

/// edit button.
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@end

@implementation MPDecoTopView
{
    NSString *_need_id; //!< _need_id the id of need.
    NSInteger _index;   //!< _index the index of model in datasource.
}

- (void)awakeFromNib {

}

- (IBAction)openNeed:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didSeletedTopView:)]) {
        [self.delegate didSeletedTopView:_index];
    }
}

- (IBAction)InfoButtonClick {
    if ([self.delegate respondsToSelector:@selector(editDecorationWithNeedId:index:)]) {
        [self.delegate editDecorationWithNeedId:_need_id index:_index];
    }
}

- (void)updateViewAtIndex:(NSInteger)index collectionRow:(NSInteger)row {
    if (self.delegate && [self.delegate respondsToSelector:@selector(getNeedModelAtIndex:)]) {
        MPDecorationNeedModel *model = [self.delegate getNeedModelAtIndex:index];
        _need_id                     = [model.needs_id description];
        _index                       = row;
        self.needIdLabel.text        = [model.needs_id description];
        self.communityNameLabel.text = model.community_name;
        
        self.baseInfoLabel.text = [NSString stringWithFormat:@"%@%@ %@%@%@ %@m²",
                                    (model.city_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.city_name,
                                    (model.district_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.district_name,
                                    model.room,
                                    model.living_room,
                                    (model.toilet == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.toilet,
                                    model.house_area];
        
        self.houseTypeLabel.text     = ([model.house_type rangeOfString:@"null"].length == 4)?NSLocalizedString(@"just_tip_no_data", nil):model.house_type;
        self.biddersCountLabel.text  = [NSString stringWithFormat:@"%ld%@",
                                        model.bidders.count,
                                        NSLocalizedString(@"designers should target", nil)];
        
        
        if ([model.wk_template_id isEqualToString:@"1"]) {
            self.infoButton.hidden = NO;
        } else {
            self.infoButton.hidden = YES;
        }
        NSInteger cancel = [model.is_public integerValue];
        if (cancel == 0) {
            
            NSInteger status = [model.custom_string_status integerValue];
            if (status == 01) self.statusLabel.text = NSLocalizedString(@"In the review_key", nil);
            
            else if (status == 03) {
                [self checkBidders:model];
            }
            
            else if (status == 02) self.statusLabel.text = NSLocalizedString(@"just_tip_status_fail", nil);
        } else {
            self.statusLabel.text = NSLocalizedString(@"just_tip_cancel", nil);
            self.infoButton.hidden = YES;
        }
    }
}

- (void)checkBidders:(MPDecorationNeedModel *)model {
    if (model.bidders.count > 0) {
        self.infoButton.hidden = YES;
        NSInteger maxCount = -1;
        
        for (MPDecorationBidderModel *modelBidder in model.bidders) {
            
            maxCount = (maxCount > [modelBidder.wk_cur_sub_node_id integerValue])?maxCount:[modelBidder.wk_cur_sub_node_id integerValue];
        }
        
        if (maxCount == -1)
            self.statusLabel.text = NSLocalizedString(@"In the standard", nil);
        else
            self.statusLabel.text = [MPStatusMachine getCurrentSubNodeName:[NSString stringWithFormat:@"%ld",maxCount]];
    } else {
        self.statusLabel.text = NSLocalizedString(@"review approved_key", nil);
    }
}

@end
