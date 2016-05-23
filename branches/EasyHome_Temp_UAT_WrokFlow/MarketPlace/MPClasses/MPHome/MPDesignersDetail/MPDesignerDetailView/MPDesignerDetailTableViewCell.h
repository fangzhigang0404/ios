/**
 * @file    MPDesignerDetailTableViewCell.h
 * @brief   the cell of designer detail.
 * @author  niu
 * @version 1.0
 * @date    2015-01-26
 */

#import <UIKit/UIKit.h>

@class MPCaseModel;
@protocol MPDesignerDetailTableViewCellDelegate <NSObject>

/**
 *  @brief the method for get model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPCaseModel model class.
 */
- (MPCaseModel *)getDesignerDetailModelAtIndex:(NSInteger)index;

@end

@interface MPDesignerDetailTableViewCell : UITableViewCell

/// delegate.
@property (nonatomic, assign) id<MPDesignerDetailTableViewCellDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)updateCellForIndex:(NSInteger)index;

@end
