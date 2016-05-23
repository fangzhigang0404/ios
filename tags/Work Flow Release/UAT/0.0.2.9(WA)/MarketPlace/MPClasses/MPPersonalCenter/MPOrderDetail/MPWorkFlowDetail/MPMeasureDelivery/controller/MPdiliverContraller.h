//
//  MPDesignediliverView.h
//  MarketPlace
//
//  Created by zzz on 16/3/16.
//  Copyright © 2016年 xuezy. All rights reserved.
//


#import "MPWorkFlowBaseViewController.h"

@interface MPdiliverContraller : MPWorkFlowBaseViewController
@property (nonatomic,strong)NSString * assetid;
@property (nonatomic,strong)NSString * needid;
@property (nonatomic,strong)NSString * desingerid;
@property (nonatomic,strong)NSString * TypeD;
@property (nonatomic,strong)NSString * fileid;
@property (nonatomic ,copy) void (^dict)(NSMutableDictionary *dict);
// 提交量房交付物
- (void)GETneedid:(NSString * )neeid WithDesingerid:(NSString *)desingerid WithAssentid:(NSString *)assentid;
// 浏览量房交付物
- (void)GETneedid:(NSString * )neeid WithDesingerid:(NSString *)desingerid;

@end
