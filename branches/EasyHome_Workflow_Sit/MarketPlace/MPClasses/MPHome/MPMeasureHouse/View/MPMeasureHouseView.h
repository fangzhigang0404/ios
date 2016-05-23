/**
 * @file    MPMeasureHouseView.h
 * @brief   the view of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-22
 */

#import <UIKit/UIKit.h>

@protocol MPMeasureHouseViewDelegate <NSObject>

/**
 *  @brief the method for get tableView section count.
 *
 *  @param nil.
 *
 *  @return NSInteger tableView section count.
 */
- (NSInteger)getNumOfSectionForMeasureHouseView;

/**
 *  @brief the method for hide picker.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)hidePickerInMeasureHouseWhenScroll;

@end

@class MPDecorationNeedModel;
@interface MPMeasureHouseView : UIView

/// delegate.
@property (nonatomic, assign) id<MPMeasureHouseViewDelegate>delegate;

/**
 *  @brief the method for refresh data.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)refreshIssueDemandUI;

/**
 *  @brief the method for get picker information.
 *
 *  @param type the type for picker.
 *
 *  @param componet1 the information for picker in first line.
 *
 *  @param componet2 the information for picker in second line.
 *
 *  @param componet3 the information for picker in third line.
 *
 *  @return void nil.
 */
- (void)getPickerInfoInIssueAmendViewWithType:(NSString *)type
                                    componet1:(NSString *)componet1
                                    componet2:(NSString *)componet2
                                    componet3:(NSString *)componet3
                                         nian:(NSString *)nian;

@end
