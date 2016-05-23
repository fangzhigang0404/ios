//
//  MPPhotoAlbumPickerViewController.h
//  MarketPlace
//
//  Created by Arnav Jain on 09/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPPhotoAlbumModel.h"

@protocol MPPhotoAlbumPickerDelegate <NSObject>

@optional
- (void)photoSourceChangedTo:(MPPhotoAlbumModel *)model;

@end

@interface MPPhotoAlbumPickerViewController : UIViewController

@property (nonatomic, weak) id<MPPhotoAlbumPickerDelegate> delegate;

- (instancetype)initWithCurrentAlbum:(MPPhotoAlbumModel *)model withAssetID:(NSString *)assetID;

@end
