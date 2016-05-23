//
//  MPPayMentViewController.m
//  MarketPlace
//
//  Created by zzz on 16/2/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPPayMentViewController.h"
#import "MPPaymentModel.h"


@interface MPPayMentViewController ()<MPPayViewDelegate>

@end

@implementation MPPayMentViewController
{
    MPPayView *_mpPayView;
    MPPayType _payType;
    UIView *_tempView;
    MPPaymentModel *_curPaymentModel;
}

- (instancetype)initWithPayType:(MPPayType)type {
    self = [super init];
    if (self) {
        _payType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        self.titleLabel.text = @"支付详情";
    }else {
        self.titleLabel.text = @"我要支付";
    }
    
    self.rightButton.hidden = YES;
    [self initPayViewWithType:_payType];
}

- (void)initPayViewWithType:(MPPayType)type {
    WS(blockSelf);
    _tempView = [[UIView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    [self.view addSubview:_tempView];
    _mpPayView = [[MPPayView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    
    _mpPayView.delegate = self;
    [MBProgressHUD showHUDAddedTo:_tempView animated:YES];
    
    [MPStatusMachine getCurrentStatusWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id andSuccess:^(MPStatusModel *statusModel) {
        
        ///获取设计师信息
        [MPPaymentModel getDesignerInformationWithDesignerID:blockSelf.statusModel.designer_id withHSUID:statusModel.hs_uid withSuccess:^(NSString *realName, NSString *mobile, NSString *email) {
            
            blockSelf.statusDetail = [[MPStatusMachine getCurrentStatusMessageWithCurNodeID:statusModel.workFlowModel.wk_cur_sub_node_id] objectAtIndex:[blockSelf getMessageByType:type]];
            blockSelf.statusModel = statusModel;
            blockSelf.statusModel.designer_mobile = mobile;
            blockSelf.statusModel.designer_realName = realName;
            blockSelf.statusModel.designer_email = email;
            _mpPayView.type = type;
            
            [MPPaymentModel getPaymentDetailWithType:type andWKOrderModel:statusModel.wk_orders withSuccess:^(MPPaymentModel *model) {
                _curPaymentModel = model;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:_tempView animated:YES];
                    [_tempView removeFromSuperview];
                    [blockSelf.view addSubview:_mpPayView];
                    [_mpPayView refreshPayView];
                });
            } andFailure:^(NSError *error) {
                NSString *message = @"支付--获取支付信息失败";
                 MPLog(@"%@",error.description);
                [blockSelf failureAlert:message];
            }];

        } andFailure:^(NSError *error) {

            NSString *message = @"支付--获取设计师资料失败";
            MPLog(@"%@",error.description);
            [blockSelf failureAlert:message];
        }];  
    } andFailure:^(NSError *error) {

        NSString *message = @"支付--获取当前订单信息失败";
        MPLog(@"%@",error.description);
        [blockSelf failureAlert:message];
    }];
}

- (void)failureAlert:(NSString *)message {
    WS(blockSelf)
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:_tempView animated:YES];
        [_tempView removeFromSuperview];
        [MPAlertView showAlertWithMessage:message sureKey:^{
            [blockSelf.navigationController popViewControllerAnimated:YES];
        }];
    });
}

- (NSInteger)getMessageByType:(MPPayType)type {
    NSInteger index;
    switch (type) {
        case MPPayForMeasure:
            index = 1;
            break;
        case MPPayForContractFirst:
            index = 3;
            break;
        case MPPayForContractLast:
            index = 4;
            break;
        default:
            break;
    }
    return index;
}
- (void)tapOnLeftButton:(id)sender{
    if (self.fromVC) {
        [self.navigationController popToViewController:self.fromVC animated:YES];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (MPStatusModel *)updateCellData {
    return self.statusModel;
}

- (MPStatusDetail *)updateCellUI {
    return self.statusDetail;
}

- (void)goToAlipay {
    WS(blockSelf);
    [MPPaymentModel payBackWithModel:_curPaymentModel andBlock:^(NSString *code) {
        if ([code isEqualToString:@"9000"]) {
            [MPAlertView showAlertWithMessage:@"支付成功！" sureKey:^{
                if (blockSelf.fromVC) {
                    [blockSelf.navigationController popToViewController:blockSelf.fromVC animated:YES];
                }else {
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }else {
            [MPAlertView showAlertWithMessage:@"支付失败！" sureKey:^{
                if (blockSelf.fromVC) {
                    [blockSelf.navigationController popToViewController:blockSelf.fromVC animated:YES];
                }else {
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
 
    }];
    
}
@end
