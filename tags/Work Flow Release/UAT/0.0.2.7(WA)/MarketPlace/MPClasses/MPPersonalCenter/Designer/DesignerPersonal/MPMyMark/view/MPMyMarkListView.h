//
//  MPMyMarkListView.h
//  MarketPlace
//
//  Created by xuezy on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

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
