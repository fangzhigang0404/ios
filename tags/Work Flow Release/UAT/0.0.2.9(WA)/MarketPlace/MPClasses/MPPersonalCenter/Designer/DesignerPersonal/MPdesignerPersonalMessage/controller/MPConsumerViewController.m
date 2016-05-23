/**
 * @file    MPConsumerViewController.m
 * @brief   the view of MPConsumerViewController view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPConsumerViewController.h"
#import "MPcerficationViewController.h"
#import "MPMemberModel.h"
#import "MPreDetailViewController.h"
#import "MPdesignerMessageCenterViewController.h"
#import "MPDesignerDetailViewController.h"
#import "MPMyMarkListViewController.h"
#import "MPMyProjectViewController.h"
#import "MPMyAssetsViewController.h"
#import "MPmessageViewController.h"
#import "MPmoreViewController.h"
#import "MPDesignerMemberCenterView.h"
#import "MPQRCodeReader.h"
#import "MPNorthComfortPackageViewController.h"
#import "MPcerficationInformationModel.h"
#import "MPCenterTool.h"
#import "MPQRCodeTool.h"

@interface MPConsumerViewController ()<DesignerMemberCenterViewDelegate>
{
    NSString *avatar;                          //!< head icon string.
    NSString *mobile;                          //!< mobile string.
    NSString *nickname;                        //!< nickName string.
    MPDesignerMemberCenterView *designerView;  //!< desingner center view.
    NSString *audit_status;                    //!< cerficition status.
    NSString *is_loho;                         //!< is loho string.
    MPMemberModel *_model;                     //!< member model.
}
@end

@implementation MPConsumerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self _certification];
    [self _reloadData];
    if (![AppController isHaveNetwork]) {
        [designerView loadInformation];
    }

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
        
    designerView = [[MPDesignerMemberCenterView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    designerView.delegate = self;
    self.leftButton.hidden = YES;
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"Personal Center_key", nil);
    [self.view addSubview:designerView];   
}
- (void)_reloadData {
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *memderid = member.acs_member_id;

    WS(weakSelf);
    [MPMemberModel DesignerInformation:memderid withSuccess:^(MPMemberModel *model) {
        _model = model;
        is_loho = model.is_loho;
        
        [weakSelf memberInfo:memderid];
        
    } failure:^(NSError *error) {
        
        if ([AppController isHaveNetwork]) {
            [MPAlertView showAlertForNetError];
        }
    }];

}

- (void)memberInfo:(NSString *)memderid {
    
    [MPMemberModel MemberInformation:memderid withSuccess:^(MPMemberModel *model) {
        
        NSLog(@"model is %@",model);
        _model.avatar = model.avatar;
        _model.nick_name = model.nick_name;
        
        [MPCenterTool savePersonCenterInfo:_model];
        [designerView reloadData:_model];
        
    } failure:^(NSError *error) {
        if ([AppController isHaveNetwork]) {
            [MPAlertView showAlertForNetError];
        }
    }];
    
}

- (void)_certification {
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *hs_uid = member.hs_uid;
    NSDictionary *token = [NSDictionary dictionaryWithObjectsAndKeys:hs_uid,@"hs_uid",nil];
    
    NSString *memderid = member.acs_member_id;
    NSLog(@"member_id is %@",memderid);
    
    [MPcerficationInformationModel CertificationMemberid:memderid withHeader:token withSuccess:^(MPcerficationInformationModel *model) {
        
        audit_status = model.audit_status;
        
        [MPCenterTool saveAuditStatus:audit_status];
        
        [designerView certification:audit_status];

    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
        if ([AppController isHaveNetwork]) {
            [MPAlertView showAlertForNetError];
        }
    }];
}

-(void) headIconBtnClick:(UIButton *)btn cerficationBtnClick:(UIButton *)btnClick withSection:(NSInteger)section withRow:(NSInteger)row{
    
    if (btnClick) {
        if ([btnClick.titleLabel.text isEqualToString:NSLocalizedString(@"In the review_key", nil)]) {
            MPreDetailViewController *pre = [[MPreDetailViewController alloc] init];
            pre.audit_status = audit_status;
            [self.navigationController pushViewController:pre animated:YES];
        } else {
            MPcerficationViewController *Cer = [[MPcerficationViewController alloc] init];
            Cer.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Cer animated:YES];
        }
    }else if(btn){
        MPdesignerMessageCenterViewController *vc =[[MPdesignerMessageCenterViewController alloc] init];
        [self customPushViewController:vc animated:YES];
        
    }else if (section == 1 && row == 0){
        
        MPDesignerDetailViewController* vc = [[MPDesignerDetailViewController alloc]
                                              initWithIsDesignerCenter:YES
                                              designerInfoModel:nil
                                              isConsumerNeeds:NO
                                              needInfo:nil
                                              needInfoIndex:0];
        
        [self customPushViewController:vc animated:YES];
        
    }else if (section == 1 && row == 1){
        
        if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"The function development_key", nil) sureKey:nil];
        } else {
            MPMyMarkListViewController *vc = [[MPMyMarkListViewController alloc] init];
            vc.is_loho = [is_loho integerValue];
            NSLog(@"is_loho %@",is_loho);
            [self customPushViewController:vc animated:YES];
        }
    }else if (section == 1 && row == 2){
        
        MPMyProjectViewController *vc = [[MPMyProjectViewController alloc] init];
        vc.is_loho = [is_loho integerValue]; ///!< 1 乐屋认证 0未进行乐屋认证.
        vc.audit_status = [audit_status integerValue];
        NSLog(@"%ld",(long)vc.audit_status);
        [self customPushViewController:vc animated:YES];
        
    }else if (section == 1 && row == 3){
        if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"The function development_key", nil) sureKey:nil];
        } else {
            MPMyAssetsViewController * vc = [[MPMyAssetsViewController alloc]init];
            [self customPushViewController:vc animated:YES];
        }
        
    }else if (section == 1 && row == 4){
        if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"The function development_key", nil) sureKey:nil];
        } else {
            MPmessageViewController *meVC = [[MPmessageViewController alloc] init];
            [self customPushViewController:meVC animated:YES];
        }
        
    }else if (section == 1 && row == 5){
        MPmoreViewController * vc = [[MPmoreViewController alloc]init];
        [self customPushViewController:vc animated:YES];
        
    }else if (section == 0 && row == 1){
        MPQRCodeReader *redader = [[MPQRCodeReader alloc] init];
        WS(weakSelf);
        redader.dict = ^(NSDictionary *dict){
            
            if ([dict allKeys].count == 6) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    MPNorthComfortPackageViewController *northVC =[[MPNorthComfortPackageViewController alloc] init];
                    northVC.consumerInformationDict = dict;
                    [weakSelf customPushViewController:northVC animated:NO];//
                });
                
            } else {
                [MPAlertView showAlertWithMessage:NSLocalizedString(@"Qr code format error_key", nil) sureKey:^{
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }];
            }
        };
        
        if ([MPQRCodeTool checkCameraEnable]) {
            [self customPushViewController:redader animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

@end
