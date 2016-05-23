/**
 * @file    MPMyMarkListView.h
 * @brief   the view for bidding list view.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-17
 */

#import <UIKit/UIKit.h>
@protocol MPMyMarkViewDelegate <NSObject>

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
- (NSInteger)getDesignerCellCount;

/**
 *  @brief the method for select type.
 *
 *  @param type.
 *
 *  @return NSInteger needs count.
 */
- (void)selectTypeAtString:(NSString *)type;

/**
 *  @brief the method for load new data.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)findDesignersViewRefreshLoadNewData:(void(^) ())finish;

/**
 *  @brief the method for load more data.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)findDesignersViewRefreshLoadMoreData:(void(^) ())finish;

@end

@interface MPMyMarkListView : UIView

/// delegate.
@property (weak, nonatomic)id<MPMyMarkViewDelegate>delegate;

/**
 *  @brief the method for refresh View.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) refreshFindDesignersUI;
@end
