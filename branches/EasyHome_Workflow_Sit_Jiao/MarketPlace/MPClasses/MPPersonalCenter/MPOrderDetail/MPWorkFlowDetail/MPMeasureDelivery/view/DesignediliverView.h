//
//  DesignediliverView.h
//  MarketPlace
//
//  Created by zzz on 16/3/16.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DesignedeliverCell.h"
@protocol DesignediliverViewdelegate <NSObject>

@end

@interface DesignediliverView : UIView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)id<DesignediliverViewdelegate>delegate;
@property (nonatomic,assign)BOOL sel;
- (void)initView;

@end
