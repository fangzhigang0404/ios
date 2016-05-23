//
//  MPNorthComfortPackageViewController.m
//  MarketPlace
//
//  Created by xuezy on 16/1/19.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPNorthComfortPackageViewController.h"
#import "MPAddressSelectedView.h"
#import "MPQRCodeReader.h"
#import "MPAPI.h"
#import "MBProgressHUD.h"
#import "MPChatRoomViewController.h"
#import "MPRegionManager.h"
#import "MPIssueAmendCheak.h"
#import "MPModel.h"

@interface MPNorthComfortPackageViewController ()<UITextFieldDelegate,MPAddressSelectedDelegate>
@property (copy,nonatomic)NSString *provice;
@property (copy,nonatomic)NSString *city;
@property (copy,nonatomic)NSString *district;
@property (copy,nonatomic)NSString *province_name;
@property (copy,nonatomic)NSString *city_name;
@property (copy,nonatomic)NSString *district_name;
@end

@implementation MPNorthComfortPackageViewController

{
    UITextField *nameTextField;
    UITextField *phoneTextField;
    UITextField *detailAddressTextField;
    UIButton *addressButton;
    
    MPAddressSelectedView *pickView;
    NSDictionary *consumers_informationDict;
    
    UILabel *addressLabel;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:238/255.0 green:241/255.0 blue:244/255.0 alpha:1];

    [self initData];
    [self createView];
    if (self.consumerInformationDict!=nil)
    {
        nameTextField.text = [NSString stringWithFormat:@"%@",self.consumerInformationDict[@"name"]];
        phoneTextField.text = [NSString stringWithFormat:@"%@",self.consumerInformationDict[@"mobile_number"]];
    }

  

    
}

- (void)initData {
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"North Shu package form", nil);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 禁用 iOS7 返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 开启
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)tapOnLeftButton:(id)sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/// 显示开始
- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/// 请求结束
- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)createView {
    UILabel *customerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, NAVBAR_HEIGHT+10, 120, 20)];
    customerLabel.text = NSLocalizedString(@"Customer data_key", nil);
    customerLabel.font = [UIFont systemFontOfSize:18.0];
    [self.view addSubview:customerLabel];
    
    NSArray *titleArray = @[NSLocalizedString(@"beishu_name_key", nil),NSLocalizedString(@"Contact phone number_key", nil),NSLocalizedString(@"Home address_key", nil),NSLocalizedString(@"Address in detail",nil)];
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+40, SCREEN_WIDTH, 200)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.borderWidth = 1;
    backView.layer.borderColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1].CGColor;
    [self.view addSubview:backView];
    
    for (int i=1; i<titleArray.count; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50*i, SCREEN_WIDTH, 0.5)];
        lineView.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
        [backView addSubview:lineView];
    }
    
    for (int i=0; i<titleArray.count; i++) {
        UILabel *viewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, i*50, 70, 50)];
        viewTitleLabel.text = [titleArray objectAtIndex:i];
        //viewTitleLabel.textAlignment = NSTextAlignmentRight;
        viewTitleLabel.font = [UIFont systemFontOfSize:14.0];
        [backView addSubview:viewTitleLabel];
        
        if (i==0) {
            
            nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, backView.frame.size.width-90, 50)];
            nameTextField.delegate = self;
            nameTextField.enabled = NO;
            nameTextField.font = [UIFont systemFontOfSize:14.0];
            NSString *nameString = [NSLocalizedString(@"Name_key", nil) stringByReplacingOccurrencesOfString:@":" withString:@""];
            
            nameTextField.placeholder = nameString;
            
            [backView addSubview:nameTextField];
            
        }else if (i==1) {
            phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 50, backView.frame.size.width-90, 50)];
            phoneTextField.delegate = self;
            phoneTextField.font = [UIFont systemFontOfSize:14.0];
            phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
            NSString *phoneString = [NSLocalizedString(@"Contact phone number_key", nil) stringByReplacingOccurrencesOfString:@"：" withString:@""];
            phoneTextField.placeholder = phoneString;
            
            [backView addSubview:phoneTextField];
        }else if (i==2){
            
            addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 100, backView.frame.size.width-90, 50)];
            addressLabel.text = NSLocalizedString(@"Select address", nil);
            addressLabel.textColor = [UIColor lightGrayColor];
            addressLabel.font = [UIFont systemFontOfSize:14.0];
            [backView addSubview:addressLabel];
            
            addressButton = [UIButton buttonWithType:UIButtonTypeCustom];
            addressButton.frame = CGRectMake(80, 100, backView.frame.size.width-90, 40);
            [addressButton addTarget:self action:@selector(addressClick) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:addressButton];
            
        }else if (i==3) {
            detailAddressTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 150, backView.frame.size.width-90, 50)];
            detailAddressTextField.delegate = self;
            detailAddressTextField.font = [UIFont systemFontOfSize:14.0];
            detailAddressTextField.placeholder = NSLocalizedString(@"Please enter a detailed address", nil);
            [backView addSubview:detailAddressTextField];
        }

    }
    
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(30, NAVBAR_HEIGHT+280, SCREEN_WIDTH-60, 50);
    completeButton.layer.cornerRadius = 5;
    completeButton.backgroundColor =[UIColor colorWithRed:5/255.0 green:132/255.0 blue:255/255.0 alpha:1];
    [completeButton setTitle:NSLocalizedString(@"complete_key", nil) forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton  addTarget:self action:@selector(completeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:completeButton];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];

}

