//
//  MPMyAssetsDetail.h
//  MarketPlace
//
//  Created by Jiao on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPMyAssetsDetailDelegate <NSObject>

@required

- (void)withdraw;
- (void)tradeRecord;
- (void)withdrawRecord;
@end

@interface MPMyAssetsDetail : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) id<MPMyAssetsDetailDelegate> delegate;

- (void)refreshWithAmount:(NSString *)amount;
@end
