//
//  MPMeasureDetailCell.m
//  MarketPlace
//
//  Created by Jiao on 16/2/25.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMeasureDetailCell.h"
#import "MPStatusModel.h"
#import "MPTranslate.h"

@interface MPMeasureDetailCell()

@end
@implementation MPMeasureDetailCell
{



    __weak IBOutlet NSLayoutConstraint *refuseConstraint;
   
    __weak IBOutlet UIButton *_confirmButton;
    __weak IBOutlet UIButton *_refuseButton;
    
    __weak IBOutlet UILabel *contacts_nameLabel;//姓名
    __weak IBOutlet UILabel *contacts_mobileLabel;//电话
    __weak IBOutlet UILabel *design_budgetLabel;//设计预算
    __weak IBOutlet UILabel *decoration_budgetLabel;//装修预算
    __weak IBOutlet UILabel *house_areaLabel;//面积
    __weak IBOutlet UILabel *rltLabel;//户型（室、厅、位）
    __weak IBOutlet UILabel *measure_timeLabel;//量房时间
    __weak IBOutlet UILabel *measure_addrLabel;//量房地点
    __weak IBOutlet UILabel *community_nameLabel;//小区名称
    __weak IBOutlet UILabel *measurement_feeLabel;//量房费
   
}
- (void)awakeFromNib {
}

- (void)updateDetailCellForIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(updateCellData)]) {
        [self updateDataWithModel:[self.delegate updateCellData]];
    }
    
    if ([self.delegate respondsToSelector:@selector(updateCellUI)]) {
        [self updateUIWithStatusDetail:[self.delegate updateCellUI]];
    }
}

- (void)updateDataWithModel:(MPStatusModel *)model {
    
//    NSString *house_type = [MPTranslate stringTypeEnglishToChineseWithString:[model.wk_measureModel.house_type lowercaseString]];
    NSString *room = [MPTranslate stringTypeEnglishToChineseWithString:[model.wk_measureModel.room lowercaseString]];
    NSString *living_room = [NSString stringWithFormat:@"%@_living",model.wk_measureModel.living_room];
    living_room = [MPTranslate stringTypeEnglishToChineseWithString:[living_room lowercaseString]];
    NSString *toilet = [NSString stringWithFormat:@"%@_toilet",model.wk_measureModel.toilet];
    toilet = [MPTranslate stringTypeEnglishToChineseWithString:[toilet lowercaseString]];
    NSString *rltStr = [NSString stringWithFormat:@"%@ %@ %@",room, living_room, toilet];
//    NSString *decoration_style = [MPTranslate stringTypeEnglishToChineseWithString:[model.wk_measureModel.decoration_style lowercaseString]];
    NSString *addrStr = [NSString stringWithFormat:@"%@ %@ %@",model.wk_measureModel.province, model.wk_measureModel.city, model.wk_measureModel.district];
    
    contacts_nameLabel.text = model.wk_measureModel.contacts_name;
    contacts_mobileLabel.text = model.wk_measureModel.contacts_mobile;
    design_budgetLabel.text = model.wk_measureModel.design_budget;
    decoration_budgetLabel.text = model.wk_measureModel.decoration_budget;
//    house_typeLabel.text = house_type;
    house_areaLabel.text = model.wk_measureModel.house_area;
    rltLabel.text = rltStr;
//    decoration_styleLabel.text = decoration_style;
    measure_timeLabel.text = model.wk_measureModel.measure_time;
    measure_addrLabel.text = addrStr;
    community_nameLabel.text = model.wk_measureModel.community_name;
    measurement_feeLabel.text = [self moneyFormat:[NSNumber numberWithFloat:[model.wk_measureModel.measurement_fee floatValue]]];
    
}

- (void)updateUIWithStatusDetail:(MPStatusDetail *)statusDetail {

    if (statusDetail) {
        if (statusDetail.selectShow) {
            if ([AppController AppGlobal_GetIsDesignerMode]) {

                _confirmButton.hidden = NO;
                _refuseButton.hidden = NO;
                
                refuseConstraint.active = YES;
            }else {

                _confirmButton.hidden = YES;
                _refuseButton.hidden = YES;
                
                refuseConstraint.active = NO;
            }
        }else {
            _confirmButton.hidden = YES;
            _refuseButton.hidden = YES;

            refuseConstraint.active = NO;
        }

    }
}

- (IBAction)confirmClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(confirmMeasure)]) {
        [self.delegate confirmMeasure];
    }
}
- (IBAction)refuseClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(refuseMeasure)]) {
        [self.delegate refuseMeasure];
    }
}


- (NSString *)moneyFormat:(NSNumber *)num {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSMutableString *string = [NSMutableString stringWithString:[formatter stringFromNumber:num]];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSInteger loc = [string rangeOfCharacterFromSet:characterSet].location;
    NSString *resultStr = [NSString stringWithFormat:@"¥ %@",[string substringFromIndex:loc]];
    return resultStr;
}

@end
