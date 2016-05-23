/**
 * @file    MPCaseLibraryDetailViewController.m
 * @brief   caseDetailViewController.
 * @author  Xue.
 * @version 1.0.
 * @date    2016-2-20.
 */

#import "MPCaseLibraryDetailViewController.h"
#import "MPCaseLibraryDetailView.h"
#import "UIImageView+WebCache.h"
#import "MPCaseDetailViewController.h"
#import "MPCaseModel.h"
#import "MPVCTransitionByPush.h"
#import "MPCaseBaseModel.h"

@interface MPCaseLibraryDetailViewController ()<MPCaseLibraryDetailViewDelegate, UINavigationControllerDelegate>
{
    MPCaseLibraryDetailView *_caseView;
    MPCaseModel *_caseModel;
    
    CGFloat _lastX;
    MPCaseModel *_lastModel;
    
    NSInteger _imageCount;
}
@end

@implementation MPCaseLibraryDetailViewController

#pragma mark MPBaseViewController overrides

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    self.navigationController.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.rightButton.hidden = YES;
    
//    [self initData];
    [self initRequestData];
}
- (void)initRequestData {
    //[self showHUD];
    
    [MPCaseBaseModel getCaseDetailInfoWithCaseId:self.case_id success:^(MPCaseModel *caseDetailModel) {
//        [caseDetailView updateCaseDetailData:caseDetailModel];
//        _hs_uid = caseDetailModel.hs_designer_uid;
        
        _caseModel = caseDetailModel;
        _imageCount = _caseModel.images.count;
        
        [self createCaseView];

    } failure:^(NSError *error) {
        [MPAlertView showAlertForNetError];
        // [weakSelf hideHUD];
    }];
}

- (void)initData {
    _caseModel = self.arrayDS[self.index];
    _imageCount = _caseModel.images.count;
}


- (void)createCaseView {
    _caseView = [[MPCaseLibraryDetailView alloc] initWithFrame:CGRectMake(0,NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
    _caseView.backgroundColor = [UIColor yellowColor];
    _caseView.delegate = self;
    [self.view addSubview:_caseView];
    
    self.titleLabel.text = _caseModel.title;
    [_caseView refreshCaseLibraryDetailUI:_caseModel.designer_info.avatar];
}

#pragma mark - CaseDetailCollectionViewDelegate
- (NSInteger)getCaseDetailCellCount {
    return _imageCount;
}

- (void)viewCaseDetail{
    NSLog(@"设计详情");
    MPCaseDetailViewController *detail = [[MPCaseDetailViewController alloc] init];
    detail.case_Id = _caseModel.case_id;
    detail.titleString = _caseModel.title;
    detail.needModel = self.needModel;
    detail.bidderIndex = self.bidderIndex;
    detail.thread_id = self.thread_id;
    detail.success = self.success;
    detail.hs_uid = self.hs_uid;
    detail.caseModel = _caseModel;
    [self.navigationController pushViewController:detail animated:YES];
    
  
}

- (void)draggingWithContentOffsetX:(CGFloat)x {
    _lastX = x;
}

- (void)deceleratingWithContentOffsetX:(CGFloat)x {
    if (_lastX == x) {
        NSLog(@"未滑过去");
    } else {
        NSLog(@"过去了");
    }
}

#pragma mark - MPCaseDetailCollectionViewCellDelegate
- (MPCaseImageModel *)getCaseLibraryDetailModelForIndex:(NSUInteger) index {
    if (_imageCount)
        return [_caseModel.images objectAtIndex:index];
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)getControllerView {
    return self.view;
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
    if (operation == UINavigationControllerOperationPush) {
        return [[MPVCTransitionByPush alloc]init];
    }else {
        return nil;
    }
}
@end
