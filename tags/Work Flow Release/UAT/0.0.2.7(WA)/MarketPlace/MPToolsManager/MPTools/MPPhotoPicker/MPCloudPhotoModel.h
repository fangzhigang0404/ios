//
//  MPCloudPhotoModel.h
//  MarketPlace
//
//  Created by Arnav Jain on 09/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPPhotoModel.h"

@interface MPCloudPhotoModel : MPPhotoModel

@property (nonatomic, strong) NSURL *linkToThumbnail;

@property (nonatomic, strong) NSURL *linkToFullImage;

@property (nonatomic, strong) NSString *fileID;

@property (nonatomic, strong) NSURL *cachedFile;

@end
