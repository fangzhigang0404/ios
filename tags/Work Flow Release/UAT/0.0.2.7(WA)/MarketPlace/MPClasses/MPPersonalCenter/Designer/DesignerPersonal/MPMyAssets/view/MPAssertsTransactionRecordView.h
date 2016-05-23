//
//  MPAssertsTransactionRecordView.h
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MPPayForNones = 0,
    MPAssetsRecordForTrades,
    MPAssetsRecordForWithdraws
}MPAssetsRecordTypes ;

@protocol MPAssertsRecordViewDelegate <NSObject>

@required
- (void)didSelectItemAtIndex:(NSInteger)index;
- (NSInteger)getRecordCellCount;

- (void)assertsViewRefreshLoadNewData:(void(^) ())finish;

- (void)assertsViewRefreshLoadMoreData:(void(^) ())finish;

@end

@interface MPAssertsTransactionRecordView : UIView
@property (weak, nonatomic)id<MPAssertsRecordViewDelegate>delegate;
- (instancetype)initWithIsWithdraw:(BOOL)isWithdraw withFrame:(CGRect)frame;
- (void) refreshRecordUI;
@property (nonatomic,assign)BOOL isWithdraw;
@end
