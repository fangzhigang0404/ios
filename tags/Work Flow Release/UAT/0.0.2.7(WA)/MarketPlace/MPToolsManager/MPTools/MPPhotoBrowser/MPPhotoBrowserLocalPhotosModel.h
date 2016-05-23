//
//  MPPhotoBrowserLocalPhotosModel.h
//  MarketPlace
//
//  Created by Arnav Jain on 11/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPPhotoBrowserLocalPhotosModel : NSObject

@property (nonatomic, strong) NSArray<NSString *> *thumbnailPaths;

@property (nonatomic, strong) NSArray<NSString *> *imagePaths;

@end