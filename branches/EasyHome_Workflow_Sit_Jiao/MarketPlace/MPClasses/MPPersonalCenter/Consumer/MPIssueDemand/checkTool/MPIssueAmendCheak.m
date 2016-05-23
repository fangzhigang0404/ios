/**
 * @file    MPIssueAmendCheak.m
 * @brief   the view for no needs.
 * @author  niu
 * @version 1.0
 * @date    2016-02-01
 */

#import "MPIssueAmendCheak.h"

#define SPACE_PATTERN @"^\\s{1,}$"
#define COMMUNITY_PATTERN @"^[A-Za-z0-9\u4e00-\u9fa5]+$"
#define DECIMAL_PATTERN @"^\\d+(\\.\\d+)?$"
#define PHONE_NUM_PATTERN @"1[3|5|7|8|][0-9]{9}"

@implementation MPIssueAmendCheak

+ (void)showAlertViewWithMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle : NSLocalizedString(@"just_tip_tishi", nil)
                                message : message
                               delegate : nil
                      cancelButtonTitle : NSLocalizedString(@"OK_Key", nil)
                      otherButtonTitles : nil];
    [alert show];
}

+ (BOOL)checkContactsName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", SPACE_PATTERN];
    BOOL isMatchName = [predicate evaluateWithObject:name];
    if (name.length < 2 || name.length > 20 || isMatchName) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_tishi_name_message", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkContactsMobile:(NSString *)phoneNumber {
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHONE_NUM_PATTERN];
    BOOL isPhoneNum = [phoneTest evaluateWithObject:phoneNumber];
    if (phoneNumber.length != 11 || !isPhoneNum) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_tishi_phone_message", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkDesignBudget:(NSString *)designBudget {
    if (designBudget.length == 0) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_tishi_design_message", nil)];
        return NO;
    }
    return YES;
}


+ (BOOL)checkRenovationBudget:(NSString *)renovationBudget {
    if (renovationBudget.length == 0) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_tishi_budget_message", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkHouseArea:(NSString *)houseArea {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DECIMAL_PATTERN];
    BOOL isMatch = [predicate evaluateWithObject:houseArea];
    NSArray *array = [houseArea componentsSeparatedByString:@"."];
    NSString *str1 = array[0];
    NSString *str2;
    if (array.count >= 2)
        str2 = array[1];
    
    if (!isMatch || str1.length > 4 || ([str1 integerValue] == 0 && [str2 integerValue] == 0) || str2.length >2) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_tishi_area_message", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkNeighbourhoods:(NSString *)neighbourhoods {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", COMMUNITY_PATTERN];
    BOOL isMatchDetail = [predicate evaluateWithObject:neighbourhoods];
    if (neighbourhoods.length <= 1 || neighbourhoods.length >= 33 || !isMatchDetail) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_tishi_address_message", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkHouseType:(NSString *)houseType {
    if (houseType.length == 0) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_choose_house_type", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkHouseSize:(NSString *)houseSize {
    if (houseSize.length == 0) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_choose_house_size", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkRenovationStyle:(NSString *)renovationStyle {
    if (renovationStyle.length == 0) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_choose_renovation_style", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkAddress:(NSString *)address {
    if (address.length == 0) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_tip_choose_address", nil)];
        return NO;
    }
    return YES;
}

+ (BOOL)checkMeasureTime:(NSString *)measure {
    if (measure == nil) {
        [self showAlertViewWithMessage:NSLocalizedString(@"just_check_measure_time", nil)];
        return NO;
    }
    return YES;
}

@end
