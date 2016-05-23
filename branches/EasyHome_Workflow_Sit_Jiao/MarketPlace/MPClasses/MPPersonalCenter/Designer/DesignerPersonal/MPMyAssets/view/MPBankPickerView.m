//
//  MPBankPickerView.m
//  MarketPlace
//
//  Created by Jiao on 16/2/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPBankPickerView.h"

@implementation MPBankPickerView
{

    __weak IBOutlet UIPickerView *bankSelPicker;
    NSMutableArray *dataArray;
    
}
- (void)awakeFromNib {
    bankSelPicker.delegate = self;
    [self initBankPlist];
}

#pragma mark - UIPickerViewDataSource Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return dataArray.count;
}

#pragma mark - UIPickerViewDelegate Method
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [dataArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40.0f;
}

#pragma mark - Custom Method
- (void)initBankPlist {
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *plistPath = [bundle pathForResource:@"BankSelect" ofType:@"plist"];
    dataArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
}
- (IBAction)close:(id)sender {
    if ([self.delegate respondsToSelector:@selector(closePickView)]) {
        [self.delegate closePickView];
    }
}
- (IBAction)done:(id)sender {
    NSInteger row = [bankSelPicker selectedRowInComponent:0];
    NSString *bank = [dataArray objectAtIndex:row];
    if ([self.delegate respondsToSelector:@selector(selectedBankWithName:)]) {
        [self.delegate selectedBankWithName:bank];
    }
}

@end
