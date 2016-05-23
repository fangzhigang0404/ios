//
//  MPCloudPhotoAlbumCell.h
//  MarketPlace
//
//  Created by Arnav Jain on 09/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPCloudPhotoAlbumModel;

@interface MPCloudPhotoAlbumCell : UITableViewCell

@property (nonatomic, readonly) NSInteger index;

- (void)clearAllData;
- (void)setThumbnailForAlbumCell:(UIImage *)image;
- (void)updateAlbumCellForIndex:(NSUInteger)index withModel:(MPCloudPhotoAlbumModel *)model;
- (void)setAlbumCellSelected:(BOOL)selected;

@end
