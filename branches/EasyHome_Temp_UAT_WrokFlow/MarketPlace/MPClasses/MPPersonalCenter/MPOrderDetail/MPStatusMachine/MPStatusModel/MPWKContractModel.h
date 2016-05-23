/**
 * @file    MPWKContractModel.h
 * @brief   the model of contract.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-29
 *
 */

#import "MPModel.h"

@interface MPWKContractModel : MPModel

/// the total charge of contract.
@property (nonatomic, copy) NSString *contract_charge;

/// the time of contract created.
@property (nonatomic, copy) NSString *contract_create_date;

/// the custom data of contract detail.
@property (nonatomic, copy) NSString *contract_data;

/// the first charge of contract.
@property (nonatomic, copy) NSString *contract_first_charge;

/// the number of contract.
@property (nonatomic, copy) NSString *contract_no;

/// the status of contract.
@property (nonatomic, copy) NSString *contract_status;

/// the type of contract.
@property (nonatomic, copy) NSString *contract_type;

/// the temp url of contract.
@property (nonatomic, copy) NSString *contract_template_url;

/// the time of contract updated.
@property (nonatomic, copy) NSString *contract_update_date;

/// ID of designer.
@property (nonatomic, copy) NSString *designer_id;//设计师id

/**
 *  @brief get contract model.
 *
 *  @param dict the dictionary of data.
 *
 *  @return MPWKContractModel.
 */
+ (instancetype)getWKContractModelWithDict:(NSDictionary *)dict;
@end
