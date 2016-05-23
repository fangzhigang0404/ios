/**
 * @file    MPDecoListView.h
 * @brief   the view for cell.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import <UIKit/UIKit.h>

@protocol MPDecoListViewDelegate <NSObject>

/**
 *  @brief the method for judge is not beishu.
 *
 *  @param index the index for model in datasource.
 *
 *  @return bool is beishu or not.
 */
- (BOOL)isBeishu:(NSInteger)index;

/**
 *  @brief the method for judge is not beishu.
 *
 *  @param nil.
 *
 *  @return NSInteger collectiobView items.
 */
- (NSInteger)getDecoListCount;

/**
 *  @brief the method for scroll begin.
 *
 *  @param x num of scroll begin.
 *
 *  @return void nil.
 */
- (void)draggingWithContentOffsetX:(NSInteger)x;

/**
 *  @brief the method for scroll over.
 *
 *  @param x num of scroll over.
 *
 *  @return void nil.
 */
- (void)deceleratingWithContentOffsetX:(NSInteger)x;

@end

@interface MPDecoListView : UIView

/// delegate.
@property (weak, nonatomic)id<MPDecoListViewDelegate>delegate;

/**
 *  @brief the method for refresh View.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)refreshDecoListUI;

@end
