/**
 * @file    MPStatusModel.h
 * @brief   the model of order status.
 * @author  Jiao
 * @version 1.0
 * @date    2016-02-22
 *
 */

#import "MPModel.h"
#import "MPWorkFlowModel.h"
#import "MPWKMeasureModel.h"
#import "MPWKOrderModel.h"
#import "MPWKContractModel.h"

@interface MPStatusModel : MPModel

/// ID of requirement.
@property (nonatomic, copy) NSString *needs_id;

/// ID of designer.
@property (nonatomic, copy) NSString *designer_id;

/// ID of designer at HomeStyler.
@property (nonatomic, copy) NSString *hs_uid;

/// the time of the order created.
@property (nonatomic, copy) NSString *join_time;

/// the mobile number of designer.
@property (nonatomic, copy) NSString *designer_mobile;

/// the real name of designer.
@property (nonatomic, copy) NSString *designer_realName;

/// the email of designer.
@property (nonatomic, copy) NSString *designer_email;
@property (nonatomic, strong) MPWorkFlowModel *workFlowModel;
@property (nonatomic, strong) MPWKMeasureModel *wk_measureModel;
@property (nonatomic, strong) NSArray <MPWKOrderModel *> *wk_orders;
@property (nonatomic, strong) MPWKContractModel *wk_contractModel;


+ (instancetype)getCurrentStatusModelWithDict:(NSDictionary *)dict;
@end

@interface MPStatusDetail : NSObject
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL selectShow;
+ (instancetype)getStatusDetailWithDict:(NSDictionary *)dict;
@end