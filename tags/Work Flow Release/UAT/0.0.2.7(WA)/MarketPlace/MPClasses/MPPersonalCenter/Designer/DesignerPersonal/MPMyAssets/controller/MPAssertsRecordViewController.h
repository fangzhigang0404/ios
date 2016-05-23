//
//  MPAssertsRecordViewController.h
//  MarketPlace
//
//  Created by xuezy on 16/3/8.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPBaseViewController.h"

typedef enum : NSUInteger {
    MPPayForNone = 0,
    MPAssetsRecordForTrade,
    MPAssetsRecordForWithdraw
}MPAssetsRecordType ;

@interface MPAssertsRecordViewController : MPBaseViewController
- (instancetype)initWithType:(MPAssetsRecordType)type;
@end
