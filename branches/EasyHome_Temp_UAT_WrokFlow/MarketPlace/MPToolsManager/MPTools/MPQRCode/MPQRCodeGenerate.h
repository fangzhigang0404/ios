//
//  MPQRCodeManager.h
//  QR Code
//
//  Created by WP on 16/1/10.
//  Copyright © 2016年 niu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MPQRCodeGenerate : NSObject

@property (nonatomic, copy) void (^over)(BOOL over);

+ (MPQRCodeGenerate *)shareQRCodeGenerate;

- (void)createQRCodeWithString: (NSString *)stringURL complete:(void(^) (UIImage *QRImage))complete;

@end
