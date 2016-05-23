/**
 * @file    MPMyAssetsViewController.m
 * @brief   the frame of MPMyAssetsViewController.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPMyAssetsViewController.h"
#import "MPMyAssetsDetail.h"
#import "MPAssetsWithdrawController.h"
#import "MPDesignerBankInfo.h"
#import "MPAssertsRecordViewController.h"

@interface MPMyAssetsViewController ()<MPMyAssetsDetailDelegate>

@end

@implementation MPMyAssetsViewController
{
    MPMyAssetsDetail *_assetsDetail;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tabBarController.tabBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeBottom;
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"My assets_key", nil);
    
    _assetsDetail = [[[NSBundle mainBundle] loadNibNamed:@"MPMyAssetsDetail" owner:self options:nil] firstObject];
    _assetsDetail.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT);
    _assetsDetail.delegate = self;
    [self.view addSubview:_assetsDetail];
    
}

- (void)viewWillAppear:(BOOL)animated {
    WS(blockSelf);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MPDesignerBankInfo getDesignerBankInfo:^(MPDesignerBankInfo *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_assetsDetail refreshWithAmount:model.amount];
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        });
    } andFailure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        [MPAlertView showAlertForNetError];
    }];
}

#pragma mark - MPMyAssetsDetailDelegate Method
- (void)withdraw {
    MPAssetsWithdrawController *vc = [[MPAssetsWithdrawController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tradeRecord {
    MPAssertsRecordViewController *vc = [[MPAssertsRecordViewController alloc]initWithType:MPAssetsRecordForTrade];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)withdrawRecord {
    MPAssertsRecordViewController *vc = [[MPAssertsRecordViewController alloc]initWithType:MPAssetsRecordForWithdraw];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Override MPBaseViewController Method
- (void)tapOnLeftButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
