/**
 * @file    MPcerficationView.h
 * @brief   the view of cerfication View  view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>
#import "MPcerficationModel.h"
@protocol MPCerficationViewDelegate <NSObject>

@required
/**
 * @brief Cerfication:(MPcerficationModel *)model withBtn:(UIButton *)btnClick.
 *
 * @param  model updata model.
 *
 * @param  btnClick button.
 *
 * @return void.
 */
-(void) CerficationView:(MPcerficationModel *)model withBtn:(UIButton *)btnClick;

@end
@interface MPcerficationView : UIView
/// self delegate.
@property(strong,nonatomic) id<MPCerficationViewDelegate> delegate;

@end
