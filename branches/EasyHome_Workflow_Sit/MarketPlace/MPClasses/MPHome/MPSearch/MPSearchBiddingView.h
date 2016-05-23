/**
 * @file    MPSearchBiddingView.h
 * @brief   the view for search bidding view.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-25
 */

#import <UIKit/UIKit.h>
@protocol MPSearchBiddingViewDelegate <NSObject>

@required

- (void)didSelectItemAtIndex:(NSInteger)index;
- (NSInteger)getBiddingCellCount;

- (void)biddingViewRefreshLoadNewData:(void(^) ())finish;

- (void)biddingViewRefreshLoadMoreData:(void(^) ())finish;
-(void)onSearchTrigerred:(NSString*) searchKey;
-(void)onSearchViewDismiss;
- (void)stringSelectType:(NSString *)typeString withTitleString:(NSString *)titleString;
@end

@interface MPSearchBiddingView : UIView
@property (copy, nonatomic) NSMutableArray* hotKeywords;
@property (weak, nonatomic) id<MPSearchBiddingViewDelegate> delegate;

- (void) refreshBiddingViewUI;
- (void)removeKeyBoardObserver;
@end
