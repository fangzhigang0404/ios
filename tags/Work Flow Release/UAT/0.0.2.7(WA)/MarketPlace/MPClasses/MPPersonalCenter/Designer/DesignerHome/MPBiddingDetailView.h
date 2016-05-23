//
//  MPBiddingDetailView.h
//  MarketPlace
//
//  Created by xuezy on 16/3/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MPBiddingDetailDelegate <NSObject>
@required

@end

@interface MPBiddingDetailView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic)id<MPBiddingDetailDelegate>delegate;
- (void)refreshBiddingViewUI;
@property (copy, nonatomic)NSString *type;
@property (copy,nonatomic)NSString *biddingStaus;

@end
