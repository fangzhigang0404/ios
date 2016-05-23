/**
 * @file    MPConsumerPersonalCenterViewController.m
 * @brief   the view of MPConsumerCenter view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPConsumerPersonalCenterViewController.h"
#import "MPConsumerPersonelTableViewCell.h"
#import "MPConsumerTableViewCell.h"
#import "MPConsumerCenterView.h"
#import "MPMemberModel.h"
#import "MPmessageViewController.h"
#import "MPHomeViewController.h"
#import "MPmoreViewController.h"
#import "MPDecoListViewController.h"
#import "MPIssueDemandViewController.h"
#import "MPDesignerMessageDetailViewController.h"
#import "MPCenterTool.h"

@interface MPConsumerPersonalCenterViewController ()<MPFindDesignersDelegate>
{
    MPConsumerCenterView *_view;        ///<! MPConsumerCenterView View.
}
@end

@implementation MPConsumerPersonalCenterViewController


-(void)viewWillAppear:(BOOL)animated {

    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    [self _perSonalInformation];
}


/// Request personal information data.

- (void)_perSonalInformation {
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *member_id = member.acs_member_id;
    
    [MPMemberModel MemberInformation:member_id withSuccess:^(MPMemberModel *model) {
        
        [MPCenterTool savePersonCenterInfo:model];
        /// The model to the view shown above.
        [_view reloadData:model];
        
    } failure:^(NSError *error) {

        MPMemberModel *_model = [MPCenterTool getPersonCenterInfo];
        
        [_view reloadData:_model];
        
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    _view = [[MPConsumerCenterView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _view.delegate = self;
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"Personal Center_key", nil);
    [self.view addSubview:_view];
 
}

/// Click on the center of the individual consumers headIcon the method called.
- (void)BtnClickConsumer:(UIButton *)btn {
    
        MPDesignerMessageDetailViewController *vc =[[MPDesignerMessageDetailViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
}

/*
 @section: Which group of tableView.
 @row    : Which line of tableView.
 */
- (void)tableViewSection:(NSInteger)section withTableViewRow:(NSInteger)row {
    if (section == 0 && row == 1) {
        if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"The function development_key", nil) sureKey:nil];
        } else {
            MPIssueDemandViewController *vc = [[MPIssueDemandViewController alloc] initWithType:MPDecorationVCTypeIssue needID:nil refresh:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (section == 1 && row == 0) {
        MPDecoListViewController *vc = [[MPDecoListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:vc animated:YES];
    }else if (section == 1 && row == 1) {

        if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"The function development_key", nil) sureKey:nil];
        } else {
            MPmessageViewController *vc = [[MPmessageViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:vc animated:YES];
        }

    }else if (section == 1 && row == 2) {
        MPmoreViewController *vc = [[MPmoreViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
