/**
 * @file    MPCaseDetailTableViewCell.m
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-1-26
 */

#import "MPCaseDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MPCaseModel.h"
@interface MPCaseDetailTableViewCell ()
@property (strong,nonatomic) IBOutlet UIButton *closeButton;
@property (strong,nonatomic) IBOutlet UIView *backView;
@property (nonatomic, strong) UILabel *labelInfo;
@end
@implementation MPCaseDetailTableViewCell

- (void)updateCellWithImageUrl:(MPCaseModel *)model {

    model.description_designercase = [NSString stringWithFormat:@"        %@",model.description_designercase];

    NSString *string = [self formatDic:model.description_designercase];
        CGSize titleSize = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
        self.labelInfo.frame = CGRectMake(10, 10, SCREEN_WIDTH-20, titleSize.height);
        self.labelInfo.text = string;
}

- (IBAction)closeClick:(id)sender {
    [self.delegate closeView];
}

- (NSString *)formatDic:(id)obj {
    
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    
    NSString *string =[NSString stringWithFormat:@"%@",obj];
    NSString *strUrl = [string stringByReplacingOccurrencesOfString:@"(null)" withString:@"暂无数据"];
    
    NSString *strUrls = [strUrl stringByReplacingOccurrencesOfString:@"null" withString:@"暂无数据"];
    
    return strUrls;
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.labelInfo = [[UILabel alloc] init];
    self.labelInfo.numberOfLines = 0;
    self.labelInfo.font = [UIFont systemFontOfSize:14.0];
    //    self.labelInfo.backgroundColor = [UIColor whiteColor];
    self.labelInfo.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
  
    [self.backView addSubview:self.labelInfo];

    [self.contentView bringSubviewToFront:self.closeButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
