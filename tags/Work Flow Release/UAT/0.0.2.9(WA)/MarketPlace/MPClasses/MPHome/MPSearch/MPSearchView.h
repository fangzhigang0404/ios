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
- (NSUInteger) getNumberOfItemsInCollection;
- (void) didSelectedItemAtIndex:(NSUInteger)index;
- (void)refreshLoadNewData:(void(^) ())finish;
- (void)refreshLoadMoreData:(void(^) ())finish;
-(void)onSearchTrigerred:(NSString*) searchKey;
-(void)onSearchViewDismiss;
- (void)stringSelectType:(NSString *)typeString withTitleString:(NSString *)titleString;


@end


@interface MPSearchView : UIView

@property (copy, nonatomic) NSMutableArray* hotKeywords;
@property (weak, nonatomic) id<MPSearchViewDelegate> delegate;
- (void) refreshFindDesignersUI;
- (void)removeKeyBoardObserver;
@end
