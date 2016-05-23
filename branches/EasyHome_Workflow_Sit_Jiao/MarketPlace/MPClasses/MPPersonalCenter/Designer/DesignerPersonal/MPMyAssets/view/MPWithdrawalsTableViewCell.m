//
//  MPWithdrawalsTableViewCell.m
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPWithdrawalsTableViewCell.h"
#import "MPDesignerWithdrawModel.h"
@interface MPWithdrawalsTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *bank_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *stausLabel;
@end

@implementation MPWithdrawalsTableViewCell
{


    __weak IBOutlet UIView *_bottomView;
    __weak IBOutlet NSLayoutConstraint *_bottomConstraintH;
    __weak IBOutlet UITextView *_noteTextView;
}
-(void) updateCellForIndex:(NSUInteger) index
{
    if ([self.delegate respondsToSelector:@selector(getWithdrawModelForIndex:)])
    {
        MPDesignerWithdrawModel *model = [self.delegate getWithdrawModelForIndex:index];
        self.bank_nameLabel.text = [NSString stringWithFormat:@"%@",model.bank_name];
        
        //0处理中,1处理成功,2处理失败,-1未处理
        
     
        switch ([model.status integerValue]) {
            case 0:
            {
                self.stausLabel.text = @"处理中";
            }
                break;
            case 1:
            {
                self.stausLabel.text = @"处理成功";
            }
                break;
            case 2:
            {
                self.stausLabel.text = @"处理失败";
            }
                break;
            case -1:
            {
                self.stausLabel.text = @"未处理";
            }
                break;
            default:
                break;
        }
    
        self.timeLabel.text = model.timeString;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.amount];
        self.numberLabel.text = model.transLog_id;
        
        if ([model.remark isEqualToString:@"<null>"]) {
            _bottomView.hidden = YES;
            _bottomConstraintH.constant = 0;
        }else {
            _noteTextView.text = [NSString stringWithFormat:@"备注:%@",model.remark];

        }
    }
}

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _noteTextView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1].CGColor;
    _noteTextView.layer.borderWidth = 1.0f;
    
    
    ///如果没有备注
//    _bottomView.hidden = YES;
//    _bottomConstraintH.constant = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
