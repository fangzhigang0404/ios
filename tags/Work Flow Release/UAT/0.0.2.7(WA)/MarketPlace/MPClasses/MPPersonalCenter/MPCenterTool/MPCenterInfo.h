/**
 * @file    MPCenterInfo.h
 * @brief   the tool of person center.
 * @author  niu
 * @version 1.0
 * @date    2015-04-07
 */

#import <Foundation/Foundation.h>

@interface MPCenterInfo : NSObject<NSCoding>

@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *is_loho;
@property (nonatomic, copy) NSString *hitachi_account;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *mobile_number;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *design_price_max;
@property (nonatomic, copy) NSString *design_price_min;
@property (nonatomic, copy) NSString *measurement_price;
@property (nonatomic, copy) NSString *acount;

@end
