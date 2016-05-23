//
//  MPPhotoPickerViewController.h
//  MarketPlace
//
//  Created by Arnav Jain on 03/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"
#import "MPPhotoAlbumModel.h"

@protocol MPPhotoPickerDelegate <NSObject>

@required
- (void)userDidSelectPhotoWithURL:(NSURL *)photoURL;
- (void)userDeniedPhotoLibraryAccess;

@end

@interface MPPhotoPickerViewController : MPBaseViewController

@property (nonatomic, weak) id<MPPhotoPickerDelegate> delegate;
- (instancetype)initWithDefaultAlbumType:(MPPhotoAlbumType)defaultAlbumType withAssetID:(NSString *)assetID;

@end
