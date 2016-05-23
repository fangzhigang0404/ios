//
//  MPFindDesignersView.h
//  MarketPlace
//
//  Created by xuezy on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MPFindDesignersViewDelegate <NSObject>

@required
- (void)didSelectItemAtIndex:(NSInteger)index;
- (NSInteger)getDesignerCellCount;

- (void)findDesignersViewRefreshLoadNewData:(void(^) ())finish;

- (void)findDesignersViewRefreshLoadMoreData:(void(^) ())finish;

@end

@interface MPFindDesignersView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic)id<MPFindDesignersViewDelegate>delegate;

- (void) refreshFindDesignersUI;
@end
