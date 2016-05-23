//
//  MPProjectTableViewCell.h
//  MarketPlace
//
//  Created by xuezy on 16/1/20.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPDesignerOrderModel.h"
@interface MPProjectTableViewCell : UITableViewCell
@property (nonatomic,strong)IBOutlet UILabel *projectNumberLabel;
@property (nonatomic,strong)IBOutlet UILabel *projectNameLabel;
@property (nonatomic,strong)IBOutlet UILabel *houseTypeLabel;
@property (nonatomic,strong)IBOutlet UILabel *styleLabel;
@property (nonatomic,strong)IBOutlet UILabel *projectStatusLabel;
@property (nonatomic,strong)IBOutlet UIButton *projectDetailButton;
@property (nonatomic,strong)IBOutlet UIButton *needsDetailButton;
@property (nonatomic,strong)IBOutlet UILabel *addressLabel;
@property (nonatomic,strong)MPDesignerOrderModel *model;

- (void)upLoadData;
@end
