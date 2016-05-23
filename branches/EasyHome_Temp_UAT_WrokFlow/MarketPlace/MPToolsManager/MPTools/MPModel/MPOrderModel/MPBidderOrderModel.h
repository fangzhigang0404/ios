//
//  MPOrderLineModel.h
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@protocol MPBidderOrderModel <NSObject>

@end

@interface MPBidderOrderModel : MPModel

//"designer_id" = 20730235;
//"order_line_no" = 267;
//"order_no" = 267;
//"order_type" = 1;


@property (nonatomic, retain) NSNumber *designer_id;
@property (nonatomic, copy) NSString *order_line_no;
@property (nonatomic, copy) NSString *order_no;
@property (nonatomic, copy) NSString *order_type;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
