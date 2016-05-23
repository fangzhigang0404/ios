/**
 * @file    MPHomeView.h
 * @brief   the view of controller.
 * @author  niu
 * @version 1.0
 * @date    2015-12-25
 */

#import <UIKit/UIKit.h>

@protocol MPHomeViewDelegate <NSObject>

/**
 *  @brief the method for get collectionView items count.
 *
 *  @param nil.
 *
 *  @return NSUInteger the count of items.
 */
- (NSUInteger) getNumberOfItemsInCollection;

/**
 *  @brief the method for click item.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void) didSelectedItemAtIndex:(NSUInteger)index;

/**
 *  @brief the method for refresh new dataSource.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)refreshLoadNewData:(void(^) ())finish;

/**
 *  @brief the method for refresh more dataSource.
 *
 *  @param finish the block for load over.
 *
 *  @return void nil.
 */
- (void)refreshLoadMoreData:(void(^) ())finish;

@end


@interface MPHomeView : UIView

/// delegate.
@property (weak, nonatomic)id <MPHomeViewDelegate> delegate;

/// collectionView.
@property (strong, nonatomic)UICollectionView *homeCollectionView;

/**
 *  @brief the method for refresh view.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)refreshHomeCaseView;

@end
