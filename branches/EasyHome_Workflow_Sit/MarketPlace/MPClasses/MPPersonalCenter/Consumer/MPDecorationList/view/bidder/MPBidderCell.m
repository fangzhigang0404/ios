//
//  MPBidderCell.m
//  MarketPlace
//
//  Created by WP on 16/3/5.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPBidderCell.h"
#import "MPDecorationBidderModel.h"

@interface MPBidderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *designerIcon;
@property (weak, nonatomic) IBOutlet UILabel *designerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *stylesLabel;
@property (weak, nonatomic) IBOutlet UILabel *measurePriceLabel;

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

@end

@implementation MPBidderCell

- (void)awakeFromNib {
    // Initialization code
    self.designerIcon.clipsToBounds = YES;
    self.designerIcon.layer.cornerRadius = 45.0f;
    
    self.chooseButton.layer.cornerRadius = 6.0f;
    self.chooseButton.clipsToBounds = YES;
    self.refuseButton.layer.cornerRadius = 6.0f;
    self.refuseButton.clipsToBounds = YES;
    self.chatButton.layer.cornerRadius = 6.0f;
    self.chatButton.clipsToBounds = YES;
}

- (IBAction)chooseButtonAction:(id)sender {
    
}

- (IBAction)refuseButtonAction:(id)sender {
    
}

- (IBAction)chatButtonAction:(id)sender {
    
}

- (void)updateCellAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(getBidderModelAtIndex:)]) {
        MPDecorationBidderModel *model = [self.delegate getBidderModelAtIndex:index];
        NSLog(@"%@",model.avatar);
    }
}

@end
