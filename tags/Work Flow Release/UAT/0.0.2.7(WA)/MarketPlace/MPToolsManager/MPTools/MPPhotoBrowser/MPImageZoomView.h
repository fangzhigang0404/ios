//
//  MPImageZoomView.h
//  MarketPlace
//
//  Created by Arnav Jain on 08/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPPhotoBrowserCloudPhotosModel;
@class MPPhotoBrowserLocalPhotosModel;

@interface MPImageZoomView : UIView

- (void)initScrollViewWithCloudPhotos:(MPPhotoBrowserCloudPhotosModel *)model;
- (void)initScrollViewWithCloudPhotos:(MPPhotoBrowserCloudPhotosModel *)model gotoPage:(NSUInteger)page;
- (void)initScrollViewWithLocalPhotos:(MPPhotoBrowserLocalPhotosModel *)model;
- (void)initScrollViewWithLocalPhotos:(MPPhotoBrowserLocalPhotosModel *)model gotoPage:(NSUInteger)page;
- (void)unloadViewsFromScrollView;

@end
