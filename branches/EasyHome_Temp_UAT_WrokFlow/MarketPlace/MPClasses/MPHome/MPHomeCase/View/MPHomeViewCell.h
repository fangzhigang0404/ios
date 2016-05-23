/**
 * @file    MPHomeViewCell.h
 * @brief   the cell of home case.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import <UIKit/UIKit.h>

@class MPCaseModel;

@protocol MPHomeViewCellDelegate <NSObject>

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPCaseModel model class.
 */
- (MPCaseModel *)getDatamodelForIndex:(NSUInteger)index;

/**
 *  @brief the method for click designer icon.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)designerIconClickedAtIndex:(NSUInteger)index;

/**
 *  @brief the method for click item.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void) chatButtonClickedAtIndex:(NSUInteger)index;

@end


@interface MPHomeViewCell : UICollectionViewCell

/// delegate.
@property (nonatomic, weak) id<MPHomeViewCellDelegate> delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void) updateCellUIForIndex:(NSUInteger)index;

@end
