/**
 * @file    MPSearchView.h
 * @brief   Search  the view.
 * @author  Xue.
 * @version 1.0.
 * @date    2015-12-15.
 */

#import <UIKit/UIKit.h>

@protocol MPSearchViewDelegate <NSObject>

@required

/**
 *  @brief the method for get case count.
 *
 *  @param nil.
 *
 *  @return NSInteger case count.
 */
- (NSUInteger) getNumberOfItemsInCollection;

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

@interface MPSearchView : UIView

@property (copy, nonatomic) NSMutableArray* hotKeywords;

/// delegate.
@property (weak, nonatomic) id<MPSearchViewDelegate> delegate;

/**
 *  @brief the method for refresh View.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) refreshFindDesignersUI;

/**
 *  @brief the method for remove keyboard.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)removeKeyBoardObserver;
@end
