//
//  MPDeliveryBaseCell.h
//  MarketPlace
//
//  Created by Jiao on 16/3/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPDeliveryBaseCellDelegate <NSObject>

- (NSDictionary *)updateUI;

- (void)sendDelivery;

- (void)goToDeliveryDetailForIndex:(NSInteger)index;
@end
@interface MPDeliveryBaseCell : UITableViewCell
{
    
    __weak IBOutlet UILabel *_nameLabel;
    
    __weak IBOutlet UIButton *_sendBtn;
}
@property (nonatomic, weak) id<MPDeliveryBaseCellDelegate> delegate;

- (void)updateCellForIndex:(NSInteger)index;

- (void)deliveryDetailClick:(UITapGestureRecognizer *)sender;
@end
