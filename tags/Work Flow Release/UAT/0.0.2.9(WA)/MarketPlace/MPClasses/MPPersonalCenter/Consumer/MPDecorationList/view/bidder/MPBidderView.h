//
//  MPBidderView.h
//  MarketPlace
//
//  Created by WP on 16/3/5.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPBidderViewDelegate <NSObject>

- (NSInteger)getBidderRowsInSection;

@end

@interface MPBidderView : UIView

@property (nonatomic, assign) id<MPBidderViewDelegate>delegate;

- (void)refreshBidderUI;

@end
