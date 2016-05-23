//
//  MPDeliveryDetailController.h
//  MarketPlace
//
//  Created by Jiao on 16/3/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWorkFlowBaseViewController.h"
#import "MPDeliveryDetailView.h"

@protocol MPDeliveryDetailControllerDelegate <NSObject>

- (void)selectedPlan:(MP3DPlanModel *)model;
- (void)selectedFiles:(NSArray *)files withType:(MPDeliveryDetailType)type withHas:(BOOL)has;

@end

@interface MPDeliveryDetailController : MPWorkFlowBaseViewController

@property (nonatomic, strong) NSArray *selectedArr;
@property (nonatomic, weak) id<MPDeliveryDetailControllerDelegate> delegate;

- (instancetype)initWithFilesArray:(NSArray *)array andType:(MPDeliveryDetailType)type andControllerType:(NSInteger)cType;
@end
