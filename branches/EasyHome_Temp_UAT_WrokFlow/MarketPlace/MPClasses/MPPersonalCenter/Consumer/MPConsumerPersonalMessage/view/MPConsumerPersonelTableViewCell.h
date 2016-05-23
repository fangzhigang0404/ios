/**
 * @file    MPConsumerPersonelTableViewCell.h
 * @brief   the view of MPConsumerCenterView cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>
@protocol MPFindDesignersTableViewCellDelegate <NSObject>

@required
/**
 * @brief BtnClickConsumer:(UIButton *)btn.
 *
 * @param  btn button.
 *
 * @return void.
 */
-(void) BtnClickConsumer:(UIButton *)btn;

@end
@interface MPConsumerPersonelTableViewCell : UITableViewCell
{
    
    __weak IBOutlet UIImageView *_imgView; //!< consumer center backImage ImgView.
    __weak IBOutlet UIButton *_headButton; //!< consumer center headButton.
}
/// consumer center nickname.
@property (weak, nonatomic) IBOutlet UILabel *nickName;
/// consumer center headIcon.
@property (weak, nonatomic) IBOutlet UIButton *button;
/// self delegate.
@property(strong,nonatomic) id<MPFindDesignersTableViewCellDelegate> delegate;

@end
