//
//  MPcreatcontractcellTwo.m
//  MarketPlace
//
//  Created by zzz on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignContractCell.h"
#import "MPDesignContractModel.h"
#import "MPStatusModel.h"
#import "MPAddressSelectedView.h"
#import "MPRegionManager.h"
#import "MPAlertView.h"

@interface MPDesignContractCell ()<UITextFieldDelegate, MPAddressSelectedDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *contract_noLabel;
@property (weak, nonatomic) IBOutlet UITextField *consuer_nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *consumer_mobileLabel;
@property (weak, nonatomic) IBOutlet UITextField *consumer_zipLabel;
@property (weak, nonatomic) IBOutlet UITextField *consumer_emailLabel;
@property (weak, nonatomic) IBOutlet UITextField *consumer_addrLabel;
@property (weak, nonatomic) IBOutlet UITextField *consumer_addrDeLabel;

@property (weak, nonatomic) IBOutlet UILabel *designer_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_zipLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_addrLabel;
@property (weak, nonatomic) IBOutlet UILabel *designer_addrDeLabel;


@property (weak, nonatomic) IBOutlet UITextField *Designesket;
@property (weak, nonatomic) IBOutlet UITextField *Rendering;
@property (weak, nonatomic) IBOutlet UITextField *Cost;
@property (weak, nonatomic) IBOutlet UITextField *Total;
@property (weak, nonatomic) IBOutlet UITextField *Frist;
@property (weak, nonatomic) IBOutlet UILabel *End;

@end

@implementation MPDesignContractCell
{
    MPDesignContractModel * model;
    __weak IBOutlet UIButton *SendBtn;
    IBOutletCollection(UITextField) NSArray *_consumer_textField;
    MPAddressSelectedView *pickView;
    BOOL isDesigner;
}
- (void)awakeFromNib {
    isDesigner = [AppController AppGlobal_GetIsDesignerMode];
    
    model = [[MPDesignContractModel alloc]init];
    self.ReadLab.hidden = YES;
    self.SelectBtn.hidden = YES;

    for (UITextField *tempField in _consumer_textField) {
        tempField.delegate = self;
    }
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tap.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tap];
    
    if (isDesigner) {
        [SendBtn setTitle:@"确认发送" forState:UIControlStateNormal];
//        self.SelectBtn.hidden = YES;
//        self.ReadLab.hidden = YES;
    } else {
        [SendBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        SendBtn.enabled = NO;
//        self.SelectBtn.hidden = NO;
//        self.ReadLab.hidden = NO;
        
        for (UITextField *tempField in _consumer_textField) {
            tempField.borderStyle = UITextBorderStyleNone;
            [tempField setEnabled:NO];
        }
    }
}

