//
//  MPContractViewController.h
//  MarketPlace
//
//  Created by Jiao on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWorkFlowBaseViewController.h"

@class MPDesignContractModel;
@interface MPContractViewController : MPWorkFlowBaseViewController

@property (nonatomic, assign) BOOL isPayNow;
@property (nonatomic,copy) NSString *designers;
@property (nonatomic, strong) MPDesignContractModel *contractModel;
@property (nonatomic, weak) __kindof UIViewController *fromVC;

- (instancetype)initWithNeedsID:(NSString *)needs_id
                  andDesignerID:(NSString *)designer_id;
@end
