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

/**
 *  @brief the method for search keywords.
 *
 *  @param searchKey the textField of connect.
 *
 *  @return void nil.
 */
-(void)onSearchTrigerred:(NSString*) searchKey;

/**
 *  @brief the method for close search view.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
-(void)onSearchViewDismiss;

/**
 *  @brief the method for search keywords.
 *
 *  @param typeString the select value.
 *  @param titleString the select type title.
 *  @return void nil.
 */
- (void)stringSelectType:(NSString *)typeString withTitleString:(NSString *)titleString;
@end

@interface MPSearchBiddingView : UIView

@property (copy, nonatomic) NSMutableArray* hotKeywords;

/// delegate.
@property (weak, nonatomic) id<MPSearchBiddingViewDelegate> delegate;

/**
 *  @brief the method for refresh View.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) refreshBiddingViewUI;

/**
 *  @brief the method for remove keyboard.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)removeKeyBoardObserver;
@end
