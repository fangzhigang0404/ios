//
//  MPPhotoSourceCell.h
//  MarketPlace
//
//  Created by Arnav Jain on 04/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPUserLibraryPhotoAlbumModel;

@interface MPUserLibraryPhotoAlbumCell : UITableViewCell

@property (nonatomic, readonly) NSInteger index;

- (void)clearAllData;
- (void)setThumbnailForAlbumCell:(UIImage *)image;
- (void)updateAlbumCellForIndex:(NSUInteger)index withModel:(MPUserLibraryPhotoAlbumModel *)model;
- (void)setAlbumCellSelected:(BOOL)selected;

@end
