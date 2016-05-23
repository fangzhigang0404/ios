//
//  MPBiddingDetailTableViewCell.m
//  MarketPlace
//
//  Created by xuezy on 16/3/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPBiddingDetailTableViewCell.h"
#import "MPMarkHallModel.h"
#import "MPTranslate.h"
#import "MPRegionManager.h"
@interface MPBiddingDetailTableViewCell()

@property (strong,nonatomic)IBOutlet UILabel *projectNumberLabel;
@property (strong,nonatomic)IBOutlet UILabel *nameLabel;
@property (strong,nonatomic)IBOutlet UILabel *phoneLabel;
@property (strong,nonatomic)IBOutlet UILabel *decoration_budgetLabel;
@property (strong,nonatomic)IBOutlet UILabel *design_budgetLabel;
@property (strong,nonatomic)IBOutlet UILabel *houseTypeLabel;
@property (strong,nonatomic)IBOutlet UILabel *houseAreaLabel;
@property (strong,nonatomic)IBOutlet UILabel *huxingLabel;
@property (strong,nonatomic)IBOutlet UILabel *houseStyleLabel;
@property (strong,nonatomic)IBOutlet UILabel *addressLabel;
@property (strong,nonatomic)IBOutlet UILabel *communityLabel;
@property (strong,nonatomic)IBOutlet UILabel *timeLabel;

@property (strong,nonatomic)IBOutlet UIButton *biddingButton;



@end

@implementation MPBiddingDetailTableViewCell

-(void) updateCellForIndex
{
    if ([self.delegate respondsToSelector:@selector(getBiddingModel)])
    {
        MPMarkHallModel *markModel = [self.delegate getBiddingModel];
        if ([markModel.after_bidding_status isEqualToString:@"0"] || [markModel.status isEqualToString:@"0"] ) {
            
            markModel.contacts_mobile = NSLocalizedString(@"Visible after the successful designer", nil);
        }else {
            
            
        }
        
        NSString *roomChinese = [MPTranslate stringTypeEnglishToChineseWithString:markModel.room];
        roomChinese = ([roomChinese isEqualToString:@"(null)"])?markModel.room:roomChinese;
        
        NSString *living_room = [NSString stringWithFormat:@"%@_living",markModel.living_room];
        
        living_room = [MPTranslate stringTypeEnglishToChineseWithString:living_room];
        living_room = ([living_room isEqualToString:@"(null)"])?markModel.living_room:living_room;
        
        NSString *toiletString = [NSString stringWithFormat:@"%@_toilet",markModel.toilet];
        
        toiletString = [MPTranslate stringTypeEnglishToChineseWithString:toiletString];
        toiletString = ([toiletString isEqualToString:@"(null)"])?markModel.toilet:toiletString;
        
        NSDictionary *addressDict = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:markModel.province withCityCode:markModel.city andDistrictCode:markModel.district];
        NSString *addressStr = [NSString stringWithFormat:@"%@%@%@",addressDict[@"province"],addressDict[@"city"],addressDict[@"district"]];
        
        NSString *styleString = [MPTranslate stringTypeEnglishToChineseWithString:[markModel.renovation_style lowercaseString]];
        styleString = ([styleString isEqualToString:@"(null)"])?markModel.renovation_style:styleString;
        NSString *typeString = [MPTranslate stringTypeEnglishToChineseWithString:[markModel.house_type lowercaseString]];
        typeString = ([typeString isEqualToString:@"(null)"])?markModel.house_type:typeString;
        
        self.projectNumberLabel.text = markModel.needs_id;
        self.nameLabel.text = markModel.contacts_name;
        
        self.phoneLabel.text = markModel.contacts_mobile;

        self.decoration_budgetLabel.text = ([markModel.renovation_budget isEqualToString:@"(null)"])?@"":markModel.renovation_budget;
        
        self.design_budgetLabel.text = [NSString stringWithFormat:@"%@",([markModel.design_budget isEqualToString:@"<null>"])?@"":markModel.design_budget];
        self.houseTypeLabel.text = typeString;
        self.houseAreaLabel.text = [NSString stringWithFormat:@"%@㎡",markModel.house_area];
        self.huxingLabel.text = [NSString stringWithFormat:@"%@%@%@",roomChinese,living_room,toiletString];
        self.houseStyleLabel.text = styleString;
        self.addressLabel.text = addressStr;
        self.communityLabel.text = markModel.neighbourhoods;
        self.timeLabel.text = markModel.publish_time;
        
        self.biddingButton.layer.cornerRadius = 5;
        if ([self.type isEqualToString:@"mark"]) {
            
            if ( [[self.biddingStaus description] isEqualToString:@"0"]) {
                [self.biddingButton setTitle:NSLocalizedString(@"I_want_to_be_marked", nil) forState:UIControlStateNormal];
                [self.biddingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                
                
            }else {
                
                [self.biddingButton setTitle:NSLocalizedString(@"Has_been_marked", nil) forState:UIControlStateNormal];
                [self.biddingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                [self.biddingButton.layer setBorderWidth:1.0];
                self.biddingButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
                self.biddingButton.backgroundColor = [UIColor clearColor];
                
                self.biddingButton.enabled = NO;

//                if ([markModel.bidder_count intValue]>=5){
//                    [self.biddingButton setTitle:NSLocalizedString(@"The number is full, can not be marked", nil) forState:UIControlStateNormal];
//                    [self.biddingButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//                    self.biddingButton.enabled = NO;
//                }else {
//                   
//                }
                
                
            }
            
        }else {
            
            if ([markModel.after_bidding_status isEqualToString:@"0"]) {
                [self.biddingButton setTitle:NSLocalizedString(@"End_stress", nil) forState:UIControlStateNormal];
                
                [self.biddingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.biddingButton.hidden = YES;

            }else{
                
                
                self.biddingButton.hidden = YES;
            }
            
            
        }


//        self.biddingButton.hidden = YES;

    }
}

- (IBAction)biddingClick:(id)sender {
    
    if ([self.type isEqualToString:@"mark"]) {
        [self.delegate selectBiddingMothds];

    }else{
        [self.delegate refuseBiddingMothds];

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
