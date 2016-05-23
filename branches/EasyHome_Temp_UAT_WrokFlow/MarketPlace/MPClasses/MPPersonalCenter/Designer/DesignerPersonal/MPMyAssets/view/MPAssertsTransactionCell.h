//
//  MPAssertsTransactionCell.h
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPDesignerTransactionRecordModel;

@protocol MPRecordTableViewCellDelegate <NSObject>

@required

-(MPDesignerTransactionRecordModel *) getRecordModelForIndex:(NSUInteger) index;
@end

@interface MPAssertsTransactionCell : UITableViewCell
@property(assign,nonatomic) id<MPRecordTableViewCellDelegate> delegate;

-(void) updateCellForIndex:(NSUInteger) index;
@end
