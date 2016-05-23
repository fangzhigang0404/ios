//
//  MPImageCell.h
//  MarketPlace
//
//  Created by Arnav Jain on 08/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MPImageCellDelegate <NSObject>

@required

- (void)imageCellTappedAtIndex:(NSUInteger)index;

@end

@interface MPImageCell : UICollectionViewCell

@property (nonatomic, weak) id<MPImageCellDelegate> delegate;
@property (nonatomic, readonly) NSInteger index;

- (void)updateImageCellForIndex:(NSUInteger)index;
- (void)updateImageCellWithImage:(UIImage *)image;
- (void)clearAllData;

@end
