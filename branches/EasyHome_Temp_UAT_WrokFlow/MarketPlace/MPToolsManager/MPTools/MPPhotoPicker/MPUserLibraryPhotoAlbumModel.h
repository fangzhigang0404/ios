//
//  MPUserLibraryPhotoAlbumModel.h
//  MarketPlace
//
//  Created by Arnav Jain on 09/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPPhotoAlbumModel.h"

@class PHAsset;
@class PHAssetCollection;

@interface MPUserLibraryPhotoAlbumModel : MPPhotoAlbumModel

/*!
 * @discussion Asset which makes up the thumbnail
 */
@property (nonatomic, strong) PHAsset *thumbnailAsset;

/*!
 * @discussion Collection of all photo assets
 */
@property (nonatomic, strong) PHAssetCollection *assetCollection;

@property (nonatomic) NSUInteger numberOfPhotos;

@property (nonatomic, strong) NSURL *cachedFile;

@end