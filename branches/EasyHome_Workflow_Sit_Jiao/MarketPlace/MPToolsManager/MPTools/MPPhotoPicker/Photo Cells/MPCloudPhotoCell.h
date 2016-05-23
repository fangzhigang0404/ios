//
//  MPCloudPhotoCell.h
//  MarketPlace
//
//  Created by Arnav Jain on 10/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPCloudPhotoCellDelegate <NSObject>

@optional
- (void)cloudCellTappedAtIndex:(NSUInteger)index isSelected:(BOOL)selected;

@end

@interface MPCloudPhotoCell : UICollectionViewCell

@property (nonatomic, weak) id<MPCloudPhotoCellDelegate> delegate;
@property (nonatomic, readonly) NSInteger index;

- (void)clearAllData;
- (void)setPhotoCellSelected:(BOOL)selected;
- (void)setThumbnailForPhotoCell:(UIImage *)image;
- (void)updatePhotoCellForIndex:(NSUInteger)index;

@end
