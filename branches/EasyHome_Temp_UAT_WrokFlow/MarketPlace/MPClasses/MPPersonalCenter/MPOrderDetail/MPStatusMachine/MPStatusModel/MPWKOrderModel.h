/**
 * @file    MPWKOrderModel.h
 * @brief   the model of order for payment.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-29
 *
 */

#import "MPModel.h"

@interface MPWKOrderModel : MPModel

/// the ID of designer.
@property (nonatomic, copy) NSString *designer_id;

/// the number of order.
@property (nonatomic, copy) NSString *order_no;

/// the number of order line.
@property (nonatomic, copy) NSString *order_line_no;

/// the type of order.
@property (nonatomic, copy) NSString *order_type;

/// the status of order.
@property (nonatomic, copy) NSString *order_status;

/**
 *  @brief get the model of order for payment.
 *
 *  @param dict the dictionary of data.
 *
 *  @return MPWKOrderModel.
 */
+ (instancetype)getWKOrderModelWithDict:(NSDictionary *)dict;
@end