- (void)completeClick {
    [self.view endEditing:YES];

    WS(weakSelf);
    if (![self check]) {
        return;
    }
    
    [self showHUD];

    
    NSDictionary *header = [MPModel getHeaderAuthorization];

    NSLog(@"login in member_id:%@",self.consumerInformationDict);


    NSDictionary *paramDict = @{
                             @"contacts_name":self.consumerInformationDict[@"name"],
                             @"contacts_mobile" :phoneTextField.text,
                             @"province" :self.provice,
                             @"city":self.city,
                             @"district":self.district,
                             @"province_name":self.province_name,
                             @"city_name":self.city_name,
                             @"district_name":self.district_name,
                             @"community_name":detailAddressTextField.text,
                             @"consumer_uid":self.consumerInformationDict[@"hs_uid"]
                             };

    [MPAPI createBeishuWithConsumerId:self.consumerInformationDict[@"member_id"] parmeters:paramDict  withRequestHeader:header success:^(NSDictionary *dict) {
        
        [self hideHUD];
        NSLog(@"result :%@",dict);
        
        NSString *receiverID = self.consumerInformationDict[@"member_id"];
        
        MPMember* memberobj=[AppController AppGlobal_GetMemberInfoObj];
    
        NSString *loggedInUserID = memberobj.acs_member_id;
        NSString *thread_id = dict[@"beishu_thread_id"];
        NSString *asset = dict[@"needs_id"];
        
        [MPAlertView showAlertWithTitle:NSLocalizedString(@"just_create_sucees", nil) message:NSLocalizedString(@"just_order_detail_chack", nil) sureKey:^{
            if ([thread_id isKindOfClass:[NSNull class]]) {
                [MPAlertView showAlertForParameterError];
                return ;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                MPChatRoomViewController* ctrl = [[MPChatRoomViewController alloc] initWithThread:thread_id withReceiverId:receiverID withReceiverName:self.consumerInformationDict[@"name"] withAssetId:asset loggedInUserId:loggedInUserID];
                ctrl.fromQRCode = YES;
                [weakSelf.navigationController pushViewController:ctrl animated:YES];
            });

        } ];

    } failure:^(NSError *error) {
        [self hideHUD];

        NSLog(@"error:%@",error);
    }];
    
    
    
}
- (void)addressClick {
    [nameTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [detailAddressTextField resignFirstResponder];
    
    [self showMyPicker];

    if (pickView==nil) {
        pickView = [[MPAddressSelectedView alloc] initPickview];

    }
    pickView.delegate = self;
    

    [pickView show];

}

- (void)showMyPicker {
    
    [self.view addSubview:self.maskView];
    self.maskView.alpha = 0.4;
    [UIView animateWithDuration:0.3 animations:^{
        pickView.frame = CGRectMake(0, SCREEN_HEIGHT-pickView.frame.size.height, SCREEN_WIDTH, pickView.frame.size.height);
        
    }];
    
}

- (void)hideMyPicker {
    
    self.maskView.alpha = 0 ;
    [UIView animateWithDuration:0.3 animations:^{
        pickView.frame = CGRectMake(0, SCREEN_HEIGHT+pickView.frame.size.height, SCREEN_WIDTH, pickView.frame.size.height);
      
        
        
    } completion:^(BOOL finished) {
        [pickView removeFromSuperview];
       
    }];
    
    
}

#pragma mark MPAddressSelectedDelegate
- (void)selectedAddressinitWithProvince:(NSString *)province withCity:(NSString *)city withTown:(NSString *)town isCertain:(BOOL)isCertain {
    
    [self hideMyPicker];
    if (isCertain) {
        
        NSDictionary *addressDict = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:province withCityCode:city andDistrictCode:town];
        
        NSString *resultString = [NSString stringWithFormat:@"%@ %@ %@",addressDict[@"province"],addressDict[@"city"],addressDict[@"district"]];
        self.provice = province;
        self.city = city;
        self.province_name = [NSString stringWithFormat:@"%@",addressDict[@"province"]];
        self.city_name = [NSString stringWithFormat:@"%@",addressDict[@"city"]];
        
        if ([town isEqualToString:@" "]) {
            self.district_name = @"none";
            self.district = @"0";

        }else {
            self.district = town;

            self.district_name = [NSString stringWithFormat:@"%@",addressDict[@"district"]];

        }

        
        addressLabel.text = resultString;
        addressLabel.textColor = [UIColor blackColor];
        
        
        
    }else{
        
    }
    
}


- (BOOL)check {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle : NSLocalizedString(@"just_tip_tishi", nil)
                          message : nil
                          delegate : nil
                          cancelButtonTitle : NSLocalizedString(@"OK_Key", nil)
                          otherButtonTitles : nil];

    NSString *pattern = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatchName = [pred evaluateWithObject:phoneTextField.text];
    if (phoneTextField.text.length != 11 || !isMatchName) {
        alert.message = NSLocalizedString(@"just_tip_tishi_phone_message", nil);
        [alert show];
        return NO;
    }else if (self.city.length == 0) {
        alert.message = @"请输入正确的地址";
        [alert show];
        return NO;
    } else if (![MPIssueAmendCheak checkNeighbourhoods:detailAddressTextField.text]) {
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == phoneTextField) {
        if (textField.text.length == 11) {
            if ([string isEqualToString:@""] && [string integerValue] == 0) {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [nameTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [detailAddressTextField resignFirstResponder];
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
