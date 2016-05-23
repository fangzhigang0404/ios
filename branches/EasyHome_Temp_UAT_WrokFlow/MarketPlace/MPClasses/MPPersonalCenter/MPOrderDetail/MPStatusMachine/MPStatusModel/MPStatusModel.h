/**
 * @file    MPStatusModel.h
 * @brief   the model of order status.
 * @author  Shaco(Jiao)
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

/// the model of work flow.
@property (nonatomic, strong) MPWorkFlowModel *workFlowModel;

/// the model of measurement.
@property (nonatomic, strong) MPWKMeasureModel *wk_measureModel;

/// the models of orders for payment.
@property (nonatomic, strong) NSArray <MPWKOrderModel *> *wk_orders;

/// the model of contract.
@property (nonatomic, strong) MPWKContractModel *wk_contractModel;

/**
 *  @brief get the current status order model.
 *
 *  @param dict the dictionary of data.
 *
 *  @return MPStatusModel.
 */
+ (instancetype)getCurrentStatusModelWithDict:(NSDictionary *)dict;
@end

@interface MPStatusDetail : NSObject
/// the  alert message of detail.
@property (nonatomic, copy) NSString *message;

/// the bool value of button shown or not in order detail.
@property (nonatomic, assign) BOOL selectShow;

/**
 *  @brief get the detail model.
 *
 *  @param dict the dictionary of data.
 *
 *  @return MPStatusDetail.
 */
+ (instancetype)getStatusDetailWithDict:(NSDictionary *)dict;
@end