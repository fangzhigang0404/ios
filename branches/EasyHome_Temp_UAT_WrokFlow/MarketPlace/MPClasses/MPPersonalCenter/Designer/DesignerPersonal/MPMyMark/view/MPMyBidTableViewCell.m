/**
 * @file    MPMyBidTableViewCell.m
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-18
 */


#import "MPMyBidTableViewCell.h"
#import "MPMarkModel.h"
#import "MPTranslate.h"
@interface MPMyBidTableViewCell()

/// the label of address.
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

/// the label of project name.
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/// the label of house type.
@property (weak, nonatomic) IBOutlet UILabel *houseTypeLabel;

/// the label of house stye.
@property (weak, nonatomic) IBOutlet UILabel *styeLabel;

/// the label of decorat price.
@property (weak, nonatomic) IBOutlet UILabel *decoratPriceLabel;

/// the label of decorat title.
@property (weak, nonatomic) IBOutlet UILabel *decoratLabel;

/// the button of my project.
@property (weak, nonatomic) IBOutlet UIButton *projectButton;

/// the label of instruction.
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

/// _index the index for model in datasource.
@property (assign, nonatomic) NSUInteger index;
@end
@implementation MPMyBidTableViewCell
-(void) updateCellForIndex:(NSUInteger) index withType:(NSString *)type
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
        
//        NSString *house_area = [NSString stringWithFormat:@"%@_area",model.house_area];
//        
//        house_area = [MPTranslate stringTypeEnglishToChineseWithString:house_area];
//        house_area = ([house_area isEqualToString:@"(null)"])?model.house_area:house_area;
////        NSString *roomChinese = [MPTranslate stringTypeEnglishToChineseWithString:model.room];

        self.titleLabel.text = [NSString stringWithFormat:@"%@%@%@ %@㎡",roomChinese,living_room,toiletString,model.house_area];
        NSString *typeString = [MPTranslate stringTypeEnglishToChineseWithString:[model.house_type lowercaseString]];
        typeString = ([typeString isEqualToString:@"(null)"])?model.house_type:typeString;
        
        self.houseTypeLabel.text = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"just_string_house_type", nil),typeString];
        NSString *styleString = [MPTranslate stringTypeEnglishToChineseWithString:[model.decoration_style lowercaseString]];
        styleString = ([styleString isEqualToString:@"(null)"])?model.decoration_style:styleString;
        

        self.styeLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"style_key", nil),styleString];
        
        self.decoratPriceLabel.text = [NSString stringWithFormat:@"%@",model.renovation_budget];
        if ([type isEqualToString:@"two"]) {
            self.projectButton.hidden = NO;
            self.instructionsLabel.text = NSLocalizedString(@"bid_key", nil);
        }else{
            self.projectButton.hidden = YES;
            self.instructionsLabel.text = NSLocalizedString(@"not_mark", nil);

        }
        self.projectButton.layer.cornerRadius = 5;

        
    }
}

- (IBAction)myProjectClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(pushToMyProject:)]) {
        [self.delegate pushToMyProject:_index];
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
