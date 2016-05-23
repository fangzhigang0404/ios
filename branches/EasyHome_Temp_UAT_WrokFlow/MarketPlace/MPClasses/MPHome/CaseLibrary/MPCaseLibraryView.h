/**
 * @file    MPConsumerCaseView.h
 * @brief   the frame of MPConsumerCaseView.
 * @author  Xue
 * @version 1.0
 * @date    2015-12-10
 */

#import <UIKit/UIKit.h>

@protocol MPCaseViewDelegate <NSObject>
@required

/**
 *  @brief the method for get case count.
 *
 *  @param nil.
 *
 *  @return NSInteger case count.
 */
- (NSUInteger) getCaseCellCount;

/**
 *  @brief the method for click cell.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void) didSelectedItemAtIndex:(NSUInteger)index;

/**
 *  @brief the method for load new data.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)refreshLoadNewData:(void(^) ())finish;

/**
 *  @brief the method for load more data.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)refreshLoadMoreData:(void(^) ())finish;
@end

@interface MPCaseLibraryView : UIView<UITableViewDataSource,UITableViewDelegate>

/// delegate.
@property (weak, nonatomic)id<MPCaseViewDelegate>delegate;

//@property (strong,nonatomic)UITableView *;
@property (strong,nonatomic)NSMutableArray *caseArray;

/**
 *  @brief the method for refresh View.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)refreshCasesLibraryUI;
@end
