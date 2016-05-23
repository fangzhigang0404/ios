//
//  MPMyProjectInfoViewController.m
//  MarketPlace
//
//  Created by xuezy on 16/3/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMyProjectInfoViewController.h"
#import "MPMyProjectInfoView.h"
#import "MPMeasureDetialController.h"
#import "MPDeliveryController.h"
#import "MPContractViewController.h"

@interface MPMyProjectInfoViewController ()<MPMyProjectInfoViewDelegate>

@end

@implementation MPMyProjectInfoViewController
{
    MPMyProjectInfoView *_myProjectInfoView;
    BOOL _isLoadMore;
    MPProjectInfoType _tempType;

}
- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBar];
    [self initUI];
}

- (void)initBar {
    //self.tabBarController.tabBar.hidden = YES;
    self.menuLabel.hidden = YES;
    self.rightButton.hidden = YES;
//    self.titleLabel.text = NSLocalizedString(@"look_for_key", nil);
    self.titleLabel.text = @"项目资料";
}

- (void)initUI {
    _myProjectInfoView = [[MPMyProjectInfoView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
    _myProjectInfoView.delegate = self;
    [self.view addSubview:_myProjectInfoView];
}




- (void)requestData {
    WS(weakSelf);
    [MPStatusMachine getCurrentStatusWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id andSuccess:^(MPStatusModel *statusModel) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf endRefreshView:_isLoadMore];
            NSInteger tempid = [statusModel.workFlowModel.wk_cur_sub_node_id integerValue];
            switch (tempid) {
                case 11:
                case 12:
                case 13:
                case 14:
                case 21:
                case 22:
                case 31: _tempType = ProjectTypeForMeasureList; break;
                case 33: _tempType = ProjectTypeForMeasureDelivery; break;
                case 41:
                case 42: _tempType = ProjectTypeForContract; break;
                case 51:
                case 52:
                case 61:
                case 62: _tempType = ProjectTypeForDesignDelivery; break;
                    
                default: _tempType = ProjectTypeForNone;break;
            }
            [_myProjectInfoView refreshMyProjectInfoWithType:_tempType];
        });
    } andFailure:^(NSError *error) {
        
        NSLog(@"获取当前状态错误：%@",[NSString stringWithFormat:@"%@",error.description]);
        dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf endRefreshView:_isLoadMore];
        });
    }];
    
}


- (void)didSelectItemWthType:(MPProjectInfoType)type {
    NSLog(@"选择的：%ld",type);
    switch (type) {
        case ProjectTypeForMeasureList: {
            MPMeasureDetialController *vc = [[MPMeasureDetialController alloc]init];
            vc.statusModel = self.statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case ProjectTypeForMeasureDelivery: {
            MPDeliveryController *vc;
//            if ([AppController AppGlobal_GetIsDesignerMode]) {
//                vc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForMeasureSubmit];
//            }else {
                vc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForMeasureView];
//            }
            vc.statusModel = self.statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case ProjectTypeForContract: {
            MPContractViewController *vc = [[MPContractViewController alloc]init];
            vc.fromVC = self;
            vc.statusModel = self.statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case ProjectTypeForDesignDelivery: {
            MPDeliveryController *vc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForDesignView];
            vc.statusModel = self.statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
   
        default:
            break;
    }
}

- (void)myProjectInfoViewRefreshLoadNewData:(void (^)())finish {
    self.refreshForLoadNew = finish;
    _isLoadMore = NO;
    [self requestData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
