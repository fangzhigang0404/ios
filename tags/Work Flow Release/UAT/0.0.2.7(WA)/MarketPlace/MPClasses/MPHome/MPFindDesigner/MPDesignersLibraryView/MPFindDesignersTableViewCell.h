//
//  MPFindDesignersTableViewCell.h
//  MarketPlace
//
//  Created by xuezy on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MPDesignerInfoModel;

@protocol MPFindDesignersTableViewCellDelegate <NSObject>

@required

-(MPDesignerInfoModel *) getDesignerLibraryModelForIndex:(NSUInteger) index;
-(void) startChatWithDesignerForIndex:(NSUInteger) index;
-(void) followDesignerForIndex:(NSUInteger) index;

@end

@interface MPFindDesignersTableViewCell : UITableViewCell
@property(assign,nonatomic) id<MPFindDesignersTableViewCellDelegate> delegate;

-(void) updateCellForIndex:(NSUInteger) index;
@end
