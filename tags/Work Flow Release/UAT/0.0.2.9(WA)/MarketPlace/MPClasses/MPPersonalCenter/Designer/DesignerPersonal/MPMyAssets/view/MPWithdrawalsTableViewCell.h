//
//  MPWithdrawalsTableViewCell.h
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPDesignerWithdrawModel;

@protocol MPWithdrawTableViewCellDelegate <NSObject>

@required

-(MPDesignerWithdrawModel *) getWithdrawModelForIndex:(NSUInteger) index;
@end

@interface MPWithdrawalsTableViewCell : UITableViewCell
@property(assign,nonatomic) id<MPWithdrawTableViewCellDelegate> delegate;

-(void) updateCellForIndex:(NSUInteger) index;
@end
