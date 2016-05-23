//
//  MPSystemMessageTableViewCell.h
//  MarketPlace
//
//  Created by xuezy on 16/3/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPSystemMessageModel;

@protocol MPSystemMessageTableViewCellDelegate <NSObject>

@required


/**
 * @brief getSystemMessaggeModelForIndex:(NSUInteger) index
 *
 * @param get System Message Model For Index
 *
 * @return The corresponding system messages.
**/
-(MPSystemMessageModel *) getSystemMessaggeModelForIndex:(NSUInteger) index;

//-(void) startChatWithSystemMessageForIndex:(NSUInteger) index;
//
//
//-(void) followSystemMessageForIndex:(NSUInteger) index;

@end

@interface MPSystemMessageTableViewCell : UITableViewCell
@property(assign,nonatomic) id<MPSystemMessageTableViewCellDelegate> delegate;

-(void) updateCellForIndex:(NSUInteger) index;
@end
