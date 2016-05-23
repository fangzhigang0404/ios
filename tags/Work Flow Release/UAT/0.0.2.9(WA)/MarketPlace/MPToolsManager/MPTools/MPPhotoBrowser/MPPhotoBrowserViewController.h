//
//  MPPhotoBrowserViewController.h
//  MarketPlace
//
//  Created by Arnav Jain on 08/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPhotoBrowserCloudPhotosModel.h"
#import "MPPhotoBrowserLocalPhotosModel.h"

@interface MPPhotoBrowserViewController : UIViewController

- (instancetype)initWithCloudImages:(MPPhotoBrowserCloudPhotosModel *)model;
- (instancetype)initWithLocalImages:(MPPhotoBrowserLocalPhotosModel *)model;

@end
