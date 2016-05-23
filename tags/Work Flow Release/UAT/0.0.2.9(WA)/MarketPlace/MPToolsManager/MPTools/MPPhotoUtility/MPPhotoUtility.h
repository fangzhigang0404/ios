//
//  MPPhotoUtility.h
//  MarketPlace
//
//  Created by Arnav Jain on 11/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImage/UIImageView+WebCache.h>

@class PHAsset;
@class PHContentEditingInput;
@class PHCachingImageManager;

@interface MPPhotoUtility : NSObject

typedef void (^MPImageFromPHAssetCompletionBlock)(UIImage *result, NSDictionary *info);
typedef void (^MPImageEditingFromPHAssetCompletionBlock)(PHContentEditingInput *contentEditingInput, NSDictionary *info);

+ (id<SDWebImageOperation>)downloadThumbnailFromURL:(NSURL *)url
                                withCompletionBlock:(SDWebImageCompletionWithFinishedBlock)block;

+ (id<SDWebImageOperation>)downloadFullImageFromURL:(NSURL *)url
                                withCompletionBlock:(SDWebImageCompletionWithFinishedBlock)completionBlock;

+ (void)fetchThumbnailImageFromAsset:(PHAsset *)asset
                 withCompletionBlock:(MPImageFromPHAssetCompletionBlock)completionBlock;

+ (void)fetchCachedThumbnailImageFromAsset:(PHAsset *)asset
                       withCompletionBlock:(MPImageFromPHAssetCompletionBlock)completionBlock
                                 dimension:(CGFloat)dimension
                              cacheManager:(PHCachingImageManager *)manager;

+ (void)fetchImageFromAsset:(PHAsset *)asset
        withCompletionBlock:(MPImageFromPHAssetCompletionBlock)completionBlock;

+ (void)fetchImageFromAssetForEditing:(PHAsset *)asset
                  withCompletionBlock:(MPImageEditingFromPHAssetCompletionBlock)completionBlock;

@end
