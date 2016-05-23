/**
 * @file    MPCaseLibraryDetailViewController.h
 * @brief   caseDetailViewController.
 * @author  Xue.
 * @version 1.0.
 * @date    2016-2-20.
 */

#import "MPBaseViewController.h"

@class MPCaseModel;
@class MPDecorationNeedModel;
@interface MPCaseLibraryDetailViewController : MPBaseViewController

@property (nonatomic, retain) MPCaseModel *model;

@property (nonatomic, retain) NSMutableArray *arrayDS;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, retain) MPDecorationNeedModel *needModel;

@property (nonatomic, assign) NSInteger bidderIndex;

@property (nonatomic, copy) NSString *thread_id;

@property (nonatomic, copy) NSString *hs_uid;
@property (nonatomic, copy) NSString *case_id;

@property (nonatomic, copy) void (^success)();

@end
