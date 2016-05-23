//
//  MPMyProjectInfoView.h
//  MarketPlace
//
//  Created by xuezy on 16/3/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum :  NSInteger {
    ProjectTypeForNone = 0,
    ProjectTypeForMeasureList,//量房表单
    ProjectTypeForMeasureDelivery,//量房交付
    ProjectTypeForContract,//设计合同
    ProjectTypeForDesignDelivery//设计交付
}MPProjectInfoType;

@protocol MPMyProjectInfoViewDelegate <NSObject>

@required
- (void)didSelectItemWthType:(MPProjectInfoType)type;



- (void)myProjectInfoViewRefreshLoadNewData:(void(^) ())finish;

@end

@interface MPMyProjectInfoView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic)id<MPMyProjectInfoViewDelegate>delegate;

- (void) refreshMyProjectInfoWithType:(MPProjectInfoType)type;

@end
