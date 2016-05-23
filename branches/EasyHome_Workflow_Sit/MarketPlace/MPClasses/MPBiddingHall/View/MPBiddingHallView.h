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
- (void)didSelectItemAtIndex:(NSInteger)index;
- (NSInteger)getBiddingCellCount;

- (void)biddingViewRefreshLoadNewData:(void(^) ())finish;

- (void)biddingViewRefreshLoadMoreData:(void(^) ())finish;
@end

@interface MPBiddingHallView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic)id<MPBiddingViewDelegate>delegate;

- (void) refreshBiddingViewUI;
@end
