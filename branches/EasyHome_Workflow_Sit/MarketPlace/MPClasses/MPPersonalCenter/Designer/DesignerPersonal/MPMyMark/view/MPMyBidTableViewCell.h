/**
 * @file    MPMyBidTableViewCell.h
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-18
 */

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
