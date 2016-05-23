/**
 * @file    MPdesignerUpTableViewCell.h
 * @brief   the view of designer Message Center cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>

@interface MPdesignerUpTableViewCell : UITableViewCell

/// designer left label text.
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
/// designer right label text.
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
/// designer rignt image view.
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end