- (void)updateCellForIndex:(NSInteger)index {
    if ([self.deleage respondsToSelector:@selector(updateCell)] && [self.deleage updateCell]) {
        MPDesignContractModel *contractModel = [self.deleage updateCell];
        model.measurement_fee = contractModel.measurement_fee;

        self.consumer_mobileLabel.text = [self judgeNULL:contractModel.consumer_mobile];
        self.consumer_zipLabel.text = [self judgeNULL:contractModel.consumer_zipCode];
        self.consumer_emailLabel.text = [self judgeNULL:contractModel.consumer_email];
        self.consumer_addrLabel.text = [self judgeNULL:contractModel.consumer_addr];
        self.consumer_addrDeLabel.text = [self judgeNULL:contractModel.consumer_addrDe];
        
        
        model.contract_no = [self judgeNULL:contractModel.contract_no];
        self.contract_noLabel.text = [NSString stringWithFormat:@"合同编号 : %@",[self judgeNULL:contractModel.contract_no]];
        self.designer_nameLabel.text = [self judgeNULL:contractModel.designer_name];
        self.designer_mobileLabel.text = [self judgeNULL:contractModel.designer_mobile];
        self.designer_emailLabel.text = [self judgeNULL:contractModel.designer_email];
        self.designer_addrLabel.text = [self judgeNULL:contractModel.consumer_addr];
        self.designer_addrDeLabel.text = [self judgeNULL:contractModel.consumer_addrDe];
        
        if (!contractModel.isNew) {
            
            self.consuer_nameLabel.text = [self judgeNULL:contractModel.consumer_name];
            self.Designesket.text = contractModel.design_sketch;
            self.Rendering.text = contractModel.render_map;
            self.Cost.text = [self moneyFormat:contractModel.design_sketch_plus];
            self.Total.text = [self moneyFormat:contractModel.contract_charge];
            self.Frist.text = [self moneyFormat:contractModel.contract_first_charge];
            self.End.text = [self moneyFormat:contractModel.balance_payment];
        }
    }
    
    if ([self.deleage respondsToSelector:@selector(updateCellUI)]) {
        
        MPStatusDetail *statusDetail = [self.deleage updateCellUI];
        SendBtn.hidden = !statusDetail.selectShow;
//        SendBtn.enabled = statusDetail.selectShow;
//        self.SelectBtn.hidden = !statusDetail.selectShow;
//        self.ReadLab.hidden = !statusDetail.selectShow;
        if (isDesigner) {
            SendBtn.enabled = YES;
            SendBtn.backgroundColor = COLOR(0, 132, 255, 1);
            for (UITextField *tempField in _consumer_textField) {
                tempField.borderStyle = statusDetail.selectShow ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
                [tempField setEnabled: statusDetail.selectShow ? YES : NO];
            }
        }else {
            self.SelectBtn.hidden = !statusDetail.selectShow;
            self.ReadLab.hidden = !statusDetail.selectShow;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.Cost || textField == self.Total || textField == self.Frist) {
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
    }else if (textField == self.consumer_zipLabel) {
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        if (self.consumer_zipLabel.text.length > 5) {
            if ([string isEqualToString:@""] && [string integerValue] == 0) {
                return YES;
            }
            return NO;
        }
    }else if (textField == self.consumer_mobileLabel) {
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        if (textField.text.length == 11) {
            if ([string isEqualToString:@""] && [string integerValue] == 0) {
                return YES;
            }
            return NO;
        }
    }

    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

- (IBAction)SendBtn:(UIButton *)sender {
    WS(blockSelf);
    if ([self.consuer_nameLabel.text isEqualToString:@""]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入甲方姓名" sureKey:^{
            [blockSelf.consuer_nameLabel becomeFirstResponder];
        }];
        return;
    }
    if ([self.consumer_mobileLabel.text isEqualToString:@""] || ![self validatePhone:self.consumer_mobileLabel.text]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入甲方手机号" sureKey:^{
            [blockSelf.consumer_mobileLabel becomeFirstResponder];
        }];
        return;
    }
    if (![self.consumer_zipLabel.text isEqualToString:@""] && self.consumer_zipLabel.text.length < 6) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入甲方邮编" sureKey:^{
            [blockSelf.consumer_zipLabel becomeFirstResponder];
        }];
        return;
    }
    if (![self.consumer_emailLabel.text isEqualToString:@""] && ![self validateEmail:self.consumer_emailLabel.text]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入甲方电子邮箱" sureKey:^{
            [blockSelf.consumer_emailLabel becomeFirstResponder];
        }];
        return;
    }
    if ([self.consumer_addrLabel.text isEqualToString:@""]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入甲方装修地址" sureKey:^{
            [blockSelf.consumer_addrLabel becomeFirstResponder];
        }];
        return;
    }
    if ([self.consumer_addrDeLabel.text isEqualToString:@""]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入甲方详细地址" sureKey:^{
            [blockSelf.consumer_addrDeLabel becomeFirstResponder];
        }];
        return;
    }
    if ([self.Designesket.text isEqualToString:@""]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入效果图张数" sureKey:^{
            [blockSelf.Designesket becomeFirstResponder];
        }];
        return;
    }
    if ([self.Rendering.text isEqualToString:@""]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入渲染图张数" sureKey:^{
            [blockSelf.Rendering becomeFirstResponder];
        }];
        return;
    }
    if ([self.Cost.text isEqualToString:@""]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入每增加一张效果图费用" sureKey:^{
            [blockSelf.Cost becomeFirstResponder];
        }];
        return;
    }
    if ([self.Total.text isEqualToString:@""]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入本项目设计费总额" sureKey:^{
            [blockSelf.Total becomeFirstResponder];
        }];
        return;
    }
    if ([self.Frist.text isEqualToString:@""] || [self.Frist.text floatValue] > [self.Total.text floatValue]) {
        [MPAlertView showAlertWithTitle:@"提示" message:@"请正确输入设计首款" sureKey:^{
            [blockSelf.Frist becomeFirstResponder];
        }];
        return;
    }
    
    float first_charge = [self.Total.text floatValue] * 0.8;
    if ([self.Frist.text floatValue] < first_charge) {
        
        [MPAlertView showAlertWithTitle:@"提示" message:@"首款金额不能低于设计费总额的80%" sureKey:^{
            [blockSelf.Frist becomeFirstResponder];
        }];
        return;
    }
    
    if ([self.Frist.text floatValue] <= [model.measurement_fee floatValue]) {
        NSString *alertMsg = [NSString stringWithFormat:@"首款金额应大于量房费用 %@ 元",model.measurement_fee];
        [MPAlertView showAlertWithTitle:@"提示" message:alertMsg sureKey:^{
            [blockSelf.Frist becomeFirstResponder];
        }];
        return;
    }
 
    model.consumer_name = self.consuer_nameLabel.text;
    model.consumer_mobile = self.consumer_mobileLabel.text;
    model.consumer_zipCode = self.consumer_zipLabel.text;
    model.consumer_email = self.consumer_emailLabel.text;
    model.consumer_addr = self.consumer_addrLabel.text;
    model.consumer_addrDe = self.consumer_addrDeLabel.text;
    
    model.design_sketch = self.Designesket.text;
    model.render_map = self.Rendering.text;
    model.design_sketch_plus = self.Cost.text;
    model.contract_charge = self.Total.text;
    model.contract_first_charge = self.Frist.text;
    model.balance_payment = self.End.text;
    
    [self.deleage Sendbtn:model];
   
}
//手机号
- (BOOL)validatePhone:(NSString *)phone
{
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phone];
}
//邮箱
- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (IBAction)contractDetail:(id)sender {
    model.design_sketch = self.Designesket.text;
    model.render_map = self.Rendering.text;
    model.design_sketch_plus = self.Cost.text;
    model.contract_charge = self.Total.text;
    model.contract_first_charge = self.Frist.text;
    model.balance_payment = self.End.text;
    [self.deleage detailsBtn:model];
}

