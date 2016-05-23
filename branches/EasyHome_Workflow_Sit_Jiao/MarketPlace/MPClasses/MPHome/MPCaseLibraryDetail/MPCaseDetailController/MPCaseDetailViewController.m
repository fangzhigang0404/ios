/**
 * @file    MPCaseDetailViewController.m
 * @brief   caseDetailViewController.
 * @author  Xue
 * @version 1.0
 * @date    2015-12-22
 */

#import "MPCaseDetailViewController.h"
#import "MPCaseDetailView.h"
#import "MPCaseBaseModel.h"
#import "MPCaseDetailTableViewCell.h"
#import "MPCaseLibraryViewController.h"
#import "MPVCTransitionByPop.h"

@interface MPCaseDetailViewController ()<MPCaseDetailDelegate, UINavigationControllerDelegate>
{
    MPCaseDetailView *caseDetailView;
}
@end

@implementation MPCaseDetailViewController

#pragma mark MPBaseViewController overrides

- (void)tapOnLeftButton:(id)sender
{

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.rightButton.hidden = YES;
    
    self.titleLabel.text = self.titleString;
    caseDetailView = [[MPCaseDetailView alloc] initWithFrame:CGRectMake(0,NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
    caseDetailView.delegate = self;
    caseDetailView.caseId = self.case_Id;
    [self.view addSubview:caseDetailView];
    
    [caseDetailView updateCaseDetailData:self.caseModel];
    _hs_uid = self.caseModel.hs_designer_uid;
//    [self initRequestData];
}

//- (void)initRequestData {
//    //[self showHUD];
//
//    NSLog(@"self.case_id:%@",self.case_Id);
//    [MPCaseBaseModel getCaseDetailInfoWithCaseId:self.case_Id success:^(MPCaseModel *caseDetailModel) {
//        [caseDetailView updateCaseDetailData:caseDetailModel];
//        _hs_uid = caseDetailModel.hs_designer_uid;
//       // [weakSelf hideHUD];
//    } failure:^(NSError *error) {
//        [MPAlertView showAlertForNetError];
//       // [weakSelf hideHUD];
//    }];
//}

- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/// 请求结束
- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}


-(void)popViewController {

    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"controller干掉view");

}
- (void)pushTheDetailViewController:(__kindof UIViewController *)controller {
    
    //self.tabBarController.tabBar.hidden = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma MPCaseDescriptionTableViewCellDelegate
- (MPDecorationNeedModel *)getNeedModel {
    return self.needModel;
}

- (NSInteger)getBidderIndex {
    return self.bidderIndex;
}

- (NSString *)getThreadID {
    return self.thread_id;
}

- (void)measureSuccess {
    if (self.success) {
        self.success();
    }
}

- (NSString *)getHs_uid {
    return self.hs_uid;
}
- (UIView *)getControllerView {
    return self.view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPop) {
        return [[MPVCTransitionByPop alloc]init];
    }else {
        return nil;
    }
}
@end
