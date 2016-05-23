/**
 * @file    MPdesigenTableViewCell.h
 * @brief   the view of designer Message Center cell.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>
#import "MPMemberModel.h"
@interface MPdesigenTableViewCell : UITableViewCell
/// cell left text.
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
/// cell right text.
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
/// cell right image.
@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;
/// member model data.
@property (nonatomic,strong)MPMemberModel *model;
@end
