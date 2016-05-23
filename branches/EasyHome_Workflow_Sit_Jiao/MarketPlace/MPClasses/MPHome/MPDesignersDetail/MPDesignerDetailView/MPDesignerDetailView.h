/**
 * @file    MPDesignerDetailView.h
 * @brief   the view of controller.
 * @author  niu
 * @version 1.0
 * @date    2015-01-26
 */

#import <UIKit/UIKit.h>

@protocol MPDesignerDetailViewDelegate <NSObject>

/**
 *  @brief the method for click cell.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)didSelectCellAtIndex:(NSInteger)index;

/**
 *  @brief the method for get case count.
 *
 *  @param nil.
 *
 *  @return NSInteger case count.
 */
- (NSInteger)getDesignerDetailCaseCount;

/**
 *  @brief the method for load new data.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)designerDetailViewRefreshLoadNewData:(void(^) ())finish;

/**
 *  @brief the method for load more data.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)designerDetailViewRefreshLoadMoreData:(void(^) ())finish;

@end

@interface MPDesignerDetailView : UIView

/// delegate.
@property (nonatomic, assign) id<MPDesignerDetailViewDelegate>delegate;

/// is designer or not.
@property (nonatomic, assign) BOOL isDesigner;

/**
 *  @brief the method for refresh View.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)refreshDesignerDetailUI;

@end
