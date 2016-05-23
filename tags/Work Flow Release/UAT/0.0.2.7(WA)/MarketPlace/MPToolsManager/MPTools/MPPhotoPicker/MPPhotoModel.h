//
//  MPPhotoModel.h
//  MarketPlace
//
//  Created by Arnav Jain on 04/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPhotoAlbumModel.h"

@interface MPPhotoModel : NSObject

/*!
 * @discussion Whether the photo's source is local (offline) or cloud (online)
 */
@property (nonatomic) MPPhotoAlbumType sourceType;

@end
