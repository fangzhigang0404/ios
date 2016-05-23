//
//  MPPhotoAlbumUtility.h
//  MarketPlace
//
//  Created by Arnav Jain on 15/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPhotoAlbumModel.h"

@class MPCloudPhotoAlbumModel;
@class MPUserLibraryPhotoAlbumModel;

@interface MPPhotoAlbumUtility : NSObject

typedef void (^MPHomestylerPhotoAlbumCompletionBlock)(MPCloudPhotoAlbumModel *model);

+ (MPPhotoAlbumModel *)getDefaultAlbumModelForAlbumType:(MPPhotoAlbumType)albumType;
+ (NSArray *)getCloudAlbums;
+ (NSArray *)getLocalAlbums;
+ (void)fetchHomestylerCloudAlbumWithAssetID:(NSString *)assetID withCompletionBlock:(MPHomestylerPhotoAlbumCompletionBlock)completionBlock withFailureBlock:(void (^)(NSError *error))failureBlock;
+ (MPUserLibraryPhotoAlbumModel *)getCameraRoll;
+ (void)saveImageToCameraRoll:(NSURL *)imageURL;

@end
