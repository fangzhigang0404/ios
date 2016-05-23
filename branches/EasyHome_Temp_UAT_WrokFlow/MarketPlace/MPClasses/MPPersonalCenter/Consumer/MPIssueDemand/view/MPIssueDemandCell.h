/**
 * @file    MPIssueDemandCell.h
 * @brief   the cell of table.
 * @author  niu
 * @version 1.0
 * @date    2016-01-20
 */

#import <UIKit/UIKit.h>

@class MPDecorationNeedModel;
@protocol MPIssueDemandCellDelegate <NSObject>

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
 *  @brief the method for issue decoration.
 *
 *  @param parameters the dictonary for param.
 *
 *  @param header the dictonary for request.
 *
 *  @param finish the block for request over.
 *
 *  @return void nil.
 */
- (void)uploadDemandWithParameters:(NSDictionary *)parameters
                            header:(NSDictionary *)header
                            finish:(void(^) ())finish;
/**
 *  @brief the method for cancel decoration.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)cancelDecoration;

/**
 *  @brief the method for issue decoration again.
 *
 *  @param parameters the dictonary for param.
 *
 *  @param header the dictonary for request.
 *
 *  @param finish the block for request over.
 *
 *  @return void nil.
 */
- (void)issueAgainWithParameters:(NSDictionary *)parameters
                          header:(NSDictionary *)header
                          finish:(void(^) ())finish;

@end

@interface MPIssueDemandCell : UITableViewCell

/// delegate.
@property (nonatomic, assign) id<MPIssueDemandCellDelegate>delegate;

/// the type for cell.
@property (nonatomic, copy) NSString *type;

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
                            componet3:(NSString *)componet3;

/**
 *  @brief the method for updating view.
 *
 *  @param model the model for decoration.
 *
 *  @return void nil.
 */
- (void)updateCellForDecorationDetail:(MPDecorationNeedModel *)model;

@end

