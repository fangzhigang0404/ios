/**
 * @file    MPdesignerMessageTableViewCell.h
 * @brief   the view of designer Message Center cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>

@protocol headIconBtnClickBtnDelegate <NSObject>
/**
 * @brief headBtnClick:(UIButton *)headBtn.
 *
 * @param  headBtn head button click.
 * @return void.
 */
- (void)headBtnClick:(UIButton *)headBtn;

@end

@interface MPdesignerMessageTableViewCell : UITableViewCell
/// up button.
@property (weak, nonatomic) IBOutlet UIButton *upBtn;
/// head icon button click.
@property (weak, nonatomic) IBOutlet UIButton *headIconBtnClick;
/// head button click delegate.
@property (strong,nonatomic) id<headIconBtnClickBtnDelegate>delegate;
@end
