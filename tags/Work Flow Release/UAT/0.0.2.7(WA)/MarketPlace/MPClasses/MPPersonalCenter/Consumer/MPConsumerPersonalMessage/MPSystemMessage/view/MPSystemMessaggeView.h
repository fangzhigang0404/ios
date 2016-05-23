//
//  MPSystemMessaggeView.h
//  MarketPlace
//
//  Created by xuezy on 16/3/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MPSystemMessageViewDelegate <NSObject>

@required

/**
 * @brief didSelectItemAtIndex:(NSInteger)index
 *
 * @param Click on the system messages page jump corresponding function
 *
 * @return Corresponding function page.
 **/
- (void)didSelectItemAtIndex:(NSInteger)index;

///Number of messages
- (NSInteger)getSystemMessageCellCount;

///Refresh Load New Data
- (void)systemMessageViewRefreshLoadNewData:(void(^) ())finish;

///Refresh Load More Data
- (void)systemMessageViewRefreshLoadMoreData:(void(^) ())finish;

@end
@interface MPSystemMessaggeView : UIView <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic)id<MPSystemMessageViewDelegate>delegate;

///refresh System Message UI
- (void)refreshSystemMessageUI;
@end
