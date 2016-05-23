/**
 * @file    MPDesignerDetailHeaderTableViewCell.h
 * @brief   the cell of designer detail.
 * @author  niu
 * @version 1.0
 * @date    2015-01-26
 */

#import <UIKit/UIKit.h>

@class MPDesignerInfoModel;
@protocol MPDesignerDetailHeaderTableViewCellDelegate <NSObject>

/**
 *  @brief the method for get model.
 *
 *  @param nil.
 *
 *  @return MPDesignerInfoModel model class.
 */
- (MPDesignerInfoModel *)getDesignerInfoModel;

/**
 *  @brief the method for chat.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)chatWithDesigner;

/**
 *  @brief the method for measure.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)chooseTAMeasure;

@end

@interface MPDesignerDetailHeaderTableViewCell : UITableViewCell

/// delegate.
@property (nonatomic, assign) id<MPDesignerDetailHeaderTableViewCellDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @param isCenter the bool for show button or not.
 *
 *  @return void nil.
 */
- (void)updateCellForIndex:(NSInteger)index isCenter:(BOOL)isCenter;

@end
