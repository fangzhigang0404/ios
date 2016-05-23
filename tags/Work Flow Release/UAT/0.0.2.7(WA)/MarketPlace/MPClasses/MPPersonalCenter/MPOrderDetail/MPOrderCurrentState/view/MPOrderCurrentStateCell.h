/**
 * @file    MPOrderCurrentStateCell.h
 * @brief   the cell of current asset status.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-27
 *
 */

#import <UIKit/UIKit.h>
@class MPOrderCurrentStateModel;

/// the delegate of MPOrderCurrentStateCell.
@protocol MPOrderCurrentStateCellDelegate <NSObject>

/**
 *  @brief get the model with index.
 *
 *  @param index the index of item.
 *
 *  @return the model of current asset status.
 */
- (MPOrderCurrentStateModel *)getContractModelForIndex:(NSUInteger)index;

@end

@interface MPOrderCurrentStateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, assign) id<MPOrderCurrentStateCellDelegate> delegate;

- (void)updateCellForIndex:(NSUInteger)index;
@end
