//
//  MPSearchBiddingView.h
//  MarketPlace
//
//  Created by xuezy on 16/2/25.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MPSearchBiddingViewDelegate <NSObject>

@required
- (void)didSelectItemAtIndex:(NSInteger)index;
- (NSInteger)getBiddingCellCount;

- (void)biddingViewRefreshLoadNewData:(void(^) ())finish;

- (void)biddingViewRefreshLoadMoreData:(void(^) ())finish;
-(void)onSearchTrigerred:(NSString*) searchKey;
-(void)onSearchViewDismiss;
- (void)stringSelectType:(NSString *)typeString withTitleString:(NSString *)titleString;
@end

@interface MPSearchBiddingView : UIView
@property (copy, nonatomic) NSMutableArray* hotKeywords;
@property (weak, nonatomic) id<MPSearchBiddingViewDelegate> delegate;
- (void) refreshBiddingViewUI;
- (void)removeKeyBoardObserver;
@end
