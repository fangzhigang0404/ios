/**
 * @file    MPProjectMaterialListViewController.h
 * @brief   Project material list .
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"

@interface MPProjectMaterialListViewController : MPBaseViewController
/**
 *  @brief init project material list .
 *
 *  @param assetId.
 *
 *  @return void nil.
 */
- (id) initWithAssetId:(NSString *)assetId;

@end
