/**
 * @file    MPCaseDetailCollectionViewCell.h
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-22
 */

#import <UIKit/UIKit.h>
@class MPCaseImageModel;

@protocol MPCaseDetailCollectionViewCellDelegate <NSObject>

@required

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPCaseImageModel model class.
 */
-(MPCaseImageModel *) getCaseLibraryDetailModelForIndex:(NSUInteger) index;

/**
 *  @brief the method for show view.
 *
 *  @param nil.
 *
 *  @return show view.
 */
- (UIView *)getControllerView;
@end

@interface MPCaseDetailCollectionViewCell : UICollectionViewCell

/// delegate.
@property(assign,nonatomic) id<MPCaseDetailCollectionViewCellDelegate> delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
-(void) updateCellForIndex:(NSUInteger) index;
@end
