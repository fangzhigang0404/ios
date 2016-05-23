//
//  MPAssertsTransactionCell.m
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPAssertsTransactionCell.h"
#import "MPDesignerTransactionRecordModel.h"
@interface MPAssertsTransactionCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *stausLabel;

@end
@implementation MPAssertsTransactionCell
-(void) updateCellForIndex:(NSUInteger) index
{
    if ([self.delegate respondsToSelector:@selector(getRecordModelForIndex:)])
    {
        MPDesignerTransactionRecordModel *model = [self.delegate getRecordModelForIndex:index];
        self.titleLabel.text = model.name;
        self.nameLabel.text = model.title;
        self.orderNumberLabel.text = model.order_line_id;
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",model.adjustment];
        
        if ([model.type isEqualToString:@"0"]) {
            self.stausLabel.text = @"待支付";
        }else if ([model.type isEqualToString:@"1"]){
            self.stausLabel.text = @"已支付";
        }else if ([model.type isEqualToString:@"2"]) {
            self.stausLabel.text = @"量房转设计";
        }else if ([model.type isEqualToString:@"3"]) {
            self.stausLabel.text = @"已入账";
        }
        self.timeLabel.text = [self bySecondGetDate:model.create_date];
       
    }
}

- (NSString *)bySecondGetDate:(NSString *)second
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateLoca = [NSString stringWithFormat:@"%@",second];
    NSTimeInterval time=[dateLoca doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time/1000];
    NSString *timestr = [formatter stringFromDate:detaildate];
    return timestr;
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
