//
//  MPDesignerDetails.m
//  MarketPlace
//
//  Created by zzz on 15/12/29.
//  Copyright © 2015年 xuezy. All rights reserved.
//

#import "MPEditDemandViewController.h"
#import "MPChatListViewController.h"
#import "MBProgressHUD.h"
#import "MPAPI.h"
#import "MPBiddingDetailView.h"
@interface MPEditDemandViewController ()<UIAlertViewDelegate,MPBiddingDetailDelegate>
{
    
    
    MPBiddingDetailView *_biddingDetailView;
}
@end

@implementation MPEditDemandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        /// Set tabr attribute。
    self.isRealName = NO;
    
//    if ([self.type isEqualToString:@"mark"]) {
//        self.titleLabel.text = NSLocalizedString(@"mark_detail_key", @"");
//        
//    }else {
//        self.titleLabel.text = NSLocalizedString(@"Requirements_details_key", @"");
//        
//    }
    self.rightButton.hidden = YES;
    self.markModel = [[MPMarkHallModel alloc] init];
    

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapview:)];
    [self.view addGestureRecognizer:tap];
    
    [self createBiddingDetailView];
    [self initUpData];

}

- (void)createBiddingDetailView {
    
    _biddingDetailView = [[MPBiddingDetailView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _biddingDetailView.type = self.type;
    _biddingDetailView.biddingStaus = self.biddingStaus;
    _biddingDetailView.delegate = self;
    [self.view addSubview:_biddingDetailView];
}

- (void)initUpData {
    
    
    [self showHUD];
  
    [MPMarkHallModel createMarkDetailWithNeedId:self.needs_id success:^(MPMarkHallModel *model) {
        
        
        self.markModel = model;
        self.titleLabel.text = self.markModel.neighbourhoods;

        
        [self hideHUD];
      //  [self initUI];

//        [tabview reloadData];
        [_biddingDetailView refreshBiddingViewUI];
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [self hideHUD];

    }];
    
       
}
/// 显示开始
- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/// 请求结束
- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}




- (void)cancelClick {
    NSLog(@"cancle mark designer");
    
    
}
- (void)touch{
    
//    WS(weakSelf);
//    [MPAlertView showAlertWithMessage:@"是否确定应标?" sureKey:^{
        [self designerMarkMethods];
//    } cancelKey:nil];
}

/// Verify whether the designer has real name authentication.
- (void)designerMarkMethods {
    [self showHUD];
    
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    
    NSDictionary *header = [MPMarkHallModel getHeaderAuthorizationHsUid];
    [MPAPI createDesignerRealNameWithDesignerId:member.member_id withRequestHeader:header success:^(NSDictionary *dict) {
        NSString *realNameString = [NSString stringWithFormat:@"%@",[dict[@"designer"] objectForKey:@"is_real_name"]];
        
        NSLog(@"is real name:%@",dict);
        if ([realNameString isEqualToString:@"2"]) {
            [self createMark:YES];
        }else{
            [self createMark:NO];
            
        }
        
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [self createMark:NO];
        
        
    }];
    
}

/**
 * @brief Designer should mark.
 *
 * @param real NO:Designer not certified YES:Already certified.
 *
 * @return void.
 */
-(void)createMark:(BOOL)real {
    

    if (real == YES) {

//        NSDictionary *headerDict = [NSDictionary dictionaryWithObjectsAndKeys:[userDefaults objectForKey:@"xsession"],@"xsession",@"application/json",@"Content-Type",@"designer",@"role", nil];
        
        
        
        if ([self.markModel.bidder_count integerValue]>=5) {
            [MPAlertView showAlertWithMessage:@"应标人数已满，目前无法应标" sureKey:^{
                
            }];
            [self hideHUD];

        }else {
            MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
            NSMutableDictionary *header = [[MPMarkHallModel getHeaderAuthorization] mutableCopy];
            [header setObject:@"application/json" forKey:@"Content-Type"];
            header = [header copy];

            WS(weakSelf);
            [MPAPI createDesignerBiddingMarkWithNeedId:self.needs_id withDesignerId:member.member_id withParameters:@{@"declaration":@"",@"user_name":member.nick_name} withRequestHeader:header success:^(NSDictionary *dict) {
                
                [weakSelf hideHUD];
                
                [MPAlertView showAlertWithMessage:@"应标成功" sureKey:nil];
            
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"error:%@",error);
                [weakSelf hideHUD];
                if (((NSHTTPURLResponse *)task.response).statusCode == 400) {
                    [MPAlertView showAlertWithMessage:@"该项目无法再次应标" sureKey:nil];
                } else {
                    [MPAlertView showAlertWithMessage:@"应标失败" sureKey:nil];
                }
            }];
        }
        
    }else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"just_tip_tishi", nil) message:@"未实名认证，不能应标，请先认证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还尚未完成实名认证!" message:@"请先到个人中心完成实名认证" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"立即验证", nil];
//
//        [alertView show];
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
   
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }
}

- (void)tapview:(UITapGestureRecognizer *)tap{
    
    
    [self.view endEditing:YES];
}


- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (MPMarkHallModel *)getBiddingModel {
    
    return self.markModel;
}
- (void)selectBiddingMothds {
    
    [self touch];
}
- (void)refuseBiddingMothds {
    [self cancelClick];
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

@end
