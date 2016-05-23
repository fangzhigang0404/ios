//
//  MPImageSetCell.h
//  MarketPlace
//
//  Created by Arnav Jain on 01/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPImageSetCellDelegate <NSObject>

@required

- (void)imageTappedAtIndex:(NSUInteger)index isSelected:(BOOL)selected;
- (BOOL)isSelectionAllowed;

@optional
- (UIImage *)getImageForIndex:(NSUInteger)index;

@end

@interface MPImageSetCell : UICollectionViewCell

@property (nonatomic, weak) id<MPImageSetCellDelegate> delegate;
@property (nonatomic) NSInteger index;

// This is important when asynchronously setting the image of a cell
@property (nonatomic, strong) NSURL *thumbnailURL; 

- (void)updateImageCellForIndex:(NSUInteger)index;
- (void)setImage:(UIImage *)image;
- (void)clearAllData;
- (void)setSelected:(BOOL)selected;

@end
