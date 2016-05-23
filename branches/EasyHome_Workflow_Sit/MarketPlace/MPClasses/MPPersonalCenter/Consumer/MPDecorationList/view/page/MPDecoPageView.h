//
//  MPDecoPageView.h
//  MarketPlace
//
//  Created by WP on 16/3/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPDecoPageView : UIView

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for current model index.
 *
 *  @return void nil.
 */
- (void)updatePageViewWithIndex:(NSInteger)index;

/**
 *  @brief the method for set count for page view.
 *
 *  @param count the count for page view.
 *
 *  @return void nil.
 */
- (void)setPageNumWithCount:(NSInteger)count;

@end
