//
//  LoadMoreHeaderView.h
//  MarketPlace
//
//  Created by Avinash Mishra on 16/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MPLoadMoreHeaderViewDelegate <NSObject>
/**
 *  @brief load more data.
 *
 *  @return void nil.
 */
- (void) loadMoreData;

@end


@interface MPLoadMoreHeaderView : UIView


@property (nonatomic, weak) id <MPLoadMoreHeaderViewDelegate>     delegate;
/**
 *  @brief the method as UIActivityIndicator start.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) startIndicator;

/**
 *  @brief the method as UIActivityIndicator stop.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) stopIndicator;

@end
