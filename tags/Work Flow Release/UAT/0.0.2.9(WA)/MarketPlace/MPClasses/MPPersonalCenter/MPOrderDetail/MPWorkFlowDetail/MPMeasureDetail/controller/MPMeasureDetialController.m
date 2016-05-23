//
//  MPMeasureDetialController.m
//  MarketPlace
//
//  Created by Jiao on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMeasureDetialController.h"
#import "MPMeasureDetailModel.h"
#import "MPMeasureDetailView.h"
#import "MPPayMentViewController.h"

@interface MPMeasureDetialController ()<MPMeasureDetailViewDelegate>
@property (nonatomic, strong) MPMeasureDetailView *measureDView;
@end

@implementation MPMeasureDetialController
{
    MPStatusModel *_curStatusModel;
    MPStatusDetail *_curStatusDetail;
}

- (instancetype)initWithNeedID:(NSString *)needs_id andDesignerID:(NSString *)designer_id {
    self = [super init];
    if (self) {
        self.statusModel = [[MPStatusModel alloc]init];
        self.statusModel.needs_id = needs_id;
        self.statusModel.designer_id = designer_id;
    }
    return self;
}

- (MPMeasureDetailView *)measureDView {
    if (_measureDView == nil) {
        _measureDView = [[MPMeasureDetailView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
        [self.view addSubview:_measureDView];
    }
    return _measureDView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = NSLocalizedString(@"just_string_measure_table", nil);
    self.rightButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self initUI];
    [self initData];
}

- (void)initUI {
    self.measureDView.delegate = self;
}

- (void)initData {
    WS(blockSelf);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MPStatusMachine getCurrentStatusWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id andSuccess:^(MPStatusModel *statusModel) {
        _curStatusDetail = [[MPStatusMachine getCurrentStatusMessageWithCurNodeID:statusModel.workFlowModel.wk_cur_sub_node_id] firstObject];
        _curStatusModel = statusModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
            [blockSelf initUI];
            [blockSelf.measureDView refreshMeasureDetailView];
        });
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        });
    }];
}

- (void)confirmMeasure {
    WS(blockSelf)
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MPMeasureDetailModel confirmMeasureWithNeedsID:self.statusModel.needs_id andSuccess:^(NSDictionary *dictionary) {
        [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        [MPAlertView showAlertWithMessage:@"确认量房成功！" sureKey:^{
            [blockSelf.navigationController popViewControllerAnimated:YES];
        }];
    } andFaiulre:^(NSError *error) {
        [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        [MPAlertView showAlertWithMessage:@"确认量房失败！" sureKey:^{
            [blockSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)refuseMeasure {
    WS(blockSelf)
    [MPAlertView showAlertWithTitle:@"提示" message:@"是否拒绝量房？" cancelKeyTitle:@"否" rightKeyTitle:@"是" rightKey:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [MPMeasureDetailModel refuseMeasureWithNeedsID:self.statusModel.needs_id andSuccess:^(NSDictionary *dictionary) {
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
            [MPAlertView showAlertWithMessage:@"拒绝量房成功！" sureKey:^{
                [blockSelf.navigationController popViewControllerAnimated:YES];
            }];
        } andFaiulre:^(NSError *error) {
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
            [MPAlertView showAlertWithMessage:@"拒绝量房失败！" sureKey:^{
                [blockSelf.navigationController popViewControllerAnimated:YES];
            }];
        }];
    } cancelKey:nil];
}

- (MPStatusModel *)updateCellData {
    return _curStatusModel;
}

- (MPStatusDetail *)updateCellUI {
    return _curStatusDetail;
}
@end
