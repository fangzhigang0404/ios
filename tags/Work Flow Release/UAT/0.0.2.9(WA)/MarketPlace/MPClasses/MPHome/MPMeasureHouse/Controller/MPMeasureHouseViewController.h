/**
 * @file    MPMeasureHouseViewController.h
 * @brief   the controller of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-03-24
 */

#import "MPBaseViewController.h"

@class MPDecorationNeedModel;
@interface MPMeasureHouseViewController : MPBaseViewController

/// the block for measure.
@property (nonatomic, copy) void (^success)();

/**
 *  @brief the method for instancetype.
 *
 *  @param designer_id the id for designer.
 *
 *  @param measure_price the price for measure.
 *
 *  @param hs_uid the string for designer uid.
 *
 *  @param needModel the model for decoration.
 *
 *  @param vc current viewcontroller.
 *
 *  @return void nil.
 */
- (instancetype)initWithDesignerID:(NSString *)designer_id
                     measure_price:(NSString *)measure_price
                            hs_uid:(NSString *)hs_uid
                         needModel:(MPDecorationNeedModel *)needModel
                          isBidder:(BOOL)isBidder
                            needID:(NSString *)need_id;

@end
