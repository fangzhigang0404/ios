//
//  MPDeliveryDetail.h
//  MarketPlace
//
//  Created by Jiao on 16/3/24.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MP3DPlanModel.h"
#import "MPDeliveryDetailCell.h"

@protocol MPDeliveryDetailViewDelegate <NSObject>

- (NSArray *)getFilesArray;
- (void)confirmDelivery;

@end

@interface MPDeliveryDetailView : UIView

@property (nonatomic, weak) id<MPDeliveryDetailViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withcType:(NSInteger)cType;
- (void)refreshDetailView;
@end
