//
//  MPMyBiddingCell.h
//  MarketPlace
//
//  Created by xuezy on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMarkModel;

@protocol MPMyMarkTableViewCellDelegate <NSObject>

@required

-(MPMarkModel *) getDesignerLibraryModelForIndex:(NSUInteger) index;
-(void) startChatWithDesignerForIndex:(NSUInteger) index;
-(void) followDesignerForIndex:(NSUInteger) index;

@end

@interface MPMyBiddingCell : UITableViewCell
@property(assign,nonatomic) id<MPMyMarkTableViewCellDelegate> delegate;

-(void) updateCellForIndex:(NSUInteger) index;
@end
