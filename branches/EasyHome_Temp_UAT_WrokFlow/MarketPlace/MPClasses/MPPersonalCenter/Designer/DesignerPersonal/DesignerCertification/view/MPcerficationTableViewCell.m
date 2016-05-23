/**
 * @file    MPcerficationTableViewCell.h
 * @brief   the view of cerfication cell view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPcerficationTableViewCell.h"
#import "MPcerficationModel.h"
#import "MPAlertView.h"
@implementation MPcerficationTableViewCell
{
    UIActionSheet *myActionSheet ;
    MPcerficationModel *model;
    BOOL flag;

}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self _creatView];
    self.submit.clipsToBounds = YES;
    self.submit.layer.cornerRadius = 6.0f;
}

- (void)_creatView {
    
    ID_cardTextField.delegate = self;
    nameTextField.delegate = self;
    numberTextField.delegate = self;
    _ID_cardHandheld.tag = 1;
    _ID_cardPositive.tag = 3;
    _ID_cardReverse.tag = 2;
    _submit.tag = 4;
    nameTextField.tag = 5;
    numberTextField.tag = 6;
    ID_cardTextField.tag = 7;
    [_ID_cardHandheld addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_ID_cardPositive addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_ID_cardReverse addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_submit addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (BOOL)verifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

- (BOOL) validateMobile:(NSString *)mobile
{
    
    if (mobile.length <= 0) {
        flag = NO;
        return flag;
    }
    flag = YES;
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    flag = [phoneTest evaluateWithObject:mobile];
    return flag;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textField is %@",textField.text);
    if (textField.tag == 6) {
        [self validateMobile:numberTextField.text];
        
        if (flag == YES) {
            NSLog(@"*******************************SUCESS******************************");
        }else {
            
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"The telephone illegal!_key", nil) sureKey:^{
                
            }];
        }
    }else if (textField.tag == 7) {
        BOOL flagsss = [self verifyIDCardNumber:ID_cardTextField.text];
        
        if (flagsss == YES) {
            NSLog(@"*******************************SUCESS******************************");
        }else {
            
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"Id not legal!_key", nil) sureKey:^{
            }];
        }
    } else if (textField == nameTextField) {
        if (![MPcerficationModel checkName:textField.text]) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"The name cannot be empty_key", nil) sureKey:nil];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == numberTextField) {
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
    [self.contentView endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [ID_cardTextField resignFirstResponder];
    [nameTextField resignFirstResponder];
    [numberTextField resignFirstResponder];
}
- (void)btnClick:(UIButton *)btn {
   
    [self.contentView endEditing:YES];
    [self.delegate Cerfication:nil withBtn:btn];
        
}

@end
