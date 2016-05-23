/**
 * @file    MPBiddingHallView.h.
 * @brief   the view for bidding hall.
 * @author  Xue.
 * @version 1.0.
 * @date    2016-02-24.
 */

#import <UIKit/UIKit.h>
@protocol MPBiddingViewDelegate <NSObject>

@required

/**
 *  @brief the method for click cell.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)didSelectItemAtIndex:(NSInteger)index;

/**
 *  @brief the method for get needs count.
 *
 *  @param nil.
 *
 *  @return NSInteger needs count.
 */
- (NSInteger)getBiddingCellCount;

/**
 *  @brief the method for load new data.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)biddingViewRefreshLoadNewData:(void(^) ())finish;

/**
 *  @brief the method for load more data.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)biddingViewRefreshLoadMoreData:(void(^) ())finish;
@end

@interface MPBiddingHallView : UIView<UITableViewDataSource,UITableViewDelegate>

/// delegate.
@property (weak, nonatomic)id<MPBiddingViewDelegate>delegate;

/**
 *  @brief the method for refresh View.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) refreshBiddingViewUI;
@end
