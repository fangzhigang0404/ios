//
//  MPQRCodeTool.h
//  MarketPlace
//
//  Created by WP on 16/4/8.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPQRCodeTool : NSObject

/// check camera enable or not.
+ (BOOL)checkCameraEnable;

/// check QR receive dict.
+ (void)checkQRWithViewController:(UIViewController *)vc
                             dict:(NSDictionary *)dict;

+ (void)checkQRBtn:(UIButton *)btn;

@end
