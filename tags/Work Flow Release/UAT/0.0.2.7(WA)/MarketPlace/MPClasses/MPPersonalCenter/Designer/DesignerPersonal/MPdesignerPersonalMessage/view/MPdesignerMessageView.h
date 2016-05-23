/**
 * @file    MPdesignerMessageView.h
 * @brief   the view of MPdesignerMessageView view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>

@class MPMemberModel;
@protocol MPFindConsumerDelegate <NSObject>

@required
/**
 * @brief tableViewSection:(NSInteger)section withTableViewRow:(NSInteger)row withTitle:(NSString *)title withRight:(NSString *)rithtTitle withBtn:(UIButton *)btn.
 *
 * @param  section tableView section.
 *
 * @param  row tableView row.
 *
 * @param  title left text.
 *
 * @param  rithtTitle right text.
 *
 * @param  btn button.
 *
 * @return void.
 */
- (void)tableViewSection:(NSInteger)section withTableViewRow:(NSInteger)row withTitle:(NSString *)title withRight:(NSString *)rithtTitle withBtn:(UIButton *)btn;
@end
@interface MPdesignerMessageView : UIView

/// self delegate.
@property(strong,nonatomic) id<MPFindConsumerDelegate> delegate;
/// upData model data and Image.
- (void)mutavleDcitionary:(MPMemberModel *)model andIMG:(UIImage *)image;

@end
