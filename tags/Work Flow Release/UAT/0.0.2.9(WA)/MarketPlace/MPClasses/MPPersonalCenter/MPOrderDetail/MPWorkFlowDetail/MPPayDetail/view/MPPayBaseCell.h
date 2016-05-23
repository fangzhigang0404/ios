//
//  MPPayBaseCell.h
//  MarketPlace
//
//  Created by Jiao on 16/3/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPStatusModel.h"
#import "MPPaymentModel.h"

@protocol MPPayBaseCellDelegate <NSObject>

- (MPStatusModel *)updateCellData;
- (MPStatusDetail *)updateCellUI;
- (void)goToAlipay;

@end
@interface MPPayBaseCell : UITableViewCell
{
    __weak IBOutlet NSLayoutConstraint *payConstraintBottom;
    __weak IBOutlet UILabel *_orderNumber;
    __weak IBOutlet UILabel *_nameLabel;
    __weak IBOutlet UILabel *_mobilePhone;
    __weak IBOutlet UIButton *payBtn;
    
    NSString * _orderid;
    NSString * _orderline;
}
@property (nonatomic, weak) id<MPPayBaseCellDelegate> delegate;
- (IBAction)alipayBtnClick:(id)sender;

- (void)updateDetailCellForIndex:(NSInteger)index;
- (void)updateCellDataWithModel:(MPStatusModel *)model;
- (NSString *)moneyFormat:(NSNumber *)num;
@end
