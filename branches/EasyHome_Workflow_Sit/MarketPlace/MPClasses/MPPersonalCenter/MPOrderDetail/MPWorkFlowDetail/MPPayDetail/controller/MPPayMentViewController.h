//
//  MPPayMentViewController.h
//  MarketPlace
//
//  Created by zzz on 16/2/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWorkFlowBaseViewController.h"
#import "MPPayView.h"


@interface MPPayMentViewController : MPWorkFlowBaseViewController
@property (nonatomic, weak) __kindof UIViewController *fromVC;

- (instancetype)initWithPayType:(MPPayType)type;
@end
