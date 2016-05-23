//
//  MPUserLibraryPhotoModel.h
//  MarketPlace
//
//  Created by Arnav Jain on 09/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPPhotoModel.h"

@class PHAsset;
@interface MPUserLibraryPhotoModel : MPPhotoModel

/*!
 * @discussion This asset can serve up the full image as well as its thumbnail.
 */
@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) NSURL *cachedFile;

@end