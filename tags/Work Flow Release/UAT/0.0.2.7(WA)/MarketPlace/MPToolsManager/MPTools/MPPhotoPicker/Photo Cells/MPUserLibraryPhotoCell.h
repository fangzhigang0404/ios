//
//  MPUserLibraryPhotoCell.h
//  MarketPlace
//
//  Created by Arnav Jain on 10/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPUserLibraryPhotoCellDelegate <NSObject>

@optional
- (void)userLibraryCellTappedAtIndex:(NSUInteger)index isSelected:(BOOL)selected;

@end

@interface MPUserLibraryPhotoCell : UICollectionViewCell

@property (nonatomic, weak) id<MPUserLibraryPhotoCellDelegate> delegate;
@property (nonatomic, readonly) NSInteger index;

- (void)clearAllData;
- (void)setPhotoCellSelected:(BOOL)selected;
- (void)setThumbnailForPhotoCell:(UIImage *)image;
- (void)updatePhotoCellForIndex:(NSUInteger)index;

@end
