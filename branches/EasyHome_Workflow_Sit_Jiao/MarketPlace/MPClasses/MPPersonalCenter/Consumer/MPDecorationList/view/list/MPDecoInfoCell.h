/**
 * @file    MPDecoInfoCell.h
 * @brief   the view for decoration.
 * @author  niu
 * @version 1.0
 * @date    2016-02-23
 */

#import <UIKit/UIKit.h>

@class MPDecorationNeedModel;
@protocol MPDecoInfoCellDelegate <NSObject>

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPDecorationNeedModel model class.
 */
- (MPDecorationNeedModel *)getModelForDecoInfoViewAtIndex:(NSInteger)index;

@end

@interface MPDecoInfoCell : UITableViewCell

/// delegate.
@property (nonatomic, assign) id<MPDecoInfoCellDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)updateCellAtIndex:(NSInteger)index;

@end
