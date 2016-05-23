//
//  MPBiddingDetailTableViewCell.h
//  MarketPlace
//
//  Created by xuezy on 16/3/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMarkHallModel;

@protocol MPBiddingDetailCellDelegate <NSObject>

@required

-(MPMarkHallModel *) getBiddingModel;

- (void)selectBiddingMothds;
- (void)refuseBiddingMothds;
@end;

@interface MPBiddingDetailTableViewCell : UITableViewCell
@property (weak, nonatomic)id<MPBiddingDetailCellDelegate>delegate;
@property (copy, nonatomic)NSString *type;
@property (copy,nonatomic)NSString *biddingStaus;

-(void) updateCellForIndex;

@end
