//
//  MPSenddesigncontract.h
//  MarketPlace
//
//  Created by zzz on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWorkFlowBaseViewController.h"

@interface MPSenddesigncontract : MPWorkFlowBaseViewController

- (NSString*)LoadContractString;

@property (nonatomic, copy)NSString * TotalCost;
@property (nonatomic, copy)NSString * FristCost;
@property (nonatomic, )NSString * EndCost;
@property (nonatomic, assign)BOOL selectShow;
@property (nonatomic, weak) __kindof UIViewController *fromVC;
@property (nonatomic, copy) NSString *design_sketch;
@property (nonatomic, copy) NSString *render_map;
@property (nonatomic, copy) NSString *design_sketch_plus;
@end
