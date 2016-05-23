//
//  MPPhotoTakerViewController.h
//  MarketPlace
//
//  Created by Arnav Jain on 16/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPPhotoTakerDelegate <NSObject>

@required
- (void)userDidCancelPhotoTaking;
- (void)userDidTakePhotoWithURL:(NSURL *)localURL;
- (void)userDeniedCameraAccess;
- (void)userDoesNotHaveUsableCamera;

@end

@interface MPPhotoTakerViewController : UIViewController

@property (nonatomic, weak) id<MPPhotoTakerDelegate> delegate;

@end
