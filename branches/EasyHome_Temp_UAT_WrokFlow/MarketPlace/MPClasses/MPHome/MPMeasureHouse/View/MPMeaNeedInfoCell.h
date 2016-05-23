/**
 * @file    MPMeaNeedInfoCell.h
 * @brief   the view of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-25
 */

#import <UIKit/UIKit.h>

@class MPDecorationNeedModel;
@protocol MPMeaNeedInfoCellDelegate <NSObject>

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPDecorationNeedModel model class.
 */
- (MPDecorationNeedModel *)getModelForMeaNeedInfoView;

@end

@interface MPMeaNeedInfoCell : UITableViewCell

/// delegate.
@property (nonatomic, assign) id<MPMeaNeedInfoCellDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)updateMeaNeedInfoCell;

@end