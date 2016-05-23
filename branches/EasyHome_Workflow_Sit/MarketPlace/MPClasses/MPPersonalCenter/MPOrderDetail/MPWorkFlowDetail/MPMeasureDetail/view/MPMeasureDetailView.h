//
//  MPMeasureDetailView.h
//  MarketPlace
//
//  Created by Jiao on 16/1/28.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMeasureDetailModel, MPStatusDetail;
@protocol MPMeasureDetailViewDelegate <NSObject>



@end
@interface MPMeasureDetailView : UIView
@property (nonatomic, weak) id<MPMeasureDetailViewDelegate> delegate;

- (void)refreshMeasureDetailView;
@end
