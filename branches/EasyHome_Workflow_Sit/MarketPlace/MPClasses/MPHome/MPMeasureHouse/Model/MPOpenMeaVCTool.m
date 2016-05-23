//
//  MPOpenMeaVCTool.m
//  MarketPlace
//
//  Created by WP on 16/4/27.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPOpenMeaVCTool.h"
#import "MPMeasureHouseViewController.h"

@implementation MPOpenMeaVCTool

+ (void)openMeasureVCZixuanWithDesignerID:(NSString *)designer_id
                                   hs_uid:(NSString *)hs_uid
                                       vc:(UIViewController *)vc {
    
    MPMeasureHouseViewController *measureVC = [[MPMeasureHouseViewController alloc]
                                               initWithDesignerID:designer_id
                                               measure_price:nil
                                               hs_uid:hs_uid
                                               needModel:nil
                                               isBidder:NO
                                               needID:nil];
    
    [vc.navigationController pushViewController:measureVC animated:YES];
}

+ (void)openMeasureVCYingbiaoWithDesignerID:(NSString *)designer_id
                                     hs_uid:(NSString *)hs_uid
                                     needID:(NSString *)need_id
                                         vc:(UIViewController *)vc {
    
    BOOL isBidder = ![self measureStatusSuccessOrNot];
    
    MPMeasureHouseViewController *measureVC;
    if (isBidder) {
        measureVC = [[MPMeasureHouseViewController alloc]
                     initWithDesignerID:designer_id
                     measure_price:nil
                     hs_uid:nil
                     needModel:nil
                     isBidder:isBidder
                     needID:need_id];
    } else {
        measureVC = [[MPMeasureHouseViewController alloc]
                     initWithDesignerID:designer_id
                     measure_price:nil
                     hs_uid:hs_uid
                     needModel:nil
                     isBidder:NO
                     needID:nil];
    }
    
    [vc.navigationController pushViewController:measureVC animated:YES];
}

+ (BOOL)measureStatusSuccessOrNot {
    NSString *str =  [[NSUserDefaults standardUserDefaults] objectForKey:@"measure_success"];
    BOOL bl = [str isEqualToString:@"1"];
    return bl;
}

@end
