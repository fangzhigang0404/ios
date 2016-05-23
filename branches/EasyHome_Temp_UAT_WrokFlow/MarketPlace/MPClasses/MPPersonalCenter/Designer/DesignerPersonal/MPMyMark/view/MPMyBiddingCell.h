/**
 * @file    MPMyBiddingCell.h
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-17
 */

#import <UIKit/UIKit.h>
@class MPMarkModel;

@protocol MPMyMarkTableViewCellDelegate <NSObject>

@required

-(MPMarkModel *) getDesignerLibraryModelForIndex:(NSUInteger) index;
-(void) startChatWithDesignerForIndex:(NSUInteger) index;
-(void) followDesignerForIndex:(NSUInteger) index;

@end

@interface MPMyBiddingCell : UITableViewCell

/// delegate.
@property(assign,nonatomic) id<MPMyMarkTableViewCellDelegate> delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
-(void) updateCellForIndex:(NSUInteger) index;
@end
