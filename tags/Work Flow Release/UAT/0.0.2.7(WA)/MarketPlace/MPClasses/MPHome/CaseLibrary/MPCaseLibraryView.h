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

- (NSUInteger) getCaseCellCount;
- (void) didSelectedItemAtIndex:(NSUInteger)index;

- (void)refreshLoadNewData:(void(^) ())finish;
- (void)refreshLoadMoreData:(void(^) ())finish;
@end

@interface MPCaseLibraryView : UIView<UITableViewDataSource,UITableViewDelegate>

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
