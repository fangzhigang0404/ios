//
//  MPWithdrawViewController.m
//  MarketPlace
//
//  Created by Jiao on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPAssetsWithdrawController.h"
#import "MPWithdrawView.h"
#import "MPDesignerBankInfo.h"

@interface MPAssetsWithdrawController ()<MPWithdrawViewDelegate>

@end

@implementation MPAssetsWithdrawController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"MyAssets_withdraw_key", nil);
    
    MPWithdrawView *withdrawView = [[[NSBundle mainBundle] loadNibNamed:@"MPWithdrawView" owner:self options:nil] firstObject];
    withdrawView.delegate = self;
    withdrawView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
    [self.view addSubview:withdrawView];
    [self setUpForDismissKeyboard];
    
    [self showHUD];
    WS(blockSelf);
    [MPDesignerBankInfo getDesignerBankInfo:^(MPDesignerBankInfo *model) {
        BOOL empty = NO;
        if ([model.bank_name isEqualToString:@""]) {
            empty = YES;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf hideHUD];
            [withdrawView updateViewWithDataIsEmpty:empty andModel:model];
        });
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [blockSelf hideHUD];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MPWithdrawViewDelegate Method
- (void)confirmWithModel:(MPDesignerBankInfo *)model {
    

    if ([model.account_user_name isEqualToString:@""]) {
        [MPAlertView showAlertWithMessage:@"持卡人姓名不能为空" sureKey:nil];
    }else if ([model.bank_name isEqualToString:@""] || model.bank_name == nil){
        
        [MPAlertView showAlertWithMessage:@"开户银行不能为空" sureKey:nil];

    }else if ([model.branch_bank_name isEqualToString:@""]) {
        
        [MPAlertView showAlertWithMessage:@"支行名称不能为空" sureKey:nil];

    }else if ([model.deposit_card isEqualToString:@""]) {
        [MPAlertView showAlertWithMessage:@"银行卡号不能为空" sureKey:nil];

    }else {
        WS(blockSelf);
        [self showHUD];
        [MPDesignerBankInfo withdrawWithModel:model withSuccess:^(NSString *str) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf hideHUD];
                [MPAlertView showAlertWithTitle:@"申请成功" message:@"您已成功申请提现\n请在提现记录中查看详情" sureKey:^{
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }];
            });
            
        } withFailure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [blockSelf hideHUD];
                [MPAlertView showAlertWithTitle:@"申请失败" message:@"您已成功申请提现\n请在提现记录中查看详情" sureKey:^{
                    
                }];
            });
            
        }];

    }
    
    
}

#pragma mark - Override MPBaseViewController Method
- (void)tapOnLeftButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Custom Method
- (void)setUpForDismissKeyboard {
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view addGestureRecognizer:singleTapGR];
                }];
    [nc addObserverForName:UIKeyboardWillHideNotification
                    object:nil
                     queue:mainQuene
                usingBlock:^(NSNotification *note){
                    [self.view removeGestureRecognizer:singleTapGR];
                }];
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/// 请求结束
- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
@end
