/**
 * @file    MPBiddingTableViewCell.h.
 * @brief   the view for cell.
 * @author  Xue.
 * @version 1.0.
 * @date    2016-02-24.
 */

#import <UIKit/UIKit.h>
@class MPDecorationNeedModel;
@protocol MPBiddingCellDelegate <NSObject>

@required

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPDecorationNeedModel model class.
 */
-(MPDecorationNeedModel *) getBidingModelForIndex:(NSUInteger) index;

-(void) startChatWithBiddingForIndex:(NSUInteger) index;

-(void) followBiddingForIndex:(NSUInteger) index;
@end

@interface MPBiddingTableViewCell : UITableViewCell

/// delegate.
@property(assign,nonatomic) id<MPBiddingCellDelegate> delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
-(void) updateCellForIndex:(NSUInteger) index;

@end
