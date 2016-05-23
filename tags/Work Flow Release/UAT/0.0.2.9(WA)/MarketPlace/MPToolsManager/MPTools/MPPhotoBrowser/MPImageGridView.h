//
//  MPImageGridView.h
//  MarketPlace
//
//  Created by Arnav Jain on 08/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPImageGridDelegate <NSObject>

@optional
-(void)cellTappedAtIndex:(NSUInteger)index;

@end

@class MPPhotoBrowserCloudPhotosModel;
@class MPPhotoBrowserLocalPhotosModel;

@interface MPImageGridView : UIView

@property (nonatomic, weak) id<MPImageGridDelegate> delegate;

- (void)initCollectionViewWithCloudPhotos:(MPPhotoBrowserCloudPhotosModel *)model;
- (void)initCollectionViewWithLocalPhotos:(MPPhotoBrowserLocalPhotosModel *)model;
- (void)unloadViewsFromCollectionView;

@end
