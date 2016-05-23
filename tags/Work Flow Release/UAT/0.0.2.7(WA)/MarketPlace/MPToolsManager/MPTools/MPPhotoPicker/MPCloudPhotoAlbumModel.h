//
//  MPCloudPhotoAlbumModel.h
//  MarketPlace
//
//  Created by Arnav Jain on 09/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPPhotoAlbumModel.h"
#import "MPChatHomeStylerCloudfile.h"

@interface MPCloudPhotoAlbumModel : MPPhotoAlbumModel

/*!
 * @discussion File ID for the thumbnail image
 */
@property (nonatomic, strong) NSString *thumbnailID;

@property (nonatomic, strong) NSURL *thumbnailURL;

@property (nonatomic, strong) NSArray<MPChatHomeStylerCloudfile *> *cloudFiles;

@property (nonatomic, strong) NSURL *cachedFile;

@end
