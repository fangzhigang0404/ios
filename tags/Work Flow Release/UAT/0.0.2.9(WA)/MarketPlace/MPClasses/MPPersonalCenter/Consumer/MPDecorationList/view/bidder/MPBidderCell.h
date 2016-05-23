//
//  MPBidderCell.h
//  MarketPlace
//
//  Created by WP on 16/3/5.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPDecorationBidderModel;
@protocol MPBidderCellDelegate <NSObject>

- (MPDecorationBidderModel *)getBidderModelAtIndex:(NSInteger)index;

@end

@interface MPBidderCell : UITableViewCell

@property (nonatomic, assign) id<MPBidderCellDelegate>delegate;

- (void)updateCellAtIndex:(NSInteger)index;

@end
