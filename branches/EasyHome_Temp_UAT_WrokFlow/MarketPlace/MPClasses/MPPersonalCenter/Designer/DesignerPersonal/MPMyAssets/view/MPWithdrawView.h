//
//  MPWithdrawView.h
//  MarketPlace
//
//  Created by Jiao on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPDesignerBankInfo;
@protocol MPWithdrawViewDelegate <NSObject>

@required
- (void)confirmWithModel:(MPDesignerBankInfo *)model;

@end
@interface MPWithdrawView : UIView

@property (nonatomic, weak) id<MPWithdrawViewDelegate> delegate;

- (void)updateViewWithDataIsEmpty:(BOOL)empty andModel:(MPDesignerBankInfo *)model;
@end
