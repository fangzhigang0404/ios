/**
 * @file    MPMeasureHouseCell.h
 * @brief   the controller of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-22
 */

#import <UIKit/UIKit.h>

@class MPDecorationNeedModel;
@protocol MPMeasureHouseCellDelegate <NSObject>

/**
 *  @brief the method for create picker view.
 *
 *  @param type the type for picker.
 *
 *  @param componet the count for pickerView.
 *
 *  @param linkage the bool for linkage or not.
 *
 *  @return void nil.
 */
- (void)chooseInfoWithType:(NSString *)type
                  componet:(NSInteger)componet
                   linkage:(BOOL)isLinkage;


/**
 *  @brief the method for hide picker view.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)hidePicker;

/**
 *  @brief the method for get measure price.
 *
 *  @param nil.
 *
 *  @return NSString the string of measure price.
 */
- (NSString *)getMeasureHousePrice;

/**
 *  @brief the method for get designer id.
 *
 *  @param nil.
 *
 *  @return NSString the string of designer id.
 */
- (NSString *)getMeasureDesignerId;

/**
 *  @brief the method for get hs uid.
 *
 *  @param nil.
 *
 *  @return NSString the string of hs uid.
 */
- (NSString *)getHsUid;

/**
 *  @brief the method for get thread id.
 *
 *  @param nil.
 *
 *  @return NSString the string of thread id.
 */
- (NSString *)getThreadId;

/**
 *  @brief the method for get decoration.
 *
 *  @param nil.
 *
 *  @return MPDecorationNeedModel the model of decoration.
 */
- (MPDecorationNeedModel *)getNeedInfo;

/**
 *  @brief the method for measure request.
 *
 *  @param parameters the dictonary for request body.
 *
 *  @param header the dictonary for request header.
 *
 *  @param isBidder the bool for bidder or not.
 *
 *  @param finish the block for measure over.
 *
 *  @return void nil.
 */
- (void)sendMeasureTableWithParameters:(NSDictionary *)parameters
                                header:(NSDictionary *)header
                              isBidder:(BOOL)isBidder
                                finish:(void(^) ())finish;

@end

@interface MPMeasureHouseCell : UITableViewCell

/// delegate.
@property (nonatomic, assign) id<MPMeasureHouseCellDelegate>delegate;

/// picker type.
@property (nonatomic, copy) NSString *type;

/**
 *  @brief the method for uodate view.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)updateCell;

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
- (void)getInfoForIssueDemandWithType:(NSString *)type
                            componet1:(NSString *)componet1
                            componet2:(NSString *)componet2
                            componet3:(NSString *)componet3
                                 nian:(NSString *)nian;

@end
