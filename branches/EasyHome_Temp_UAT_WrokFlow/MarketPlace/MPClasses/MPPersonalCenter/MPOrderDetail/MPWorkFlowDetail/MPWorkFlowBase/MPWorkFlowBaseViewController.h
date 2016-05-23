/**
 * @file    MPWorkFlowBaseViewController.h
 * @brief   base viewController for wrokflow.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-23
 *
 */

#import "MPBaseViewController.h"
#import "MPStatusModel.h"
#import "MPStatusMachine.h"

@interface MPWorkFlowBaseViewController : MPBaseViewController

/// the model of current order.
@property (nonatomic, strong) MPStatusModel *statusModel;

/// the model of current order detail.
@property (nonatomic, strong) MPStatusDetail *statusDetail;
@end
