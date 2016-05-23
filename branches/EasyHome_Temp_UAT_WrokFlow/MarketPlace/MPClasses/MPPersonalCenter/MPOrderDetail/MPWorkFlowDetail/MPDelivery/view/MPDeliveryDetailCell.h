//
//  MPDeliveryDetailCell.h
//  MarketPlace
//
//  Created by Jiao on 16/3/24.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MP3DPlanModel.h"

typedef enum : NSInteger {
    DeTypeForNone = 0,
    DeTypeForMy3D,
    DeTypeForRender,
    DeTypeForDesign,
    DeTypeForMaterial,
    DeTypeForMeasure
}MPDeliveryDetailType;

@protocol MPDeliveryDetailCellDelegate <NSObject>

- (void)getDataFromIndex:(NSInteger)index withBlock:(void(^)(MPDeliveryDetailType type, id model, BOOL isSelected))block;

- (void)selectItemIndex:(NSInteger)index withSelected:(BOOL)selected;

- (void)tapDeliveryImgViewForIndex:(NSInteger)index;

@end

@interface MPDeliveryDetailCell : UICollectionViewCell
@property (nonatomic, weak) id<MPDeliveryDetailCellDelegate> delegate;
- (void)updateCellForIndex:(NSInteger)index withcType:(NSInteger)cType;
@end
