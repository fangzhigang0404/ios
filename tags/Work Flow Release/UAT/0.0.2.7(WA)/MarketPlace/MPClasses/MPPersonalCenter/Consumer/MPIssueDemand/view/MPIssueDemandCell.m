/**
 * @file    MPIssueDemandCell.m
 * @brief   the cell of table.
 * @author  niu
 * @version 1.0
 * @date    2016-01-20
 *
 */

#import "MPIssueDemandCell.h"
#import "MBProgressHUD.h"
#import "MPDecorationNeedModel.h"
#import "MPIssueAmendCheak.h"
#import "MPDesignerInfoModel.h"
#import "MPTranslate.h"
#import "MPRegionManager.h"
#import "MPCenterTool.h"

@interface MPIssueDemandCell ()<UITextFieldDelegate,UIAlertViewDelegate>

/// design budget status.
@property (weak, nonatomic) IBOutlet UIImageView *statusDesignBudget;

/// decoration budget status.
@property (weak, nonatomic) IBOutlet UIImageView *statusDecorationBudget;

/// house type status.
@property (weak, nonatomic) IBOutlet UIImageView *statusHoseTypeLabel;

/// house size (room, livingroom, toilet) status.
@property (weak, nonatomic) IBOutlet UIImageView *statusHouseSizeLabel;

/// renovation style status.
@property (weak, nonatomic) IBOutlet UIImageView *statusRenovationStyleLabel;

/// address status.
@property (weak, nonatomic) IBOutlet UIImageView *statusAddressLabel;

/// create time label.
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

/// publish label.
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLabel;

/// contacts name textfield.
@property (weak, nonatomic) IBOutlet UITextField *contactsNameTF;
/// contacts mobile textfield.
@property (weak, nonatomic) IBOutlet UITextField *contactsMobileTF;
/// house area textfield.
@property (weak, nonatomic) IBOutlet UITextField *houseAreaTF;
/// community name textfield.
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;

/// choose design budget button.
@property (weak, nonatomic) IBOutlet UIButton *chooseDesignBudget;
/// choose renovation budget button.
@property (weak, nonatomic) IBOutlet UIButton *ChooseRenovationBudget;
/// choose house type button.
@property (weak, nonatomic) IBOutlet UIButton *chooseHouseType;
/// choose house size button.size(room, livingroom, toilet).
@property (weak, nonatomic) IBOutlet UIButton *chooseHouseSize;
/// choose renovationstyle button.
@property (weak, nonatomic) IBOutlet UIButton *chooseRenovationStyle;
/// choose address button.
@property (weak, nonatomic) IBOutlet UIButton *chooseAddress;
/// issue decoration button.
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
/// issue again button.
@property (weak, nonatomic) IBOutlet UIButton *issueAgainButton;
/// cancel button.
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/// top view.
@property (weak, nonatomic) IBOutlet UIView *viewTop;
/// middel view.
@property (weak, nonatomic) IBOutlet UIView *viewMiddle;
/// low view.
@property (weak, nonatomic) IBOutlet UIView *viewLow;

@end

@implementation MPIssueDemandCell
{
    NSString *_houseType;           //!< _houseType the string of house type.
    
    NSString *_room;                //!< _room the string of room.
    NSString *_livingRoom;          //!< _livingRoom the string of livingroom.
    NSString *_toilet;              //!< _toilet the string of toilet.
    
    NSString *_renovationStyle;     //!< _renovationStyle the string of renovationStyle.
    
    NSString *_decorationBudget;    //!< _decorationBudget the string of decoration budget.
    NSString *_designBudget;        //!< _designBudget the string of design budget.
    
    NSString *_province;            //!< _province the string of province.
    NSString *_city;                //!< _city the string of city.
    NSString *_district;            //!< _district the string of district.
    NSString *_province_name;       //!< _province_name the string of province name.
    NSString *_city_name;           //!< _city_name the string of city name.
    NSString *_district_name;       //!< _district_name the string of district name.
    
    MPDesignerInfoModel *_model;    //!< _model the model of designer.    
}

