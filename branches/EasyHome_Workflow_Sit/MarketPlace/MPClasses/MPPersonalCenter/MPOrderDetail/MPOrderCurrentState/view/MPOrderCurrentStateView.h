//
//  MPOrderCurrentStateView.h
//  MarketPlace
//
//  Created by Jiao on 16/1/27.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPOrderCurrentStateViewDelegate <NSObject>

- (void)didSelectCellAtIndex:(NSInteger)index;

- (NSInteger)getContractCount;

- (void)initDataBack:(void(^)())back;
@end
@interface MPOrderCurrentStateView : UIView
@property (nonatomic, assign) NSInteger nodeID;
@property (nonatomic, assign) NSInteger flashID;
@property (nonatomic, assign) id<MPOrderCurrentStateViewDelegate> delegate;

- (void)refreshOrderStateView;
@end
