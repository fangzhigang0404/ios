/**
 * @file    MPBeishuTableViewCell.m
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-01-20
 */

#import "MPBeishuTableViewCell.h"
#import "MPChatRoomViewController.h"
#import "UIImageView+WebCache.h"
#import "MPRegionManager.h"
@implementation MPBeishuTableViewCell


- (void)upLoadData {
    
    /// 截取小区地址.
//    NSArray *array = [self.model.neighbourhoods componentsSeparatedByString:@"-"];
    self.titleLabel.text = self.model.neighbourhoods;
    self.projectNumberLabel.text = [NSString stringWithFormat:@"%@  %@",NSLocalizedString(@"Item_number_key", nil),self.model.needs_id];
    self.nameLabel.text = [NSString stringWithFormat:@"%@   %@",NSLocalizedString(@"beishu_name_key", nil),self.model.nameString];
    self.memberNameLabel.text = self.model.nameString;

    self.phoneLable.text = [NSString stringWithFormat:@"%@  %@",NSLocalizedString(@"Contact phone number_key", nil),self.model.phone];
    
//    NSDictionary *addressDict = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:self.model.province withCityCode:self.model.city andDistrictCode:self.model.district];
//  
//    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",NSLocalizedString(@"project_address_key", nil),[self formatDic:addressDict[@"province"]],[self formatDic:addressDict[@"city"]],[self formatDic:addressDict[@"district"]]];
    self.addressLabel.text = [NSString stringWithFormat:@"%@  %@%@%@",NSLocalizedString(@"project_address_key", nil),self.model.province,self.model.city,self.model.district];
    self.communityLabel.text = [NSString stringWithFormat:@"%@  %@",NSLocalizedString(@"Address in detail", nil),self.model.neighbourhoods];
    
    self.chatButton.layer.cornerRadius = 5;
    
    [self.memberAvatar sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
}
- (NSString *)formatDic:(id)obj {

    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }

    NSString *string =[NSString stringWithFormat:@"%@",obj];
    NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"(null)" withString:@""];

    NSString *strUrls = [strUrl stringByReplacingOccurrencesOfString:@"null" withString:@""];

    return strUrls;
}

- (IBAction)chatClick:(id)sender {
    NSLog(@"%@",self.model.beishu_thread_id);
    if ([self.model.consumer_id isEqualToString:@"(null)"]) {
//        [MPAlertView showAlertWithMessage:@"consumer_id 为null" sureKey:^{
//            
//        }];
    }else if ([self.model.beishu_thread_id isEqualToString:@"(null)"]) {
//        [MPAlertView showAlertWithMessage:@"beishu_thread_id 为null" sureKey:^{
//            
//        }];
    }else if ([self.model.nameString isEqualToString:@"(null)"]) {
//        [MPAlertView showAlertWithMessage:@"nameString 为null" sureKey:^{
//            
//        }];
    }else if ([self.model.needs_id isEqualToString:@"(null)"]) {
//        [MPAlertView showAlertWithMessage:@"needs_id 为null" sureKey:^{
//            
//        }];
    }else{
        MPChatRoomViewController*ctrl = [[MPChatRoomViewController alloc]
                                         initWithThread:self.model.beishu_thread_id
                                         withReceiverId:self.model.consumer_id
                                         withReceiverName:self.model.nameString
                                         withAssetId:nil
                                         loggedInUserId:[MPMember shareMember].acs_member_id];
        
        [[self viewController].navigationController pushViewController:ctrl animated:YES];
    }
        
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }return nil;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.memberAvatar.clipsToBounds = YES;
    self.memberAvatar.layer.cornerRadius = 25.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
