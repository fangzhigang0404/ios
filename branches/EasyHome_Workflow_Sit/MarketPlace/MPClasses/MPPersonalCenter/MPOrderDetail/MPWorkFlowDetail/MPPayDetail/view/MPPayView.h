//
//  MPPayView.h
//  MarketPlace
//
//  Created by Jiao on 16/3/5.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPpayTableViewCell.h"
#import "MPPayForMeasureCell.h"
//typedef enum : NSUInteger {
//    MPPayForNone = 0,
//    MPPayForMeasure,
//    MPPayForContractFirst,
//    MPPayForContractLast
//}MPPayType ;

@protocol MPPayViewDelegate <NSObject>


@end
@interface MPPayView : UIView

@property (nonatomic, assign) MPPayType type;
@property (nonatomic, weak) id<MPPayViewDelegate> delegate;

- (void)refreshPayView;
@end
