/**
 * @file    MPCaseDetailTableViewCell.h
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-1-26
 */

#import <UIKit/UIKit.h>
@class MPCaseModel;

@protocol MPCaseDetailCellDelegate <NSObject>

@required

/**
 *  @brief the method for pop viewcontroller.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)closeView;

@end

@interface MPCaseDetailTableViewCell : UITableViewCell

/// delegate.
@property(assign,nonatomic) id<MPCaseDetailCellDelegate> delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)updateCellWithImageUrl:(MPCaseModel *)model;
@end
