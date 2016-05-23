/**
 * @file    MPConsumerTableViewCell.h
 * @brief   the view of MPConsumerTableViewCell cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>


@interface MPConsumerTableViewCell : UITableViewCell
/// consumer center cell lableText.
@property (weak, nonatomic) IBOutlet UILabel *lableText;
/// consumer center cell left ImgView.
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
/// consumer center cell right ImgView.
@property (weak, nonatomic) IBOutlet UIImageView *rightView;

@end
