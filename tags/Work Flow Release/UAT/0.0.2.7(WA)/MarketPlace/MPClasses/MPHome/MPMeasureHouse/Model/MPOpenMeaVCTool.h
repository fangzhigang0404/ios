//
//  MPOpenMeaVCTool.h
//  MarketPlace
//
//  Created by WP on 16/4/27.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPOpenMeaVCTool : NSObject

/**
 *  @brief the method for open measure controller.
 *
 *  @param designer_id the id for designer.
 *
 *  @param hs_uid the string for designer uid.
 *
 *  @param vc current viewcontroller.
 *
 *  @return void nil.
 */
+ (void)openMeasureVCZixuanWithDesignerID:(NSString *)designer_id
                                   hs_uid:(NSString *)hs_uid
                                       vc:(UIViewController *)vc;

/**
 *  @brief the method for open bidder measure controller.
 *
 *  @param designer_id the id for designer.
 *
 *  @param hs_uid the string for designer uid.
 *
 *  @param need_id the id for decoration.
 *
 *  @param vc current viewcontroller.
 *
 *  @return void nil.
 */
+ (void)openMeasureVCYingbiaoWithDesignerID:(NSString *)designer_id
                                     hs_uid:(NSString *)hs_uid
                                     needID:(NSString *)need_id
                                         vc:(UIViewController *)vc;

@end
