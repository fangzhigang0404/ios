/**
 * @file    MPIssueDemandView.h
 * @brief   the view of controller.
 * @author  niu
 * @version 1.0
 * @date    2016-2-1
 */

#import <UIKit/UIKit.h>

@protocol MPIssueDemandViewDelegate <NSObject>

/**
 *  @brief the method for get table section.
 *
 *  @param nil.
 *
 *  @return NSInteger tableView scetion.
 */
- (NSInteger)getNumOfSectionForIssueAmendView;

/**
 *  @brief the method for hide picker.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)hidePickerInIssueAmendWhenScroll;

@end

@class MPDecorationNeedModel;
@interface MPIssueDemandView : UIView

/// delegate.
@property (nonatomic, assign) id<MPIssueDemandViewDelegate>delegate;

/**
 *  @brief the method for refresh UI.
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
                                    componet3:(NSString *)componet3;

/**
 *  @brief the method for updating view.
 *
 *  @param model the model for decoration.
 *
 *  @return void nil.
 */
- (void)updateDecorationDetailUI:(MPDecorationNeedModel *)model;

@end
