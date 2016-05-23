//
//  MPMyBidTableViewCell.h
//  MarketPlace
//
//  Created by xuezy on 16/2/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPMarkModel;

@protocol MPMyBiddingCellDelegate <NSObject>

@required

-(MPMarkModel *) getDesignerLibraryModelForIndex:(NSUInteger) index;
-(void) startChatWithDesignerForIndex:(NSUInteger) index;
-(void) followDesignerForIndex:(NSUInteger) index;

- (void)pushToMyProject:(NSUInteger)index;
@end


@interface MPMyBidTableViewCell : UITableViewCell
@property(assign,nonatomic) id<MPMyBiddingCellDelegate> delegate;

-(void) updateCellForIndex:(NSUInteger) index withType:(NSString *)type;

@end
