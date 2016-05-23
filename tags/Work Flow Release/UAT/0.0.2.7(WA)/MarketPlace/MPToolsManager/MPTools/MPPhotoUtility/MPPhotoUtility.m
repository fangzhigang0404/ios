//
//  MPPhotoUtility.m
//  MarketPlace
//
//  Created by Arnav Jain on 11/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

@import Photos;
#import "MPPhotoUtility.h"

@implementation MPPhotoUtility

static const CGFloat thumbnailDimension = 100.0f;

+ (id<SDWebImageOperation>)downloadThumbnailFromURL:(NSURL *)url withCompletionBlock:(SDWebImageCompletionWithFinishedBlock)completionBlock
{
    assert(url);

    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    return [manager downloadImageWithURL:url
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                {
                                    // progression tracking code
                                }
                               completed:completionBlock];
}

+ (id<SDWebImageOperation>)downloadFullImageFromURL:(NSURL *)url withCompletionBlock:(SDWebImageCompletionWithFinishedBlock)completionBlock
{
    assert(url);

    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    return [manager downloadImageWithURL:url
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                {
                                    // progression tracking code
                                }
                               completed:completionBlock];
}

+ (void)fetchThumbnailImageFromAsset:(PHAsset *)asset withCompletionBlock:(MPImageFromPHAssetCompletionBlock)completionBlock
{
    assert(asset);

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;

    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat dimension = thumbnailDimension;
    CGSize size = CGSizeMake(dimension*scale, dimension*scale);

    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:size
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:completionBlock];
}

+ (void)fetchCachedThumbnailImageFromAsset:(PHAsset *)asset
                       withCompletionBlock:(MPImageFromPHAssetCompletionBlock)completionBlock
                                 dimension:(CGFloat)dimension
                              cacheManager:(PHCachingImageManager *)manager
{
    assert(manager);
    assert(asset);
    assert(dimension > 0);

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;

    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(dimension*scale, dimension*scale);

    [manager requestImageForAsset:asset
                       targetSize:size
                      contentMode:PHImageContentModeAspectFit
                          options:options
                    resultHandler:completionBlock];
}

+ (void)fetchImageFromAsset:(PHAsset *)asset withCompletionBlock:(MPImageFromPHAssetCompletionBlock)completionBlock
{
    assert(asset);

    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeNone;

    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:PHImageManagerMaximumSize
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:completionBlock];
}

+ (void)fetchImageFromAssetForEditing:(PHAsset *)asset withCompletionBlock:(MPImageEditingFromPHAssetCompletionBlock)completionBlock
{
    assert(asset);

    PHContentEditingInputRequestOptions *options = [[PHContentEditingInputRequestOptions alloc] init];
    [asset requestContentEditingInputWithOptions:options completionHandler:completionBlock];
}

@end
