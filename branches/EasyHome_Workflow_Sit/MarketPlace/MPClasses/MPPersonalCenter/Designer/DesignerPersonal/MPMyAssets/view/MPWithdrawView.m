//
//  MPWithdrawView.m
//  MarketPlace
//
//  Created by Jiao on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWithdrawView.h"
#import "MPBankPickerView.h"
#import "MPDesignerBankInfo.h"

#define NUM_PAD_DONE_BUTTON_TAG 1001;

@interface MPWithdrawView ()<MPBankPickerViewDelegate, UITextFieldDelegate>

@end
@implementation MPWithdrawView
{
    
    __weak IBOutlet UILabel *designer_amountLabel;
    __weak IBOutlet UILabel *withdraw_amountLabel;
    __weak IBOutlet UITextField *nameTextField;
    __weak IBOutlet UIButton *bankBtn;
    __weak IBOutlet UITextField *subBankNameTextField;
    __weak IBOutlet UITextField *bankCardTextField;
    __weak IBOutlet UIButton *replaceBankCardBtn;
    __weak IBOutlet UIImageView *bankInfoIMG;
    
    __weak IBOutlet UIButton *confirmBtn;
    
    MPBankPickerView *bankPicker;
    UIView *tempView;
    NSString *_tempBankInfo;
}

- (void)awakeFromNib {
    [nameTextField setEnabled:NO];
    [bankBtn setEnabled:NO];
    [subBankNameTextField setEnabled:NO];
    [bankCardTextField setEnabled:NO];
    [replaceBankCardBtn setHidden:YES];
}

- (void)drawRect:(CGRect)rect {
    bankPicker = [[[NSBundle mainBundle] loadNibNamed:@"MPBankPickerView" owner:self options:nil] firstObject];
    bankPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
    bankPicker.delegate = self;
    
    tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tempView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    [self.superview addSubview:tempView];
    [tempView addSubview:bankPicker];
    tempView.hidden = YES;
    
    nameTextField.delegate = self;
    nameTextField.tag = 401;
    
    subBankNameTextField.delegate = self;
    subBankNameTextField.tag = 402;
    
    bankCardTextField.delegate = self;
    bankCardTextField.tag = 403;
    
}

- (IBAction)selectBank:(id)sender {
    [self endEditing:YES];
    tempView.hidden = NO;
    [UIView animateWithDuration:0.3f animations:^{
        bankPicker.frame = CGRectMake(0, SCREEN_HEIGHT - 260, SCREEN_WIDTH, 260);
    }];
}
- (IBAction)replaceBankCard:(id)sender {
    NSLog(@"replace");
    bankCardTextField.text = [self cardIDFormat:_tempBankInfo andSecret:NO];
    [self editBankInfo:YES];
    
}
- (IBAction)confirmAndSubmit:(id)sender {
    NSLog(@"confirm and submit");
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(confirmWithModel:)]) {
        MPDesignerBankInfo *model = [[MPDesignerBankInfo alloc]init];
        model.account_user_name = nameTextField.text;
        model.bank_name = bankBtn.currentTitle;
        model.branch_bank_name = subBankNameTextField.text;
        if (replaceBankCardBtn.hidden == YES) {
        
            model.deposit_card = [self formatStr:bankCardTextField.text];
        }else {
            model.deposit_card = _tempBankInfo;
        }
        
        [self.delegate confirmWithModel:model];
    }
}

#pragma mark - MPBankPickerViewDelegate Method
- (void)closePickView {
    [UIView animateWithDuration:0.3f animations:^{
        bankPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
    }];
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
    }
    
    if (textField.tag == 403) {
        NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if (newString.length >= 20) {
            return NO;
        }
        
        [textField setText:newString];
        return NO;
    }else {
        return YES;
    }

    
}

#pragma mark - Custom Method
- (void)updateViewWithDataIsEmpty:(BOOL)empty andModel:(MPDesignerBankInfo *)model {
    [self editBankInfo:empty];
    designer_amountLabel.text = model.amount;
    withdraw_amountLabel.text = model.amount;
    if (!empty) {
        
        nameTextField.text = model.account_user_name;
        [bankBtn setTitle:model.bank_name forState:UIControlStateNormal];
        subBankNameTextField.text = model.branch_bank_name;
        bankCardTextField.text = [self cardIDFormat:model.deposit_card andSecret:YES];
        _tempBankInfo = model.deposit_card;
        
    }
}

- (void)editBankInfo:(BOOL)flag {
    [nameTextField setEnabled:flag];
    [bankBtn setEnabled:flag];
    [subBankNameTextField setEnabled:flag];
    [bankCardTextField setEnabled:flag];
    
    UITextBorderStyle style = flag ? UITextBorderStyleRoundedRect : UITextBorderStyleNone;
    [nameTextField setBorderStyle:style];
    [subBankNameTextField setBorderStyle:style];
    [bankCardTextField setBorderStyle:style];
    
    [replaceBankCardBtn setHidden:flag];
    [replaceBankCardBtn setEnabled:!flag];
    
    UIEdgeInsets bankInsets = flag ? UIEdgeInsetsMake(0, 6, 0, 0) : UIEdgeInsetsMake(0, 0, 0, 0);
    bankBtn.contentEdgeInsets = bankInsets;
    bankInfoIMG.hidden = !flag;
}

- (void)selectedBankWithName:(NSString *)name {
    [UIView animateWithDuration:0.3f animations:^{
        bankPicker.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260);
    } completion:^(BOOL finished) {
        tempView.hidden = YES;
        [bankBtn setTitle:name forState:UIControlStateNormal];
    }];
    
}

- (NSString *)cardIDFormat:(NSString *)num andSecret:(BOOL)secret {
//    int count = 0;
//    long long int a = num.longLongValue;
//    while (a != 0)
//    {
//        count++;
//        a /= 10;
//    }
//    NSMutableString *string = [NSMutableString stringWithString:num];
//    NSMutableString *newstring = [NSMutableString string];
//    if (num.length > 4) {
//        NSRange rang = NSMakeRange(0, 4);
//        for (int i = 4; i <= num.length; i += 4) {
//
//            NSString *str = [string substringWithRange:rang];
//            [newstring appendString:[NSString stringWithFormat:@"%@ ",str]];
//            [string deleteCharactersInRange:rang];
//        }
//    }else {
//        return @"";
//    }
    NSNumber *number = @([num longLongValue]);
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:4];
    [formatter setGroupingSeparator:@" "];
    NSMutableString *newstring = [NSMutableString stringWithString:[formatter stringFromNumber:number]];
//    [newstring appendString:string];
    if (secret) {
        [newstring replaceCharactersInRange:NSMakeRange(5, 10) withString:@" **** **** "];
    }
        return newstring;
}

- (NSString *)formatStr:(NSString *)string {
    NSMutableString *resultStr = [NSMutableString stringWithString:string];
    [resultStr replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, resultStr.length)];
    return resultStr;
}
@end
