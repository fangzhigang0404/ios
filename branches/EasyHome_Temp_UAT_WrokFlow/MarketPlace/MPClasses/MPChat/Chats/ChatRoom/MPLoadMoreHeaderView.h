
/**
 * @file    MPLoadMoreHeaderView.h
 * @brief   load more header view.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

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
