/**
 * @file    MPheadIconTableViewCell.h
 * @brief   the view of MPheadIconTableViewCell cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */


#import <UIKit/UIKit.h>
@protocol HeadIconBtnclickDelegate <NSObject>

@required
/**
 * @brief HeadIconBtnClick:(UIButton *)btn.
 *
 * @param  btn button.
 *
 * @return void.
 */
- (void)HeadIconBtnClick:(UIButton *)btn;
@end

@interface MPheadIconTableViewCell : UITableViewCell
/// head Icon button.
@property (weak, nonatomic) IBOutlet UIButton *headIcon;
/// head Icon button delegate.
@property(strong,nonatomic) id<HeadIconBtnclickDelegate> delegate;
/// upload button.
@property (weak, nonatomic) IBOutlet UIButton *uploadIcon;

@end