- (IBAction)clickReadBtn:(id)sender {
    self.SelectBtn.selected = !self.SelectBtn.selected;
    BOOL flag = self.SelectBtn.selected;
    SendBtn.enabled = flag;
    SendBtn.backgroundColor = flag ? COLOR(0, 132, 255, 1) : COLOR(153, 153, 153, 1);
    
}

#pragma --------Keybord UP Down-----------------------------
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.consumer_addrLabel) {
        [self endEditing:YES];
        CGRect frame = [textField convertRect:textField.bounds toView:nil];
        if (frame.origin.y > SCREEN_HEIGHT - 256) {
            [self.deleage addrY:frame.origin.y - SCREEN_HEIGHT + 256 + frame.size.height + 15];
        }
        
        if (pickView==nil) {
            pickView = [[MPAddressSelectedView alloc] initPickview];
            
        }
        pickView.delegate = self;
        [UIView animateWithDuration:0.4f delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            pickView.frame = CGRectMake(0, SCREEN_HEIGHT-pickView.frame.size.height, SCREEN_WIDTH, pickView.frame.size.height);
        } completion:nil];

//        CGRect frame = pickView.frame;
        [pickView show];
        return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    CGRect frame = [textField convertRect:textField.bounds toView:nil];
    if ([self.deleage respondsToSelector:@selector(textFieldFrame:)]) {
        [self.deleage textFieldFrame:frame];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    if (textField == self.Total) {
        float first_charge = [self.Frist.text floatValue];
//        self.Frist.text = [NSString stringWithFormat:@"%.2f",first_charge];
        float end = [self.Total.text floatValue] - first_charge;
        self.End.text = [NSString stringWithFormat:@"%.2f",end];
    }
    if (textField == self.Frist) {
        float end = [self.Total.text floatValue] - [self.Frist.text floatValue];
        self.End.text = [NSString stringWithFormat:@"%.2f",end];
    }
    
    if (textField == self.consumer_addrDeLabel) {
        self.designer_addrDeLabel.text = self.consumer_addrDeLabel.text;
    }
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tap1 {
    [self endEditing:YES];
}

- (NSString *)moneyFormat:(NSString *)num {
    NSString *string = [NSString stringWithFormat:@"%.2f",[num floatValue]];
    return string;
}

- (NSString *)judgeNULL:(NSString *)str {
    NSMutableString *resultStr = [NSMutableString stringWithString:str];
    [resultStr replaceOccurrencesOfString:@"(null)" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultStr.length)];
    [resultStr replaceOccurrencesOfString:@"<null>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultStr.length)];
    [resultStr replaceOccurrencesOfString:@"null" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultStr.length)];
    return resultStr;
}

#pragma mark - MPAddressSelectedDelegate
- (void)selectedAddressinitWithProvince:(NSString *)province withCity:(NSString *)city withTown:(NSString *)town isCertain:(BOOL)isCertain {
    
    if (isCertain) {
        
        NSDictionary *addressDict = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:province withCityCode:city andDistrictCode:town];
        
        NSString *resultString = [NSString stringWithFormat:@"%@%@%@",addressDict[@"province"],addressDict[@"city"],addressDict[@"district"]];
        
        self.consumer_addrLabel.text = resultString;
        self.designer_addrLabel.text = resultString;
        [UIView animateWithDuration:0.75f delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            pickView.frame = CGRectMake(0, SCREEN_HEIGHT+pickView.frame.size.height, SCREEN_WIDTH, pickView.frame.size.height);
        } completion:^(BOOL finished) {
            [pickView removeFromSuperview];
        }];
        
    }else{
        [UIView animateWithDuration:0.75f delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
            pickView.frame = CGRectMake(0, SCREEN_HEIGHT+pickView.frame.size.height, SCREEN_WIDTH, pickView.frame.size.height);
        } completion:^(BOOL finished) {
            [pickView removeFromSuperview];
        }];
    }
    
}

@end