- (void)awakeFromNib {
    // Initialization code
    self.contactsNameTF.enabled = NO;
    self.contactsNameTF.text = [MPCenterTool getNickName];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.houseAreaTF setValue:ColorFromRGA(0x999999, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self.contactsNameTF setValue:ColorFromRGA(0x999999, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self.contactsMobileTF setValue:ColorFromRGA(0x999999, 1) forKeyPath:@"_placeholderLabel.textColor"];
    [self.detailAddressTF setValue:ColorFromRGA(0x999999, 1) forKeyPath:@"_placeholderLabel.textColor"];
    
    self.sendButton.layer.cornerRadius       = 6;
    self.sendButton.clipsToBounds            = YES;
    self.issueAgainButton.layer.cornerRadius = 6;
    self.issueAgainButton.clipsToBounds      = YES;
    self.cancelButton.layer.cornerRadius     = 6;
    self.cancelButton.clipsToBounds          = YES;
    
    self.issueAgainButton.hidden             = YES;
    self.cancelButton.hidden                 = YES;
    self.createTimeLabel.hidden              = YES;
}

- (void)updateUI:(MPDecorationNeedModel *)model {
    self.sendButton.hidden        = YES;
    self.issueAgainButton.hidden  = NO;
    self.cancelButton.hidden      = NO;
    self.createTimeLabel.hidden   = NO;
    self.contactsNameTF.enabled   = NO;
//    self.contactsMobileTF.enabled = NO;
    for (NSInteger i = 2001; i <= 2006; i++) {
        [self.contentView viewWithTag:i + 10].hidden = YES;
        UIButton *button = [self.contentView viewWithTag:i];
//        button.enabled = NO;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if ([model.custom_string_status integerValue] == 1 ||
        [model.custom_string_status integerValue] == 2) {
        [self setButtonEnable:self.issueAgainButton];
    } else {
        [self setButtonUnenable:self.issueAgainButton];
    }
    
    if (model.bidders.count > 0) {
        [self setButtonUnenable:self.cancelButton];
    } else {
        [self setButtonEnable:self.cancelButton];
    }
}

- (void)updateCellForDecorationDetail:(MPDecorationNeedModel *)model {
    [self updateUI:model];
    
    self.publishTimeLabel.text  = model.publish_time;
    self.contactsNameTF.text    = model.contacts_name;
    self.contactsMobileTF.text  = model.contacts_mobile;
    [self.chooseDesignBudget setTitle:model.design_budget forState:UIControlStateNormal];
    _designBudget               = (model.design_budget == nil)?@"0":model.design_budget;
    [self.ChooseRenovationBudget setTitle:model.decoration_budget forState:UIControlStateNormal];
    _decorationBudget           = model.decoration_budget;
    [self.chooseHouseType setTitle:model.house_type forState:UIControlStateNormal];
    _houseType                  = [MPTranslate stringTypeChineseToEnglishWithString:model.house_type];
    self.houseAreaTF.text       = model.house_area;
    [self.chooseHouseSize setTitle:[NSString stringWithFormat:@"%@%@%@",model.room,model.living_room,model.toilet] forState:UIControlStateNormal];
    _room       = [MPTranslate stringTypeChineseToEnglishWithString:model.room];
    _livingRoom = [MPTranslate stringTypeChineseToEnglishWithString:model.living_room];
    _toilet     = [MPTranslate stringTypeChineseToEnglishWithString:model.toilet];
    [self.chooseRenovationStyle setTitle:model.decoration_style forState:UIControlStateNormal];
    _renovationStyle = [MPTranslate stringTypeChineseToEnglishWithString:model.decoration_style];
    [self.chooseAddress setTitle:[NSString stringWithFormat:@"%@%@%@",model.province_name,model.city_name,model.district_name] forState:UIControlStateNormal];
    _province                   = model.province;
    _city                       = model.city;
    _district                   = model.district;
    _province_name              = model.province_name;
    _city_name                  = model.city_name;
    _district_name              = model.district_name;
    self.detailAddressTF.text   = model.community_name;
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

- (void)getInfoForIssueDemandWithType:(NSString *)type
                            componet1:(NSString *)componet1
                            componet2:(NSString *)componet2
                            componet3:(NSString *)componet3 {
    
    if ([type isEqualToString:@"DesignBudget"]) {
        [self.chooseDesignBudget setTitle:componet1 forState:UIControlStateNormal];
        [self.chooseDesignBudget setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.statusDesignBudget.hidden = YES;
        _designBudget = componet1;
    }
    if ([type isEqualToString:@"DecorationBudget"]) {
        [self.ChooseRenovationBudget setTitle:componet1 forState:UIControlStateNormal];
        [self.ChooseRenovationBudget setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
        [self keyboardDown];
        [self.chooseRenovationStyle setTitle:componet1 forState:UIControlStateNormal];
        [self.chooseRenovationStyle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.statusRenovationStyleLabel.hidden = YES;
        _renovationStyle = [MPTranslate stringTypeChineseToEnglishWithString:componet1];
    }
    else if ([type isEqualToString:@"Property"]) {
        [self keyboardDown];
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
    }
}

/// upload
- (IBAction)uploadNow:(UIButton *)sender {
    [self setButtonUnenable:sender];
    [self recoverKeyboard];
    [self hidePickerView];
    [self keyboardDown];
    if (![self check]) {
        [self setButtonEnable:sender];
        return;
    }
    
    NSDictionary *parameters = @{@"contacts_name"       :self.contactsNameTF.text,
                                 @"house_type"          :_houseType,
                                 @"contacts_mobile"     :self.contactsMobileTF.text,
                                 @"house_area"          :self.houseAreaTF.text,
                                 @"decoration_budget"   :_decorationBudget,
                                 @"decoration_style"    :_renovationStyle,
                                 @"province"            :_province,
                                 @"province_name"       :_province_name,
                                 @"city_name"           :_city_name,
                                 @"district_name"       :_district_name,
                                 @"city"                :_city,
                                 @"district"            :_district,
                                 @"community_name"      :self.detailAddressTF.text,
                                 @"room"                :_room,
                                 @"living_room"         :_livingRoom,
                                 @"toilet"              :_toilet,
                                 @"design_budget"       :_designBudget,
                                 @"click_number"        :@"0",
                                 @"consumer_mobile"     :@"11012011900",
                                 @"consumer_name"       :@"APP端发布需求-此字段不用",
                                 @"detail_desc"         :@"desc"
                                };
    WS(weakSelf);
    if ([self.delegate respondsToSelector:@selector(uploadDemandWithParameters:header:finish:)]) {
        [self.delegate uploadDemandWithParameters:parameters header:nil finish:^{
            [weakSelf setButtonEnable:sender];
        }];
    }
}

- (IBAction)issueAgainAction:(UIButton *)sender {
    [self setButtonUnenable:sender];
    [self recoverKeyboard];
    [self keyboardDown];
    [self hidePickerView];
    if (![self check]) {
        [self setButtonEnable:sender];
        return;
    }
    NSDictionary *dict = @{@"contacts_name"     :self.contactsNameTF.text,
                           @"house_type"        :_houseType,
                           @"contacts_mobile"   :self.contactsMobileTF.text,
                           @"house_area"        :self.houseAreaTF.text,
                           @"decoration_budget" :_decorationBudget,
                           @"decoration_style"  :_renovationStyle,
                           @"province"          :_province,
                           @"city"              :_city,
                           @"district"          :_district,
                           @"province_name"     :_province_name,
                           @"city_name"         :_city_name,
                           @"district_name"     :_district_name,
                           @"community_name"    :self.detailAddressTF.text,
                           @"room"              :_room,
                           @"living_room"       :_livingRoom,
                           @"toilet"            :_toilet,
                           @"design_budget"     :_designBudget,
                           @"consumer_mobile"   :@"13111111111",
                           @"consumer_name"     :@"SB",
                           @"click_number"      :@"0",
                           @"detail_desc"       :@"desc"};
    WS(weakSelf);
    if ([self.delegate respondsToSelector:@selector(issueAgainWithParameters:header:finish:)]) {
        [self.delegate issueAgainWithParameters:dict header:nil finish:^() {
            [weakSelf setButtonEnable:sender];
        }];
    }

}
- (IBAction)cancelAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(cancelDecoration)]) {
        [self.delegate cancelDecoration];
    }
}

- (void)setButtonUnenable:(UIButton *)button {
    button.enabled = NO;
    button.backgroundColor = [UIColor lightGrayColor];
}

- (void)setButtonEnable:(UIButton *)button {
    button.enabled = YES;
    button.backgroundColor = [UIColor colorWithRed:0/255.0 green:110/255.0 blue:255/255.0 alpha:1];
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
        if (textField.text.length >= 11) {
            if ([string isEqualToString:@""] && [string integerValue] == 0) {
                return YES;
            }
            return NO;
        }
    } else if (textField == self.houseAreaTF) {
        if (textField.text.length >= 9) {
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
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.x - 250, self.contentView.frame.size.width, self.contentView.frame.size.height);
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
