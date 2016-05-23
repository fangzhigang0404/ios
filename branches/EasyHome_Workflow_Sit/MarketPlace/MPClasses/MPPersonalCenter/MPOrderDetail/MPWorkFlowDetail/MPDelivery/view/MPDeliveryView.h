//
//  MPDeliveryView.h
//  MarketPlace
//
//  Created by Jiao on 16/3/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    MPDeliveryTypeForNone = 0,
    MPDeliveryTypeForMeasureSubmit,
    MPDeliveryTypeForDesignSubmit,
    MPDeliveryTypeForMeasureView,
    MPDeliveryTypeForDesignView
}MPDeliveryType;

@protocol MPDeliveryViewDelegate <NSObject>

@end

@interface MPDeliveryView : UIView

@property (nonatomic, weak) id<MPDeliveryViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andType:(MPDeliveryType)type;
- (void)refreshDeliveryView;
@end
