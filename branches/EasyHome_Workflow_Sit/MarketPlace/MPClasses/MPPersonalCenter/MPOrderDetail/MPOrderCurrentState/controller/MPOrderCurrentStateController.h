/**
 * @file    MPOrderCurrentStateController.h
 * @brief   the controller of current asset status.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-27
 *
 */

#import "MPBaseViewController.h"

@class MPStatusModel;

@interface MPOrderCurrentStateController : MPBaseViewController

/// the back bloack with sub node id.
@property (nonatomic, copy) void (^backStatus)(NSString *sub_node_id);

/// the id of needs.
@property (nonatomic, copy) NSString *needs_id;

/// the id of designer(acs member id).
@property (nonatomic, copy) NSString *designer_id;

@end
