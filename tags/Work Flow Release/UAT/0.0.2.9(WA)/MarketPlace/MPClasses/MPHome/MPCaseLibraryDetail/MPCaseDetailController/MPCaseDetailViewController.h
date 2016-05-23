/**
 * @file    MPCaseDetailViewController.h
 * @brief   caseDetailViewController.
 * @author  Xue.
 * @version 1.0.
 * @date    2015-12-22.
 */

#import "MPBaseViewController.h"
#import "MPCaseModel.h"
@class MPDecorationNeedModel;
@interface MPCaseDetailViewController : MPBaseViewController///案例详情
@property (copy,nonatomic)NSString *case_Id;
@property (copy,nonatomic)NSString *titleString;
@property (nonatomic, retain) MPDecorationNeedModel *needModel;
@property (nonatomic, assign) NSInteger bidderIndex;
@property (nonatomic, copy) NSString *thread_id;
@property (nonatomic, copy) NSString *hs_uid;
@property (nonatomic, copy) void (^success)();
@property (nonatomic, strong) MPCaseModel *caseModel;

@end
