/**
 * @file    MPCaseLibraryTableViewCell.h
 * @brief   the frame of MPCaseLibraryViewController.
 * @author  Xue
 * @version 1.0
 * @date    2016-2-19
 */


#import <UIKit/UIKit.h>
@class MPCaseModel;

@protocol MPCaseLibraryTableViewCellDelegate <NSObject>

@required

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPCaseModel model class.
 */
-(MPCaseModel *) getCaseLibraryModelForIndex:(NSUInteger) index;
@end

@interface MPCaseLibraryTableViewCell : UITableViewCell
/// delegate.
@property(assign,nonatomic) id<MPCaseLibraryTableViewCellDelegate> delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
-(void) updateCellForIndex:(NSUInteger) index;
@end
