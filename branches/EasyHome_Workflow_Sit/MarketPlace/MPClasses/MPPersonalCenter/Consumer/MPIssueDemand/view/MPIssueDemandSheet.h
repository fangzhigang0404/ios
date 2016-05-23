//
//  MPIssueDemandSheet.h
//  MarketPlace
//
//  Created by WP on 16/2/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPDecorationNeedModel;
@interface MPIssueDemandSheet : NSObject

+ (void)createSheetWithParameters:(NSDictionary *)parmeter
                  alertController:(void(^)(UIAlertController *alertController))alertController
                           finish:(void(^) (MPDecorationNeedModel *model))finish;

@end
