/**
 * @file    MPDesignerCenterTableViewCell.h
 * @brief   the view of designer Message Center cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>

@protocol headIconBtnClickDelegate <NSObject>

@required
/**
 * @brief headIconBtnClick:(UIButton *)btn cerficationBtnClick:(UIButton *)btnClick.
 *
 * @param  btn button.
 *
 * @param  btnClick button click.
 *
 * @return void.
 */
-(void) headIconBtnClick:(UIButton *)btn cerficationBtnClick:(UIButton *)btnClick;


@end


@interface MPDesignerCenterTableViewCell : UITableViewCell
/// prompt text.
@property (weak, nonatomic) IBOutlet UILabel *tishiLabel;
/// adumit button.
@property (weak, nonatomic) IBOutlet UIButton *adumitBtn;
/// head icon button.
@property (weak, nonatomic) IBOutlet UIButton *headIconBtn;
/// cerfication imageView.
@property (weak, nonatomic) IBOutlet UIImageView *cerfication;
/// admit view.
@property (weak, nonatomic) IBOutlet UIView *adumitView;
/// nick name label.
@property (weak, nonatomic) IBOutlet UILabel *nick_Name;
/// image view.
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/// head icon button click delegate.
@property(strong,nonatomic) id<headIconBtnClickDelegate> delegate;

@end
