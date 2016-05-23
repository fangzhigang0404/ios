/**
 * @file    MPMeasureInfoViewController.h
 * @brief   the controller of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-03-24
 */

#import "MPBaseViewController.h"

@interface MPMeasureInfoViewController : MPBaseViewController

@property (nonatomic, copy) NSString *thread_id;

/**
 *  @brief the method for instancetype.
 *
 *  @param designer_id the id for designer.
 *
 *  @param measure_price the price for measure.
 *
 *  @param hs_uid the string for designer uid.
 *
 *  @return void nil.
 */
- (instancetype)initWithDesignerID:(NSString *)designer_id
                      measurePrice:(NSString *)measure_price
                             hsuid:(NSString *)hs_uid;

@end
