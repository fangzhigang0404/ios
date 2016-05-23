/**
 * @file    MPMeaNeedView.h
 * @brief   the view of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-25
 */

#import <UIKit/UIKit.h>

@protocol MPMeaNeedViewDelegate <NSObject>

/**
 *  @brief the method for get tableView section count.
 *
 *  @param nil.
 *
 *  @return NSInteger tableView section count.
 */
- (NSInteger)getSectionInMeaNeedTableView;

/**
 *  @brief the method for get tableView row count.
 *
 *  @param section table section.
 *
 *  @return NSInteger tableView section count.
 */
- (NSInteger)getRowsInMeaNeedTableView:(NSInteger)section;

/**
 *  @brief the method for get measure time.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)chooseMeasureDateInPicker;

/**
 *  @brief the method for get measure price.
 *
 *  @param nil.
 *
 *  @return NSString the string of measure price.
 */
- (NSString *)getMeasurePriceForMeaNeedView;

/**
 *  @brief the method for request.
 *
 *  @param date the measure time.
 *
 *  @param complete the block for request over.
 *
 *  @return NSString the string of measure price.
 */
- (void)sendMeasureNeedWithDate:(NSString *)date
                       complete:(void(^) ())complete;

/**
 *  @brief the method for hide view.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)hidePopupUI;

/**
 *  @brief the method for load more data.
 *
 *  @param complete the block for load over.
 *
 *  @return void nil.
 */
- (void)loadMoreDataComplete:(void(^) ())complete;

@end

@interface MPMeaNeedView : UIView

/// delegate.
@property (nonatomic, assign) id<MPMeaNeedViewDelegate>delegate;

/**
 *  @brief the method for refresh view.
 *
 *  @param seleted the index for show seleted image.
 *
 *  @return void nil.
 */
- (void)refreshMeaInfoUIWithSeletedIndex:(NSInteger)seleted;

/**
 *  @brief the method for get measure time.
 *
 *  @param complete the block for load over.
 *
 *  @param componet1 the information for picker in first line.
 *
 *  @param componet2 the information for picker in second line.
 *
 *  @param componet3 the information for picker in third line.
 *
 *  @return void nil.
 */
- (void)getMeaDateWithComponet1:(NSString *)componet1
                      componet2:(NSString *)componet2
                      componet3:(NSString *)componet3
                           nian:(NSString *)nian;

@end
