//
//  MPPhotoAlbumUtility.m
//  MarketPlace
//
//  Created by Arnav Jain on 15/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

@import Photos;
#import "MPPhotoAlbumUtility.h"
#import "MPCloudPhotoAlbumModel.h"
#import "MPUserLibraryPhotoAlbumModel.h"
#import "MPAPI.h"
#import "MPChatHomeStylerCloudfile.h"
#import "MPFileUtility.h"

@implementation MPPhotoAlbumUtility

+ (MPPhotoAlbumModel *)getDefaultAlbumModelForAlbumType:(MPPhotoAlbumType)albumType
{
    if (albumType == MPPhotoAlbumTypeCloud)
    {
        NSArray *cloudModelArray = [MPPhotoAlbumUtility getCloudAlbums];
        MPCloudPhotoAlbumModel *cloudModel = [cloudModelArray firstObject];

        return cloudModel;
    }
    else if (albumType == MPPhotoAlbumTypeUserLibrary)
    {
        MPUserLibraryPhotoAlbumModel *userLibraryModel = [MPPhotoAlbumUtility getCameraRoll];

        return userLibraryModel;
    }
    else
    {
        NSLog(@"Please give a proper album type to get the default model");
        return nil;
    }
}

+ (NSArray *)getCloudAlbums
{
    NSMutableArray *sourceModels = [[NSMutableArray alloc] init];

    MPCloudPhotoAlbumModel *model = [[MPCloudPhotoAlbumModel alloc] init];

    model.name = NSLocalizedString(@"album_picker_cloud_storage_label", nil);
    model.albumType = MPPhotoAlbumTypeCloud;
    model.thumbnailID = [MPPhotoAlbumUtility getCloudStorageThumbnailIdentifier];
    model.thumbnailURL = [MPPhotoAlbumUtility getCloudStorageThumbnailURLFromIdentifier:model.thumbnailID];

    [sourceModels addObject:model];

    return sourceModels;
}

+ (void)fetchHomestylerCloudAlbumWithAssetID:(NSString *)assetID withCompletionBlock:(MPHomestylerPhotoAlbumCompletionBlock)completionBlock withFailureBlock:(void (^)(NSError *error))failureBlock
{
    [MPAPI getCloudFilesForNeedId:assetID
                                            success:^(MPChatHomeStylerCloudfiles *dict)
     {
         MPCloudPhotoAlbumModel *model = [[MPCloudPhotoAlbumModel alloc] init];

         model.name = NSLocalizedString(@"album_picker_cloud_storage_label", nil);
         model.albumType = MPPhotoAlbumTypeCloud;

         NSArray *cloudFiles = dict.files;
         NSMutableArray<MPChatHomeStylerCloudfile *> *files = [[NSMutableArray alloc] init];

         for (MPChatHomeStylerCloudfile *file in cloudFiles)
         {
             file.thumbnail = [file.thumbnail stringByAppendingString:@"Medium.jpg"];
             [files addObject:file];
         }

         model.cloudFiles = files;

         model.thumbnailURL = [NSURL URLWithString:[files lastObject].thumbnail];
         model.thumbnailID = [[files lastObject].uid stringValue];

         completionBlock(model);
     }
                                            failure:failureBlock];
}

+ (NSString *)getCloudStorageThumbnailIdentifier
{
    // TODO: Call an API here to get the thumbnail for the folder
    NSString *thumbnailID = @"FICDDemoImage001";

    return thumbnailID;
}

+ (NSURL *)getCloudStorageThumbnailURLFromIdentifier:(NSString *)identifier
{
    // TODO: Call an API here to get the actual URL
    NSString *urlString = @"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage001.jpg";
    return [NSURL URLWithString:urlString];
}

+ (NSArray *)getLocalAlbums
{
    PHFetchOptions *smartAlbumsOptions = [[PHFetchOptions alloc] init];
    smartAlbumsOptions.includeHiddenAssets = NO;
    smartAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:YES]];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:smartAlbumsOptions];

    // Get the user's not-so-smart albums
    PHFetchOptions *userAlbumOptions = [[PHFetchOptions alloc] init];
    userAlbumOptions.predicate = [NSPredicate predicateWithFormat:@"estimatedAssetCount > 0"];
    userAlbumOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:YES]];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAny options:userAlbumOptions];

    NSArray *fetchResultsArray = @[smartAlbums, userAlbums];

    return [MPPhotoAlbumUtility getPhotoSourceModelsFromFetchResults:fetchResultsArray];
}

+ (NSArray *)getPhotoSourceModelsFromFetchResults:(NSArray *)resultArray
{
    NSMutableArray *sourceModels = [[NSMutableArray alloc] init];

    for (PHFetchResult *fetchResult in resultArray)
    {
        for (PHAssetCollection *assetCollection in fetchResult)
        {
            PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
            fetchOptions.includeHiddenAssets = NO;
            fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
            PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];

            MPUserLibraryPhotoAlbumModel *model = [[MPUserLibraryPhotoAlbumModel alloc] init];
            model.numberOfPhotos = assets.count;

            // Don't add this asset collection to our array
            // because it does not have any assets
            //if (model.numberOfPhotos == 0)
                //continue;

            model.name = assetCollection.localizedTitle;
            model.albumType = MPPhotoAlbumTypeUserLibrary;

            model.assetCollection = assetCollection;

            // We set the thumbnail source as the first object in the array
            // since we are sorting newer to older
            PHAsset *asset = [assets firstObject];
            model.thumbnailAsset = asset;

            [sourceModels addObject:model];
        }
    }

    return sourceModels;
}

+ (MPUserLibraryPhotoAlbumModel *)getCameraRoll
{
    PHFetchOptions *smartAlbumsOptions = [[PHFetchOptions alloc] init];
    smartAlbumsOptions.includeHiddenAssets = NO;
    smartAlbumsOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"localizedTitle" ascending:YES]];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:smartAlbumsOptions];

    NSArray *fetchResultsArray = @[smartAlbums];

    NSArray *albumModels = [MPPhotoAlbumUtility getPhotoSourceModelsFromFetchResults:fetchResultsArray];

    return [albumModels firstObject];
}

+ (void)saveImageToCameraRoll:(NSURL *)imageURL
{
    assert(imageURL);
    assert([MPFileUtility isFileExist:imageURL.path]);

    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^
    {
        // Make a change request for adding an asset.
        UIImage *image = [UIImage imageWithContentsOfFile:imageURL.path];
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    }
    completionHandler:^(BOOL success, NSError *error)
    {
        if(success)
            NSLog(@"Successfully added image to the camera roll");
        else
            NSLog(@"Error while saving image to the camera roll: %@", error.description);
    }];
}

@end
