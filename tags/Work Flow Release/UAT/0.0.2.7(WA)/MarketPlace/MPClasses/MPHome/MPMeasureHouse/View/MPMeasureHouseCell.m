/**
 * @file    MPMeasureHouseCell.m
 * @brief   the controller of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-22
 */

#import "MPMeasureHouseCell.h"
#import "MPDecorationNeedModel.h"
#import "MPIssueAmendCheak.h"
#import "MPRegionManager.h"
#import "MPMeasureTool.h"
#import "MPAlertView.h"
#import "MPTranslate.h"

@interface MPMeasureHouseCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *statusDesignBudget;
@property (weak, nonatomic) IBOutlet UILabel *statusDecorationBudget;
@property (weak, nonatomic) IBOutlet UILabel *statusHoseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusHouseSizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusRenovationStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusMeasureTime;

@property (weak, nonatomic) IBOutlet UILabel *measurePriceLabel;

@property (weak, nonatomic) IBOutlet UITextField *contactsNameTF;
@property (weak, nonatomic) IBOutlet UITextField *contactsMobileTF;
@property (weak, nonatomic) IBOutlet UITextField *houseAreaTF;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;

@property (weak, nonatomic) IBOutlet UIButton *chooseDesignBudget;
@property (weak, nonatomic) IBOutlet UIButton *chooseRenovationBudget;
@property (weak, nonatomic) IBOutlet UIButton *chooseHouseType;
@property (weak, nonatomic) IBOutlet UIButton *chooseHouseSize;
@property (weak, nonatomic) IBOutlet UIButton *chooseRenovationStyle;
@property (weak, nonatomic) IBOutlet UIButton *chooseAddress;
@property (weak, nonatomic) IBOutlet UIButton *chooseMeasureTime;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIView *viewMiddle;
@property (weak, nonatomic) IBOutlet UIView *viewLow;

@end

@implementation MPMeasureHouseCell
{
    NSString *_houseType;
    
    NSString *_room;
    NSString *_livingRoom;
    NSString *_toilet;
    
    NSString *_renovationStyle;
    
    NSString *_measureTime;

    NSString *_measurePrice;
    
    NSString *_decorationBudget;
    NSString *_designBudget;

    NSString *_designer_id;
    NSString *_hs_uid;
    
    NSString *_province;
    NSString *_city;
    NSString *_district;
    NSString *_province_name;
    NSString *_city_name;
    NSString *_district_name;
    
    BOOL _isBidder;
    NSString *_need_id;
    
    NSString *_thread_id;
    
    CGFloat _kbHeight;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.viewTop.clipsToBounds          = YES;
    self.viewTop.layer.cornerRadius     = 6;
    self.viewTop.layer.borderWidth      = 1;
    self.viewTop.layer.borderColor      = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1].CGColor;
    self.viewMiddle.clipsToBounds       = YES;
    self.viewMiddle.layer.cornerRadius  = 6;
    self.viewTop.layer.borderWidth      = 1;
    self.viewTop.layer.borderColor      = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1].CGColor;
    self.viewLow.clipsToBounds          = YES;
    self.viewLow.layer.cornerRadius     = 6;
    self.viewTop.layer.borderWidth      = 1;
    self.viewTop.layer.borderColor      = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1].CGColor;
    self.sendButton.layer.cornerRadius  = 6;
    self.sendButton.clipsToBounds       = YES;
}

/// unuse now.
- (void)getKeyBoardHeightForCell:(CGFloat)height {
    
    _kbHeight = height;
}

