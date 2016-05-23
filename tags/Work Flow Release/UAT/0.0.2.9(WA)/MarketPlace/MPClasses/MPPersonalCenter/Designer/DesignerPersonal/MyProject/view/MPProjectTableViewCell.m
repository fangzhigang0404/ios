//
//  MPProjectTableViewCell.m
//  MarketPlace
//
//  Created by xuezy on 16/1/20.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPProjectTableViewCell.h"
#import "MPEditDemandViewController.h"
#import "MPOrderCurrentStateController.h"
#import "MPStatusMachine.h"
#import "MPStatusModel.h"
#import "MPTranslate.h"
@interface MPProjectTableViewCell ()
@property (nonatomic, strong) MPStatusModel *statusModel;
@end
@implementation MPProjectTableViewCell
#pragma mark - Lazy Loading
- (MPStatusModel *)statusModel {
    if (_statusModel == nil) {
        _statusModel = [[MPStatusModel alloc]init];
    }
    return _statusModel;
}

- (void)upLoadData {
    
    //self.projectNameLabel.text = self.model.neighbourhoods;
    
    self.addressLabel.text = self.model.neighbourhoods;
    
    NSString *roomChinese = [MPTranslate stringTypeEnglishToChineseWithString:self.model.room];
    roomChinese = ([roomChinese isEqualToString:@"(null)"])?self.model.room:roomChinese;
    
    NSString *living_room = [NSString stringWithFormat:@"%@_living",self.model.living_room];
    
    living_room = [MPTranslate stringTypeEnglishToChineseWithString:living_room];
    living_room = ([living_room isEqualToString:@"(null)"])?self.model.living_room:living_room;
    
    NSString *toiletString = [NSString stringWithFormat:@"%@_toilet",self.model.toilet];
    
    toiletString = [MPTranslate stringTypeEnglishToChineseWithString:toiletString];
    toiletString = ([toiletString isEqualToString:@"(null)"])?self.model.toilet:toiletString;
    
    //    NSString *house_area = [NSString stringWithFormat:@"%@_area",self.model.house_area];
    //
    //    house_area = [MPTranslate stringTypeEnglishToChineseWithString:house_area];
    //    house_area = ([house_area isEqualToString:@"(null)"])?self.model.house_area:house_area;
    
    
    //    NSString *roomChineseString = [MPTranslate stringTypeEnglishToChineseWithString:self.model.room];
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@",self.model.province,self.model.city,self.model.district];

    self.projectNumberLabel.text = [NSString stringWithFormat:@"项目编号: %@",self.model.needs_id];
    self.projectNameLabel.text = [NSString stringWithFormat:@"%@ %@%@%@ %@㎡",addressStr,roomChinese,living_room,toiletString,self.model.house_area];
    
    NSString *typeString = [MPTranslate stringTypeEnglishToChineseWithString:[self.model.house_type lowercaseString]];
    typeString = ([typeString isEqualToString:@"(null)"])?self.model.house_type:typeString;
    
    self.houseTypeLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"just_string_house_type", nil),typeString];
    
    NSString *styleString = [MPTranslate stringTypeEnglishToChineseWithString:[self.model.decoration_style lowercaseString]];
    styleString = ([styleString isEqualToString:@"(null)"])?self.model.decoration_style:styleString;
    
    self.styleLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"style_key", nil),styleString];
    self.projectDetailButton.layer.cornerRadius = 5;
    self.needsDetailButton.layer.cornerRadius = 5;
    
    self.projectStatusLabel.text = [MPStatusMachine getCurrentSubNodeName:self.model.wk_sub_node_id];
    
}

- (IBAction)needsDetail:(id)sender {
    MPEditDemandViewController *vc = [[MPEditDemandViewController alloc] init];
    vc.needs_id = self.model.needs_id;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}
- (IBAction)projectDetailBtnClick:(id)sender {
    MPOrderCurrentStateController *vc = [[MPOrderCurrentStateController alloc]init];
    vc.needs_id = self.model.needs_id;
    vc.designer_id = self.model.designer_id;
    [[self viewController].navigationController pushViewController:vc animated:YES];
}

/// 找到当前视图的controller
- (UIViewController *)viewController {
    for (UIView * next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

- (void)awakeFromNib {
    // Initialization code
      self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
