//
//  MPPhotoSourceModel.h
//  MarketPlace
//
//  Created by Arnav Jain on 04/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    MPPhotoAlbumTypeUserLibrary = 0,
    MPPhotoAlbumTypeCloud
} MPPhotoAlbumType;


@interface MPPhotoAlbumModel : NSObject

/*!
 * @discussion Name of this photo source - Camera Roll, Cloud Storage, etc.
 */
@property (nonatomic, strong) NSString *name;

/*!
 * @discussion Whether the photo source is local (offline) or cloud (online)
 */
@property (nonatomic) MPPhotoAlbumType albumType;

@end
