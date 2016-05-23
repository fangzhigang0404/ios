//
//  MPcreatcontractcellTwo.h
//  MarketPlace
//
//  Created by zzz on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPStatusDetail,MPDesignContractModel;
@protocol MPDesignContractCellDeleagate <NSObject>
@required
- (void)Sendbtn:(MPDesignContractModel *)model;
- (void)detailsBtn:(MPDesignContractModel *)model;
- (MPDesignContractModel *)updateCell;
- (MPStatusDetail *)updateCellUI;
- (void)textFieldFrame:(CGRect)frame;
- (void)addrY:(CGFloat)y_dif;
@end

@interface MPDesignContractCell : UITableViewCell
@property (nonatomic,weak) id<MPDesignContractCellDeleagate>deleage;
@property (weak, nonatomic) IBOutlet UIButton *SelectBtn;
@property (weak, nonatomic) IBOutlet UILabel *ReadLab;
- (void)updateCellForIndex:(NSInteger)index;

@end
