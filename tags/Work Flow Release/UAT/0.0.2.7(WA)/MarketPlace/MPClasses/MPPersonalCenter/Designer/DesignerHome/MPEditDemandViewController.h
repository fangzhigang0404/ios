//
//  MPDesignerDetails.h
//  MarketPlace
//
//  Created by zzz on 15/12/29.
//  Copyright © 2015年 xuezy. All rights reserved.
//

#import "MPBaseViewController.h"
#import "MPMarkHallModel.h"
@interface MPEditDemandViewController : MPBaseViewController

@property (strong,nonatomic) MPMarkHallModel *markModel;
@property (strong,nonatomic) NSString *needs_id;
@property (copy,nonatomic) NSString *type;
@property (copy,nonatomic) NSString *leftTitle;
@property (assign,nonatomic) BOOL isRealName;
@property (copy,nonatomic)NSString *biddingStaus;
@end