- (void)updateUI {
    for (NSInteger i = 1001; i <= 1007; i++) {
        if (i != 1006) {
            [self.contentView viewWithTag:i + 10].hidden = YES;
            UIButton *button = [self.contentView viewWithTag:i];
            button.enabled = NO;
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
    self.contactsNameTF.enabled = NO;
    self.contactsMobileTF.enabled = NO;
    self.houseAreaTF.enabled = NO;
    self.detailAddressTF.enabled = NO;
}

- (void)updateCellWithModel:(MPDecorationNeedModel *)model {

    [self updateUI];
        
    self.contactsNameTF.text       = model.contacts_name;
    self.contactsMobileTF.text     = model.contacts_mobile;
    [self.chooseRenovationBudget setTitle:model.decoration_budget forState:UIControlStateNormal];
    _decorationBudget              = model.decoration_budget;
    [self.chooseDesignBudget setTitle:model.design_budget forState:UIControlStateNormal];
    _designBudget                  = model.design_budget;
    [self.chooseHouseType setTitle:model.house_type forState:UIControlStateNormal];
    _houseType                     = [MPTranslate stringTypeChineseToEnglishWithString:model.house_type];
    self.houseAreaTF.text          = [NSString stringWithFormat:@"%@",model.house_area];
    [self.chooseHouseSize setTitle:[NSString stringWithFormat:@"%@ %@ %@",model.room,model.living_room,model.toilet] forState:UIControlStateNormal];
    _room                          = [MPTranslate stringTypeChineseToEnglishWithString:model.room];
    _livingRoom                    = [MPTranslate stringTypeChineseToEnglishWithString:model.living_room];
    _toilet                        = [MPTranslate stringTypeChineseToEnglishWithString:model.toilet];
    [self.chooseRenovationStyle setTitle:model.decoration_style forState:UIControlStateNormal];
    _renovationStyle               = [MPTranslate stringTypeChineseToEnglishWithString:model.decoration_style];
    [self.chooseAddress setTitle:[NSString stringWithFormat:@"%@ %@ %@",model.province_name,model.city_name,model.district_name] forState:UIControlStateNormal];
    _province                      = model.province;
    _city                          = model.city;
    _district                      = model.district;
    _province_name                 = model.province_name;
    _city_name                     = model.city_name;
    _district_name                 = model.district_name;
    self.detailAddressTF.text      = model.community_name;
}

- (void)updateCell {
    if ([self.delegate respondsToSelector:@selector(getMeasureHousePrice)]) {
        _measurePrice = [self.delegate getMeasureHousePrice];
        _measurePrice = (_measurePrice == nil)?@"0.00":_measurePrice;
        _measurePrice = ([_measurePrice rangeOfString:@"null"].length == 4 || _measurePrice.length == 0)?@"0.00":_measurePrice;
        _measurePriceLabel.text = [NSString stringWithFormat:@"%@%@",
                                   _measurePrice,
                                   NSLocalizedString(@"just_yuan_", nil)];
    }
    
    if ([self.delegate respondsToSelector:@selector(getMeasureDesignerId)]) {
        _designer_id = [self.delegate getMeasureDesignerId];
    }
    
    if ([self.delegate respondsToSelector:@selector(getHsUid)]) {
        _hs_uid = [self.delegate getHsUid];
    }
    
    if ([self.delegate respondsToSelector:@selector(getThreadId)]) {
        _thread_id = [self.delegate getThreadId];
    }
    
    if ([self.delegate respondsToSelector:@selector(getNeedInfo)]) {
        MPDecorationNeedModel *model = [self.delegate getNeedInfo];
        if (model != nil) {
            _isBidder = YES;
            _need_id  = [model.needs_id description];
            [self updateCellWithModel:model];
        }
    }
}

- (IBAction)chooseDesignBudget:(id)sender {
    [self recoverKeyboard];
    if ([self.delegate respondsToSelector:@selector(chooseInfoWithType:componet:linkage:)]) {
        [self.delegate chooseInfoWithType:@"DesignBudget" componet:1 linkage:NO];
    }
}
- (IBAction)chooseDecorationBudget:(id)sender {
    [self recoverKeyboard];
    if ([self.delegate respondsToSelector:@selector(chooseInfoWithType:componet:linkage:)]) {
        [self.delegate chooseInfoWithType:@"DecorationBudget" componet:1 linkage:NO];
    }
}

/// choose house type
- (IBAction)chooseHouseType:(id)sender {
    [self recoverKeyboard];
    if ([self.delegate respondsToSelector:@selector(chooseInfoWithType:componet:linkage:)]) {
        [self.delegate chooseInfoWithType:@"HouseType" componet:1 linkage:NO];
    }
}

/// choose number of room,livingroom,toilet
- (IBAction)houseSize:(id)sender {
    [self recoverKeyboard];
    if ([self.delegate respondsToSelector:@selector(chooseInfoWithType:componet:linkage:)]) {
        [self.delegate chooseInfoWithType:@"HouseSize" componet:3 linkage:NO];
    }
}

/// choose renovationstyle
- (IBAction)chooseRenovationStyle:(id)sender {
    [self recoverKeyboard];
    if ([self.delegate respondsToSelector:@selector(chooseInfoWithType:componet:linkage:)]) {
        [self.delegate chooseInfoWithType:@"RenovationStyle" componet:1 linkage:NO];
    }
}

/// choose address
- (IBAction)chooseAddrress:(id)sender {
    [self recoverKeyboard];
    [self keyboardUp];
    if ([self.delegate respondsToSelector:@selector(chooseInfoWithType:componet:linkage:)]) {
        [self.delegate chooseInfoWithType:@"Property" componet:3 linkage:YES];
    }
}

- (IBAction)chooseMeasureTime:(id)sender {
    [self recoverKeyboard];
    [self keyboardUp];
    if ([self.delegate respondsToSelector:@selector(chooseInfoWithType:componet:linkage:)]) {
        [self.delegate chooseInfoWithType:@"MeasureTime" componet:4 linkage:YES];
    }
}

- (void)getInfoForIssueDemandWithType:(NSString *)type
                            componet1:(NSString *)componet1
                            componet2:(NSString *)componet2
                            componet3:(NSString *)componet3
                                 nian:(NSString *)nian {
    
    if ([type isEqualToString:@"DesignBudget"]) {
        [self.chooseDesignBudget setTitle:componet1 forState:UIControlStateNormal];
        [self.chooseDesignBudget setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.statusDesignBudget.hidden = YES;
        _designBudget = componet1;
    }
    if ([type isEqualToString:@"DecorationBudget"]) {
        [self.chooseRenovationBudget setTitle:componet1 forState:UIControlStateNormal];
        [self.chooseRenovationBudget setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.statusDecorationBudget.hidden = YES;
        _decorationBudget = componet1;
    }
    if ([type isEqualToString:@"HouseType"]) {
        [self.chooseHouseType setTitle:componet1 forState:UIControlStateNormal];
        [self.chooseHouseType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.statusHoseTypeLabel.hidden = YES;
        _houseType = [MPTranslate stringTypeChineseToEnglishWithString:componet1];
    }
    else if ([type isEqualToString:@"HouseSize"]) {
        [self.chooseHouseSize setTitle:[NSString stringWithFormat:@"%@ %@ %@",componet1,componet2,componet3] forState:UIControlStateNormal];
        [self.chooseHouseSize setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.statusHouseSizeLabel.hidden = YES;
        _room       = [MPTranslate stringTypeChineseToEnglishWithString:componet1];
        _livingRoom = [MPTranslate stringTypeChineseToEnglishWithString:componet2];
        _toilet     = [MPTranslate stringTypeChineseToEnglishWithString:componet3];
    }
    else if ([type isEqualToString:@"RenovationStyle"]) {
        [self.chooseRenovationStyle setTitle:componet1 forState:UIControlStateNormal];
        [self.chooseRenovationStyle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.statusRenovationStyleLabel.hidden = YES;
        _renovationStyle = [MPTranslate stringTypeChineseToEnglishWithString:componet1];
    }
    else if ([type isEqualToString:@"Property"]) {
        NSDictionary *addressDict = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:componet1 withCityCode:componet2 andDistrictCode:componet3];
        [self.chooseAddress setTitle:[NSString stringWithFormat:@"%@ %@ %@",addressDict[@"province"],addressDict[@"city"],addressDict[@"district"]] forState:UIControlStateNormal];
        [self.chooseAddress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.statusAddressLabel.hidden = YES;
        
        _province = componet1;
        _city     = componet2;
        _district = (componet3 == nil)?@"0":componet3;
        _province_name = addressDict[@"province"];
        _city_name     = addressDict[@"city"];
        _district_name = (componet3 == nil)?@"none":addressDict[@"district"];
        
    } else if ([type isEqualToString:@"MeasureTime"]) {
        if ([self transformationMeasureTime:componet1 day:componet2 hour:componet3 nian:nian]) {
            [self.chooseMeasureTime setTitle:[NSString stringWithFormat:@"%@%@ %@ %@ %@",nian,NSLocalizedString(@"nian", nil),componet1,componet2,componet3] forState:UIControlStateNormal];
            [self.chooseMeasureTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.statusMeasureTime.hidden = YES;
        }
    }
    [self keyboardDown];
}

- (BOOL)transformationMeasureTime:(NSString *)month
                              day:(NSString *)day
                             hour:(NSString *)hour
                             nian:(NSString *)nian {
    
    month = [month substringToIndex:month.length - 1];
    day   = [day substringToIndex:day.length - 1];
    hour  = [hour substringToIndex:hour.length - 1];
    if (![MPMeasureTool isCurrentDataOverMeasure:[nian integerValue]
                                          month:[month integerValue]
                                            day:[day integerValue]
                                           hour:[hour integerValue]]) {
        _measureTime = [NSString stringWithFormat:@"%@-%@-%@ %@:00:00",nian, month, day, hour];
        return YES;
    } else {
        [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_seleted_time", nil)
                                  sureKey:nil];
        return NO;
    }
}

/// Get the current time.
- (NSString*)getRequrieYear {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
}

- (void)setUploadButtonUnenable:(UIButton *)button {
    button.enabled = NO;
    button.backgroundColor = [UIColor lightGrayColor];
}

- (void)setUploadButtonEnable:(UIButton *)button {
    button.enabled = YES;
    button.backgroundColor = [UIColor colorWithRed:0/255.0 green:110/255.0 blue:255/255.0 alpha:1];
}

- (IBAction)send:(UIButton *)sender {
    [self setUploadButtonUnenable:sender];
    [self recoverKeyboard];
    [self hidePickerView];
    [self keyboardDown];
    if (![self check]) {
        [self setUploadButtonEnable:sender];
        return;
    }

    MPMember *member = [[MPMember alloc] init];
    NSDictionary *parameterDict;
    if (!_isBidder) {
        parameterDict = @{
                          @"service_date"         : _measureTime,
                          @"user_id"              : member.acs_member_id,
                          @"contacts_name"        :self.contactsNameTF.text,
                          @"contacts_mobile"      :self.contactsMobileTF.text,
                          @"designer_id"          : _designer_id,
                          @"order_type"           : @"0",
                          @"amount"               : _measurePrice,
                          @"channel_type"         : @"IOS",
                          @"house_type"           : _houseType,
                          @"house_area"           : self.houseAreaTF.text,
                          @"decoration_budget"    : _decorationBudget,
                          @"design_budget"        : _designBudget,
                          @"decoration_style"     : _renovationStyle,
                          @"province"             : _province,
                          @"city"                 : _city,
                          @"district"             : _district,
                          @"province_name"        : _province_name,
                          @"city_name"            : _city_name,
                          @"district_name"        : _district_name,
                          @"community_name"       : self.detailAddressTF.text,
                          @"room"                 : _room,
                          @"living_room"          : _livingRoom,
                          @"toilet"               : _toilet,
                          @"hs_uid"               : _hs_uid,
                          @"thread_id"            : _thread_id
                          };
    } else {
        parameterDict = @{
                          @"service_date"     : _measureTime,
                          @"user_id"          : member.acs_member_id,
                          @"user_name"        : @"nimei",
                          @"mobile_number"    : @"110",
                          @"needs_id"         : _need_id,
                          @"designer_id"      : _designer_id,
                          @"designer_name"    : @"设计师",
                          @"order_type"       : @"0",
                          @"amount"           : _measurePrice,
                          @"adjustment"       : @(600),
                          @"channel_type"     : @"IOS"
                          };
    }
    
    NSLog(@"parameterDict:%@",parameterDict);
    
    WS(weakSelf);
    if ([self.delegate respondsToSelector:@selector(sendMeasureTableWithParameters:header:isBidder:finish:)]) {
        [self.delegate sendMeasureTableWithParameters:parameterDict header:nil isBidder:_isBidder finish:^{
            [weakSelf setUploadButtonEnable:sender];
        }];
    }
}

- (BOOL)check {
    if (![MPIssueAmendCheak checkContactsName:self.contactsNameTF.text]) return NO;
    
    if (![MPIssueAmendCheak checkContactsMobile:self.contactsMobileTF.text]) return NO;
    
    if (![MPIssueAmendCheak checkHouseType:_houseType]) return NO;
    
    if (![MPIssueAmendCheak checkHouseArea:self.houseAreaTF.text]) return NO;
    
    if (![MPIssueAmendCheak checkDesignBudget:_designBudget]) return NO;
    
    if (![MPIssueAmendCheak checkRenovationBudget:_decorationBudget]) return NO;
    
    if (![MPIssueAmendCheak checkHouseSize:_room]) return NO;
    
    if (![MPIssueAmendCheak checkRenovationStyle:_renovationStyle]) return NO;
    
    if (![MPIssueAmendCheak checkMeasureTime:_measureTime]) return NO;

    if (![MPIssueAmendCheak checkAddress:_province]) return NO;
    
    if (![MPIssueAmendCheak checkNeighbourhoods:self.detailAddressTF.text]) return NO;
    
    return YES;
}

/// recover the keyboard and picker.
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self recoverKeyboard];
    [self hidePickerView];
    [self keyboardDown];
}

#pragma mark - textFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self hidePickerView];
    if (textField == self.detailAddressTF) {
        [self keyboardUp];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self recoverKeyboard];
    [self hidePickerView];
    [self keyboardDown];
    return YES;
}

/// cell phone number can not be more than eleven.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.contactsMobileTF) {
        if (textField.text.length == 11) {
            if ([string isEqualToString:@""] && [string integerValue] == 0) {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}


- (void)hidePickerView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hidePicker)]) {
        [self.delegate hidePicker];
    }
}

/// up
- (void)keyboardUp {
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.x - 220, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

/// down
- (void)keyboardDown {
    self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

/// recover keyboard.
- (void)recoverKeyboard {
    [self.contentView endEditing:YES];
}


@end
