//
//  MPDesignContractDetailView.h
//  MarketPlace
//
//  Created by Jiao on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPDesignContractDetailViewDeleagate <NSObject>


@end
@interface MPDesignContractDetailView : UIView <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong) UITableView *conTableView;
@property (nonatomic,strong) id<MPDesignContractDetailViewDeleagate>deleage;
- (void)refreshContractView;
@end
