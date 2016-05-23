/**
 * @file    MPAssertsRecordViewController.h
 * @brief   the frame of MPAssertsRecordViewController.
 * @author  Xue
 * @version 1.0
 * @date    2016-03-08
 */

#import "MPBaseViewController.h"

typedef enum : NSUInteger {
    MPPayForNone = 0,
    MPAssetsRecordForTrade,
    MPAssetsRecordForWithdraw
}MPAssetsRecordType ;

@interface MPAssertsRecordViewController : MPBaseViewController
- (instancetype)initWithType:(MPAssetsRecordType)type;
@end
