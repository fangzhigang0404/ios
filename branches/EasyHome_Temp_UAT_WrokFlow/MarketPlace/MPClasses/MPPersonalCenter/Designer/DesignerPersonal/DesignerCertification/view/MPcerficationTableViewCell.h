/**
 * @file    MPcerficationTableViewCell.h
 * @brief   the view of cerfication cell view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import <UIKit/UIKit.h>
#import "MPcerficationModel.h"
@protocol MPCerficationDelegate <NSObject>

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
-(void) Cerfication:(MPcerficationModel *)model withBtn:(UIButton *)btnClick;

@end
@interface MPcerficationTableViewCell : UITableViewCell<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UIActionSheetDelegate>

{
    __weak IBOutlet UITextField *nameTextField;     //!< name textField.
    __weak IBOutlet UITextField *numberTextField;   //!< number textFiels.
    __weak IBOutlet UITextField *ID_cardTextField;  //!< ID card textfield.
}
/// ID card positive button.
@property (weak, nonatomic) IBOutlet UIButton *ID_cardPositive;
/// ID card reverse button.
@property (weak, nonatomic) IBOutlet UIButton *ID_cardReverse;
/// ID card handheld button.
@property (weak, nonatomic) IBOutlet UIButton *ID_cardHandheld;
/// cerficition submit button.
@property (weak, nonatomic) IBOutlet UIButton *submit;
/// self delegate.
@property(strong,nonatomic) id<MPCerficationDelegate> delegate;

@end
