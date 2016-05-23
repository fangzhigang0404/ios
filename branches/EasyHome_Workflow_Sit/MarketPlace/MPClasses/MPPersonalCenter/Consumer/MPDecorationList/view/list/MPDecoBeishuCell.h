/**
 * @file    MPDecoBeishuCell.h
 * @brief   the view for cell.
 * @author  niu
 * @version 1.0
 * @date    2016-02-18
 */

#import <UIKit/UIKit.h>

@class MPDecorationNeedModel;
@protocol MPDecoBeishuCellDelegate <NSObject>

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPDecorationNeedModel model class.
 */
- (MPDecorationNeedModel *)getDecorationModelAtIndex:(NSInteger)index;

/**
 *  @brief the method for chatting.
 *
 *  @param model the model for decoration.
 *
 *  @return void nil.
 */
- (void)chatWithDesigner:(MPDecorationNeedModel *)model;

/**
 *  @brief the method for calling.
 *
 *  @param phoneNumber the string for phone number.
 *
 *  @return void nil.
 */
- (void)callPhoneNumber:(NSString *)phoneNumber;

@end

@interface MPDecoBeishuCell : UICollectionViewCell

/// delegate.
@property (nonatomic, assign) id<MPDecoBeishuCellDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)updateCellForIndex:(NSUInteger)index;

@end
