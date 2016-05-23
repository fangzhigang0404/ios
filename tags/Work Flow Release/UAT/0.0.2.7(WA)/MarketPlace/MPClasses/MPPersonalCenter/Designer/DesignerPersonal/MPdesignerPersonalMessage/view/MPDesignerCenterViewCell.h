/**
 * @file    MPDesignerCenterViewCell.h
 * @brief   the view of designer Message Center cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>

@interface MPDesignerCenterViewCell : UITableViewCell
/// designer left label.
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
/// designer right image.
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
/// designer right image.
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@end
