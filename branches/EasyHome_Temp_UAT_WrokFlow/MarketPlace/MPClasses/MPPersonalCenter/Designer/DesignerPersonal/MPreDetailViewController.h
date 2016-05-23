/**
 * @file    MPreDetailViewController.h
 * @brief   the view of MPreDetailViewController view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPBaseViewController.h"

@interface MPreDetailViewController : MPBaseViewController///实名认证状态


/// name text.
@property (nonatomic,copy)NSString *zeroTitle;
/// mobile number text.
@property (nonatomic,copy)NSString *secondTitle;
/// birthday text.
@property (nonatomic,copy)NSString *threeTitle;
/// ID card text.
@property (nonatomic,copy)NSString *fourTitle;
/// gender text.
@property (nonatomic,copy)NSString *oneTitle;
/// ID card head photo.
@property (nonatomic,retain)NSDictionary *headDic;
/// ID card back photo.
@property (nonatomic,retain)NSDictionary *backDic;
/// ID card positive photo.
@property (nonatomic,retain)NSDictionary *positiveDic;
/// Review the status.
@property (nonatomic,copy)NSString *audit_status;

@end
