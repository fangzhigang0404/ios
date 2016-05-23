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
- (void)didSelectItemAtIndex:(NSInteger)index;
- (NSInteger)getDesignerCellCount;
- (void)selectTypeAtString:(NSString *)type;
- (void)findDesignersViewRefreshLoadNewData:(void(^) ())finish;

- (void)findDesignersViewRefreshLoadMoreData:(void(^) ())finish;

@end

@interface MPMyMarkListView : UIView
@property (weak, nonatomic)id<MPMyMarkViewDelegate>delegate;

- (void) refreshFindDesignersUI;
@end
