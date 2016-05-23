/**
 * @file    MPCaseDetailView.h
 * @brief   caseDetailView.
 * @author  Xue.
 * @version 1.0
 * @date    2015-12-22
 */

#import <UIKit/UIKit.h>
@class MPCaseModel;
@protocol MPCaseDetailDelegate <NSObject>
@required

-(void)popViewController;
-(void)pushTheDetailViewController:(__kindof UIViewController *)controller;

@end

@interface MPCaseDetailView : UIView<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)id<MPCaseDetailDelegate>delegate;
@property(nonatomic,strong) UITableView *caseDetailTableView;
@property(nonatomic,copy) NSMutableArray *caseDetailArray;
@property(nonatomic,copy)NSString *caseId;

- (void)updateCaseDetailData:(MPCaseModel *)model;
@end
