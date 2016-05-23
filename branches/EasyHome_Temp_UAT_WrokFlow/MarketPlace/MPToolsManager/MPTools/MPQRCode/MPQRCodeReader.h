//
//  MPQRCodeReader.h
//  QR Code
//
//  Created by niu on 16/1/11.
//  Copyright © 2016年 niu. All rights reserved.
//

#import "MPBaseViewController.h"
@interface MPQRCodeReader : MPBaseViewController

@property (nonatomic ,copy) void (^dict)(NSDictionary *dict);

@end
