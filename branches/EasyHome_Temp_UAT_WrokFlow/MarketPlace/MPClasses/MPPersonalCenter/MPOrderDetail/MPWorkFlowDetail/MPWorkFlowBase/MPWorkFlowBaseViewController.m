/**
 * @file    MPWorkFlowBaseViewController.h
 * @brief   base viewController for wrokflow.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-23
 *
 */

#import "MPWorkFlowBaseViewController.h"

@interface MPWorkFlowBaseViewController ()

@end

@implementation MPWorkFlowBaseViewController

//- (MPStatusModel *)statusModel {
//    if (_statusModel == nil) {
//        _statusModel = [[MPStatusModel alloc]init];
//    }
//    return _statusModel;
//}
//- (MPStatusDetail *)statusDetail {
//    if (_statusDetail == nil) {
//        _statusDetail = [[MPStatusDetail alloc]init];
//    }
//    return _statusDetail;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = COLOR(233, 238, 242, 1);
}

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
