//
//  MPCreatcontractctrollerTwo.h
//  MarketPlace
//
//  Created by zzz on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWorkFlowBaseViewController.h"

@class MPcreatcontractTwoModel;
@interface MPCreatcontractctrollerTwo : MPWorkFlowBaseViewController

@property (nonatomic, assign) BOOL isPayNow;

@property (nonatomic,copy) NSString *designers;

@property (nonatomic, strong) MPcreatcontractTwoModel *contractModel;

@property (nonatomic,strong)UIButton * btn;
@end

