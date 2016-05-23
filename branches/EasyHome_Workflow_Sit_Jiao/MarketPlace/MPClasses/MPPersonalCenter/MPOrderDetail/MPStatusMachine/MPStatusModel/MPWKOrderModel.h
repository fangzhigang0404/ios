//
//  MPWKOrderModel.h
//  MarketPlace
//
//  Created by Jiao on 16/2/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPWKOrderModel : MPModel
@property (nonatomic, copy) NSString *designer_id;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *order_line_no;
@property (nonatomic, copy) NSString *order_type;
@property (nonatomic, copy) NSString *order_status;

+ (instancetype)getWKOrderModelWithDict:(NSDictionary *)dict;
@end
