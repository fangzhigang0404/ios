//
//  MPWKMeasureModel.h
//  MarketPlace
//
//  Created by Jiao on 16/2/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPWKMeasureModel : MPModel
@property (nonatomic, copy) NSString *contacts_name;//姓名
@property (nonatomic, copy) NSString *contacts_mobile;//电话
@property (nonatomic, copy) NSString *design_budget;//设计预算
@property (nonatomic, copy) NSString *decoration_budget;//装修预算
@property (nonatomic, copy) NSString *house_type;//房屋类型
@property (nonatomic, copy) NSString *house_area;//房屋面积
@property (nonatomic, copy) NSString *living_room;//户型（厅）
@property (nonatomic, copy) NSString *room;//户型（室）
@property (nonatomic, copy) NSString *toilet;//户型（卫）
@property (nonatomic, copy) NSString *decoration_style;//风格
@property (nonatomic, copy) NSString *measure_time;//量房时间
@property (nonatomic, copy) NSString *province;//量房地址（省）
@property (nonatomic, copy) NSString *city;//量房地址（市）
@property (nonatomic, copy) NSString *district;//量房地址（区）
@property (nonatomic, copy) NSString *community_name;//小区名称
@property (nonatomic, copy) NSString *measurement_fee;//量房费
+ (instancetype)getWKMeasureModelWithDict:(NSDictionary *)dict;
@end
