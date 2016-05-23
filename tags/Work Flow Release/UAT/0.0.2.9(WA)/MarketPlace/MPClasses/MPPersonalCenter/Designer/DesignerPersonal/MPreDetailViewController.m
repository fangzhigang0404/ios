/**
 * @file    MPreDetailViewController.m
 * @brief   the view of MPreDetailViewController view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPreDetailViewController.h"
#import "MPAPI.h"
#import "AppController.h"
#import "MPcerficationInformationModel.h"
@interface MPreDetailViewController ()
{
    NSArray *array;
    NSArray *pathArray;
}
@end
@implementation MPreDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)tapOnLeftButton:(id)sender
{
    
    NSNotification *notification =[NSNotification notificationWithName:@"creat" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"MPreDetailViewController lounch");

    self.view.backgroundColor = [UIColor whiteColor];
    //self.tabBarController.tabBar.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"Literature review_key", nil);
    self.rightButton.hidden = YES;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(60 + 48, 100 + 24, 52, 1)];
    leftView.backgroundColor = [UIColor colorWithRed:(248.0 / 255.0) green:(247.0 / 255.0) blue:(248.0 / 255.0) alpha:1];
    [self.view addSubview:leftView];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(160 + 48, 100 + 24, 52, 1)];
    rightView.backgroundColor = [UIColor colorWithRed:(248.0 / 255.0) green:(247.0 / 255.0) blue:(248.0 / 255.0) alpha:1];
    [self.view addSubview:rightView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 100, 48, 48)];
    UILabel *tishiLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 110+48, 80, 20)];
    tishiLabel.text = NSLocalizedString(@"Submit information_key", nil);
    tishiLabel.textColor = [UIColor orangeColor];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 24.0;
    label.text = @"1";
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:30];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor orangeColor];
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 100, 48, 48)];
    UILabel *adumitLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 110+48, 90, 20)];
    adumitLabel.text = NSLocalizedString(@"The information in the audit_key", nil);
    adumitLabel.textColor = [UIColor grayColor];
    centerLabel.layer.masksToBounds = YES;
    centerLabel.layer.cornerRadius = 24.0;
    centerLabel.text = @"2";
    centerLabel.font = [UIFont systemFontOfSize:30];
    centerLabel.textColor = [UIColor whiteColor];

    centerLabel.textAlignment = NSTextAlignmentCenter;
    centerLabel.backgroundColor = [UIColor grayColor];
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 100, 48, 48)];
    UILabel *passLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 110+48, 80, 20)];
    passLabel.text = NSLocalizedString(@"review approved_key", nil);
    passLabel.textColor = [UIColor grayColor];
    rightLabel.layer.masksToBounds = YES;
    rightLabel.layer.cornerRadius = 24.0;
    rightLabel.text = @"3";
    rightLabel.font = [UIFont systemFontOfSize:30];
    rightLabel.textColor = [UIColor whiteColor];

    rightLabel.textAlignment = NSTextAlignmentCenter;

    rightLabel.backgroundColor = [UIColor grayColor];
    
    UILabel *admitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 260, SCREEN_WIDTH, 20)];
    admitLabel.text = NSLocalizedString(@"Data has been sent_key", nil);
    admitLabel.textAlignment = NSTextAlignmentCenter;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 200, 60, 30)];
    [self.view addSubview:button];
    [self.view addSubview:label];
    [self.view addSubview:centerLabel];
    [self.view addSubview:rightLabel];
    [self.view addSubview:admitLabel];
    [self.view addSubview:tishiLabel];
    [self.view addSubview:adumitLabel];
    [self.view addSubview:passLabel];
    if (SCREEN_WIDTH < 321) {
        label.frame = CGRectMake(20+20, 100, 48, 48);
        centerLabel.frame = CGRectMake(120+20, 100, 48, 48);
        rightLabel.frame = CGRectMake(220+20, 100, 48, 48);
        rightView.frame = CGRectMake(120 + 48+20, 100 + 24, 52, 1);
        leftView.frame = CGRectMake(20 + 48+20, 100 + 24, 52, 1);
        tishiLabel.frame = CGRectMake(50-20, 110+48, 80, 20);
        adumitLabel.frame = CGRectMake(150-20, 110+48, 90, 20);
        passLabel.frame = CGRectMake(250-20, 110+48, 80, 20);
    }
    if ([self.audit_status isEqualToString:@"0"]) {
        admitLabel.text = NSLocalizedString(@"Information is under review_key", nil);
        centerLabel.backgroundColor = [UIColor orangeColor];
        adumitLabel.textColor = [UIColor orangeColor];
    }else if([self.audit_status isEqualToString:@"2"]){
        rightLabel.backgroundColor = [UIColor grayColor];
    }else if([self.audit_status isEqualToString:@"3"]){
        [self _initUpdata];
    }else if([self.audit_status isEqualToString:@"1"]){
        [self _initUpdata];
    }else {
        [self _initDataaaa];
    }
}
- (void)_initUpdata{
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *memid= member.member_id;
    
    
    NSDictionary *token = [NSDictionary dictionaryWithObjectsAndKeys:member.X_Token,@"X-Token",member.hs_uid,@"hs_uid",nil];
    NSDictionary *param = @{@"real_name":self.zeroTitle,
                            @"mobile_number":self.secondTitle,
                            @"certificate_no":self.fourTitle,
                            @"photo_front_end":self.headDic,
                            @"photo_back_end":self.positiveDic,
                            @"photo_in_hand":self.backDic,
                            @"audit_status":@"0"};
    NSLog(@"param is %@",param);
    [MPcerficationInformationModel updataCerInformation:memid withParam:param withRequestHeard:token withSuccess:^(MPcerficationInformationModel *model) {
        
        NSLog(@"*************SUCCESS***************");
        
    } failure:^(NSError *error) {
        
    }];
//    [[MPAPI shareAPIManager] updataCerInformation:memid withParam:param withRequestHeard:token witSuccess:^(NSDictionary *dict) {
//        NSLog(@"dict is -----------------%@",dict);
//
//    } failure:^(NSError *error) {
//        NSLog(@"error is %@",error);
//
//    }];
    
}
- (void)_initDataaaa {
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *memid= member.member_id;


    NSDictionary *token = [MPModel getHeaderAuthorizationHsUid];

    NSDictionary *param = @{@"real_name":self.zeroTitle,
                            @"mobile_number":self.secondTitle,
                            @"certificate_no":self.fourTitle,
                            @"photo_front_end":self.headDic,
                            @"photo_back_end":self.positiveDic,
                            @"photo_in_hand":self.backDic,
                            @"audit_status":@"0"};
    
    NSLog(@"param is %@",param);
    
//    [MPcerficationInformationModel UploadRealNameAuthenticationWith:memid Withparam:param WithHeader:token withSuccess:^(MPcerficationInformationModel *model) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
    [MPAPI UploadRealNameAuthenticationWith:memid Withparam:param WithHeader:token success:^(NSDictionary *dict) {
        
                NSLog(@"dict is -----------------%@",dict);
                NSString *rzID = [dict objectForKey:@"id"];
                NSLog(@"rzID is ------------%@",rzID);
                NSString *RZID = [NSString stringWithFormat:@"%@",rzID];
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                [userDefaults setValue:RZID forKey:@"RZID"];
                [userDefaults synchronize];
        
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
    
}

@end
