/**
 * @file    MPdesignerView.h
 * @brief   the view of designer Message Center view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>

@class MPMemberModel;
@protocol headIconBtnClickDelegate <NSObject>

@required
/**
 * @brief headIconBtnClickButton:(UIButton *)btn withSection:(NSInteger)section andRow:(NSInteger)row withTitle:(NSString *)title andLeft:(NSString *)string.
 *
 * @param  btn button.
 *
 * @param  section tableView section.
 *
 * @param  row tableView row.
 *
 * @param  title cell right text.
 *
 * @param  title cell left text.
 *
 * @return void.
 */
-(void) headIconBtnClickButton:(UIButton *)btn withSection:(NSInteger)section andRow:(NSInteger)row withTitle:(NSString *)title andLeft:(NSString *)string;

@end
@interface MPdesignerView : UIView
/// head icon buttonClick delegate.
@property (strong,nonatomic)id<headIconBtnClickDelegate>delegate;
/// updata model and Image.
- (void)reloadData:(MPMemberModel *)model andIMG:(UIImage *)image;
@end
