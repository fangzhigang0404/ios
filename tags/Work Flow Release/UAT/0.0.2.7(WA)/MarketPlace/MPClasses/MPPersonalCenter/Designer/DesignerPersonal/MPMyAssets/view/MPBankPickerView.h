//
//  MPBankPickerView.h
//  MarketPlace
//
//  Created by Jiao on 16/2/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPBankPickerViewDelegate <NSObject>

- (void)closePickView;
- (void)selectedBankWithName:(NSString *)name;

@end

@interface MPBankPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) id<MPBankPickerViewDelegate> delegate;
@end
