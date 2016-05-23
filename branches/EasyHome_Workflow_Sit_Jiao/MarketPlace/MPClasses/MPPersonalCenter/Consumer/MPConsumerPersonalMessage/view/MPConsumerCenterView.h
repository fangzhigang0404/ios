/**
 * @file    MPConsumerCenterView.h
 * @brief   the view of MPConsumerCenterView.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>
@class MPMemberModel;
@protocol MPFindDesignersDelegate <NSObject>

@required
/**
 * @brief BtnClickConsumer:(UIButton *)btn.
 *
 * @param  btn button.
 *
 * @return void.
 */
- (void)BtnClickConsumer:(UIButton *)btn;
/**
 * @brief tableViewSection:(NSInteger)section withTableViewRow:(NSInteger)row.
 *
 * @param  section tableView section.
 *
 * @param  row tableView row.
 *
 * @return void.
 */
- (void)tableViewSection:(NSInteger)section withTableViewRow:(NSInteger)row;
@end

@interface MPConsumerCenterView : UIView


/// headIcon button.
@property (nonatomic,strong)UIButton *btnButton;
/// self delegate.
@property(strong,nonatomic) id<MPFindDesignersDelegate> delegate;
/// updata model Data.
- (void)reloadData:(MPMemberModel *)model;
@end
