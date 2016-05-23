//
//  DesignedeliverCell.h
//  MarketPlace
//
//  Created by zzz on 16/3/16.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DesignedeliverCelldeletegate <NSObject>

- (void)SentBtn:(UIButton *)Sentbtn;
- (void)SeliveryBtn:(UIButton *)seliverBtn;
@end

@interface DesignedeliverCell : UITableViewCell

@property (nonatomic,strong)id<DesignedeliverCelldeletegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *SentBtn;
@property (nonatomic,assign)BOOL sel;

@end
