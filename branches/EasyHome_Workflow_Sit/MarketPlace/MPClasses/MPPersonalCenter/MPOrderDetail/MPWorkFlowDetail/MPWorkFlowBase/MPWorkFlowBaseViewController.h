//
//  MPWorkFlowBaseViewController.h
//  MarketPlace
//
//  Created by Jiao on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPBaseViewController.h"
#import "MPStatusModel.h"
#import "MPStatusMachine.h"

@interface MPWorkFlowBaseViewController : MPBaseViewController
@property (nonatomic, strong) MPStatusModel *statusModel;
@property (nonatomic, strong) MPStatusDetail *statusDetail;
@end
