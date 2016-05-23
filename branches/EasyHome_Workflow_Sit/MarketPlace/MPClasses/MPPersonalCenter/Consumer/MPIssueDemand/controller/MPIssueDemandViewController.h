/**
 * @file    MPIssueDemandViewController.h
 * @brief   the controller of issue demand.
 * @author  niu
 * @version 1.0
 * @date    2015-01-20
 */

#import "MPBaseViewController.h"

typedef NS_ENUM(NSInteger, MPDecorationVCType)
{
    MPDecorationVCTypeIssue                    = 0,  //!< 0. issue.
    MPDecorationVCTypeDetail                         //!< 1. edit.
};

@class MPDecorationNeedModel;
@interface MPIssueDemandViewController : MPBaseViewController

/**
 *  @brief the method for instancetype.
 *
 *  @param type the type for controller.
 *
 *  @param need_id the id for need.
 *
 *  @param refresh the block for edit over.
 *
 *  @return void nil.
 */
- (instancetype)initWithType:(MPDecorationVCType)type
                      needID:(NSString *)need_id
                     refresh:(void(^) (MPDecorationNeedModel *model))refresh;

@end
