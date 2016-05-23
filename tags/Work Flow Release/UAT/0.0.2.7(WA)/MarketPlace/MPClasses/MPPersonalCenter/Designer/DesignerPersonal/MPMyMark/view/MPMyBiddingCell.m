//
//  MPMyBiddingCell.m
//  MarketPlace
//
//  Created by xuezy on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMyBiddingCell.h"
#import "MPMarkModel.h"
#import "MPTranslate.h"
@interface MPMyBiddingCell()

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *styeLabel;
@property (weak, nonatomic) IBOutlet UILabel *biddingCount;
@property (weak, nonatomic) IBOutlet UILabel *decoratPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *decoratLabel;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (assign, nonatomic) NSUInteger index;

@end
@implementation MPMyBiddingCell

-(void) updateCellForIndex:(NSUInteger) index
{
    if ([self.delegate respondsToSelector:@selector(getDesignerLibraryModelForIndex:)])
    {
        self.index = index;
        MPMarkModel *model = [self.delegate getDesignerLibraryModelForIndex:self.index];
        self.addressLabel.text = model.needName;
        
        NSString *roomChinese = [MPTranslate stringTypeEnglishToChineseWithString:model.room];
        roomChinese = ([roomChinese isEqualToString:@"(null)"])?model.room:roomChinese;
        
        NSString *living_room = [NSString stringWithFormat:@"%@_living",model.living_room];
        
        living_room = [MPTranslate stringTypeEnglishToChineseWithString:living_room];
        living_room = ([living_room isEqualToString:@"(null)"])?model.living_room:living_room;
        
        NSString *toiletString = [NSString stringWithFormat:@"%@_toilet",model.toilet];
        
        toiletString = [MPTranslate stringTypeEnglishToChineseWithString:toiletString];
        toiletString = ([toiletString isEqualToString:@"(null)"])?model.toilet:toiletString;
//        
//        NSString *house_area = [NSString stringWithFormat:@"%@_area",model.house_area];
//        
//        house_area = [MPTranslate stringTypeEnglishToChineseWithString:house_area];
//        house_area = ([house_area isEqualToString:@"(null)"])?model.house_area:house_area;
//        NSString *roomChinese = [MPTranslate stringTypeEnglishToChineseWithString:model.room];
        
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@ %@㎡",roomChinese,living_room,toiletString,model.house_area];
        
        NSString *typeString = [MPTranslate stringTypeEnglishToChineseWithString:[model.house_type lowercaseString]];
        typeString = ([typeString isEqualToString:@"(null)"])?model.house_type:typeString;

        self.houseTypeLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"just_string_house_type", nil),typeString];
        NSString *styleString = [MPTranslate stringTypeEnglishToChineseWithString:[model.decoration_style lowercaseString]];
        styleString = ([styleString isEqualToString:@"(null)"])?model.decoration_style:styleString;


        self.styeLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"style_key", nil),styleString];
        self.decoratPriceLabel.text = [NSString stringWithFormat:@"%@",model.renovation_budget];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"from the end of the distance", nil),model.dayNumber,NSLocalizedString(@"day_key", nil)]];
        
        NSLog(@"%ld",str.length);
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1] range:NSMakeRange(5,str.length - 1 - 5)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(5,str.length - 1 - 5)];
        self.endTimeLabel.attributedText = str;
        
//        self.endTimeLabel.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"from the end of the distance", nil),model.dayNumber,NSLocalizedString(@"day_key", nil)];
//        self.biddingCount.text = [NSString stringWithFormat:@"%@%@%@",NSLocalizedString(@"should_be_key", nil),model.bidder_count,NSLocalizedString(@"designers should target", nil)];
        self.chatButton.layer.cornerRadius = 5;
        self.detailButton.layer.cornerRadius = 5;
    }
}

- (IBAction)chatClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(followDesignerForIndex:)]) {
        [self.delegate followDesignerForIndex:_index];
    }

}

- (IBAction)detailClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(startChatWithDesignerForIndex:)]) {
        [self.delegate startChatWithDesignerForIndex:_index];
    }
    
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
