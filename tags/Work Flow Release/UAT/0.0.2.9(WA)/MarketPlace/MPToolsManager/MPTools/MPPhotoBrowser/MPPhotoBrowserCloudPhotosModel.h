//
//  MPPhotoBrowserCloudPhotosModel.h
//  MarketPlace
//
//  Created by Arnav Jain on 11/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPPhotoBrowserCloudPhotosModel : NSObject

@property (nonatomic, strong) NSArray<NSURL *> *thumbnailURLArray;

@property (nonatomic, strong) NSArray<NSURL *> *imageURLArray;

@end