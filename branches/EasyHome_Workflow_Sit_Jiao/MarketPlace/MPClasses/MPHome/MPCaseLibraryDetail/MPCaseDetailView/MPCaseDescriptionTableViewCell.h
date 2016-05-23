/**
 * @file    MPCaseDescriptionTableViewCell.h
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-01-16
 */
#import <UIKit/UIKit.h>

@class MPDecorationNeedModel;
@protocol MPCaseDescriptionTableViewCellDelegate <NSObject>

/**
 *  @brief the method for getting model.
 *
 *  @param nil.
 *
 *  @return MPCaseModel model class.
 */
- (MPDecorationNeedModel *)getNeedModel;


- (NSInteger)getBidderIndex;

/**
 *  @brief the method for thread_id.
 *
 *  @param nil.
 *
 *  @return NSString thread_id.
 */
- (NSString *)getThreadID;

/**
 *  @brief the method for success.
 *
 *  @param nil.
 *
 *  @return nil.
 */
- (void)measureSuccess;

/**
 *  @brief the method for hs_uid.
 *
 *  @param nil.
 *
 *  @return NSString hs_uid.
 */
- (NSString *)getHs_uid;

/**
 *  @brief the method for show view.
 *
 *  @param nil.
 *
 *  @return show view.
 */
- (UIView *)getControllerView;

@end

@class MPCaseModel;
@interface MPCaseDescriptionTableViewCell : UITableViewCell

@property (nonatomic, assign) id<MPCaseDescriptionTableViewCellDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)updateCellWithString:(MPCaseModel *)model;

@end
