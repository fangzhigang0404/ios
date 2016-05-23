//
//  MPMeasureDetailCell.h
//  MarketPlace
//
//  Created by Jiao on 16/2/25.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPStatusDetail,MPStatusModel;
@protocol MPMeasureDetailCellDelegate <NSObject>

- (MPStatusModel *)updateCellData;
- (MPStatusDetail *)updateCellUI;
- (void)payForMeasure;
- (void)confirmMeasure;
- (void)refuseMeasure;

@end
@interface MPMeasureDetailCell : UITableViewCell
@property (nonatomic, weak) id<MPMeasureDetailCellDelegate> delegate;

- (void)updateDetailCellForIndex:(NSInteger)index;
@end
