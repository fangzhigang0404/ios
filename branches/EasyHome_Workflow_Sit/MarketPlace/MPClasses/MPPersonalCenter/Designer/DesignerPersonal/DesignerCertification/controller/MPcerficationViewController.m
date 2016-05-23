/**
 * @file    MPcerficationViewController.h
 * @brief   the view of cerfication view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */


#import "MPcerficationViewController.h"
#import "MPcerficationView.h"
#import "MPcerficationTableViewCell.h"
#import "MPConsumerPersonalCenterViewController.h"
#import "MPreDetailViewController.h"
#import "MPMarketplaceSettings.h"


@interface MPcerficationViewController ()<MPCerficationViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIActionSheet *myActionSheet ;
    UIImage *image;
    NSDictionary *leftDic;
    NSDictionary *rightDic;
    NSDictionary *centerDic;
    UITextField *nameTextfield;
    UITextField *numberTextfield;
    UITextField *id_cardTextfield;


}
@end

@implementation MPcerficationViewController

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MPcerficationView *_view = [[MPcerficationView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.titleLabel.text = @"实名认证";
    self.rightButton.hidden = YES;
    _view.delegate = self;
    [self.view addSubview:_view];
    
}

-(void) CerficationView:(MPcerficationModel *)model withBtn:(UIButton *)btnClick {
    
    NSLog(@"btnClick tag is %ld",btnClick.tag);
    nameTextfield = (UITextField *) [self.view viewWithTag:5];
    numberTextfield = (UITextField *) [self.view viewWithTag:6];
    id_cardTextfield = (UITextField *) [self.view viewWithTag:7];
    NSLog(@"%@%@%@",nameTextfield.text,numberTextfield.text,id_cardTextfield.text);

    if (btnClick.tag == 1 ||btnClick.tag == 2||btnClick.tag == 3) {
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel_Key", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open_camera_key", nil), NSLocalizedString(@"photo_albums_key", nil),nil];
        myActionSheet.tag = btnClick.tag;
        [myActionSheet showInView:self.view];
        NSLog(@"upload...");
    }else if (btnClick.tag == 4) {
        [self submitData:btnClick];
    }

    
}
- (void)submitData:(UIButton *)submit {
    
    MPreDetailViewController *reVC = [[MPreDetailViewController alloc] init];
    if ([self.audit_status isEqualToString:@"0"]) {
        reVC.zeroTitle = nameTextfield.text;
        reVC.secondTitle = numberTextfield.text;
        reVC.fourTitle = id_cardTextfield.text;
        reVC.headDic = centerDic;
        reVC.backDic = leftDic;
        reVC.positiveDic = rightDic;
        
        reVC.audit_status = self.audit_status;
        [self.navigationController pushViewController:reVC animated:YES];
        
    }else if ([self.audit_status isEqualToString:@"2"]){
        reVC.audit_status = self.audit_status;
        [self.navigationController pushViewController:reVC animated:YES];
    }else if ([self.audit_status isEqualToString:@"3"]||[self.audit_status isEqualToString:@"1"]){
        reVC.audit_status = self.audit_status;
        reVC.zeroTitle = nameTextfield.text;
        reVC.secondTitle = numberTextfield.text;
        reVC.fourTitle = id_cardTextfield.text;
        reVC.audit_status = self.audit_status;
        reVC.headDic = centerDic;
        reVC.backDic = leftDic;
        reVC.positiveDic = rightDic;
        if (centerDic != nil &&leftDic != nil &&rightDic!=nil) {
            [self.navigationController pushViewController:reVC animated:YES];
        }else {
            NSString *title;
            if (centerDic == nil) {
                title = NSLocalizedString(@"Photos cannot be empty_key", nil);
                NSLog(@"****************upload*****************");
            }else if (leftDic == nil){
                title = NSLocalizedString(@"Photos cannot be empty_key", nil);
            }else if (rightDic == nil){
                title = NSLocalizedString(@"Photos cannot be empty_key", nil);
            }
            [MPAlertView showAlertWithMessage:title sureKey:^{
            }];
        }
    }else {
        if (centerDic != nil && leftDic!=nil && rightDic!=nil&&[MPcerficationModel checkName:nameTextfield.text]&&[MPcerficationModel checkPhone:numberTextfield.text]&&[MPcerficationModel checkIDNumber:id_cardTextfield.text]) {
            
            NSLog(@"............is %@",nameTextfield.text);
            reVC.zeroTitle = nameTextfield.text;
            reVC.secondTitle = numberTextfield.text;
            reVC.fourTitle = id_cardTextfield.text;
            reVC.headDic = centerDic;
            reVC.backDic = leftDic;
            reVC.positiveDic = rightDic;
            reVC.audit_status = self.audit_status;
            [self.navigationController pushViewController:reVC animated:YES];
            
        }else {
            NSString *title;
            if (![MPcerficationModel checkName:nameTextfield.text]) {
              title = NSLocalizedString(@"The name cannot be empty_key", nil);
            }else if (![MPcerficationModel checkPhone:numberTextfield.text]){
                title = NSLocalizedString(@"The phone can not be empty_key", nil);
            }else if (![MPcerficationModel checkIDNumber:id_cardTextfield.text]){
                title = NSLocalizedString(@"Identity card number cannot be empty_key", nil);
            }else if (image == nil) {
                title = NSLocalizedString(@"Photos cannot be empty_key", nil);
            }else if (image == nil) {
                title = NSLocalizedString(@"Photos cannot be empty_key", nil);
            }else if (image == nil) {
                title = NSLocalizedString(@"Photos cannot be empty_key", nil);
            }else if (image != nil && leftDic == nil) {
                title = NSLocalizedString(@"Upload photos_key", nil);
            }else if (image != nil && rightDic == nil) {
                title = NSLocalizedString(@"Upload photos_key", nil);
            }else if (image != nil && centerDic == nil) {
                title = NSLocalizedString(@"Upload photos_key", nil);
            }
            NSLog(@"****************upload*****************");
            [MPAlertView showAlertWithMessage:title sureKey:^{
            }];
        }
    }

}
- (void)btnLeft:(UIButton *)btnLeft{
    myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel_Key", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open_camera_key", nil), NSLocalizedString(@"photo_albums_key", nil),nil];
    myActionSheet.tag = btnLeft.tag;
    [myActionSheet showInView:self.view];
    NSLog(@"upload...");

}
- (void)actionSheet:(UIActionSheet *)actionSheet  clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /// Click on the menu button after of the response.
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"*****************Cancle******************");
    }
    switch (buttonIndex)
    {
        case 0:  /// open the camera.
            [self takePhoto:actionSheet.tag];
            break;
            
        case 1:  /// Open the local photo album.
            [self LocalPhoto:actionSheet.tag];
            break;
    }
}
/**
 * @brief Began to take pictures.
 *
 * @param tag According to the tag is what kind of images.
 *
 * @return viod.
 */
-(void)takePhoto:(NSInteger)tag
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.view.tag = tag;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"Simulation of camera could not be opened, please use in the real machine");
    }
}

/**
 * @brief Open the local photo album.
 *
 * @param tag According to the tag is what kind of images.
 *
 * @return viod.
 */
-(void)LocalPhoto:(NSInteger)tag
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.view.tag = tag;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

/// when choose a picture to enter here.
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    if ([type isEqualToString:@"public.image"])
    {
        
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        if (picker.view.tag == 1) {
            
            UIButton *btn = (UIButton *)[self.view viewWithTag:1];
            [btn setImage:image forState:UIControlStateNormal];
        }else if (picker.view.tag == 2) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:2];

            [btn setImage:image forState:UIControlStateNormal];
            
        }else {
            UIButton *btn = (UIButton *)[self.view viewWithTag:3];

            [btn setImage:image forState:UIControlStateNormal];
            
        }
        [self uploadServer:picker.view.tag];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)uploadServer:(NSInteger)tag {
    
    [MPcerficationModel GetServiesStringwithSuccess:^(MPcerficationModel *model) {
        
        [self uploadq:model.server withTag:tag];

    } failure:^(NSError *error) {
        
    }];
}
- (void)uploadq:(NSString *)string withTag:(NSInteger)tag{
    
    
    NSUserDefaults *userDefaults= [NSUserDefaults standardUserDefaults];
    NSString *sesion= [userDefaults objectForKey:@"acs_x_session"];
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    NSLog(@"********%@",member.acs_x_session);
    NSDictionary *headField = [NSDictionary dictionaryWithObjectsAndKeys:[MPMarketplaceSettings sharedInstance].afc,@"X-AFC",sesion,@"X-Session", nil];
    NSData *data;
    if (tag == 1) {
        data = UIImagePNGRepresentation(image);
        
    }else if (tag == 2) {
        data = UIImagePNGRepresentation(image);
        
    }else if (tag == 3) {
        data = UIImagePNGRepresentation(image);
    }
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *destDateString = [formatter stringFromDate:[NSDate date]];
    NSArray *arr = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:data,@"data",destDateString,@"name",[NSString stringWithFormat:@"%@.png",destDateString],@"fileName",@"image/png",@"type", nil]];
//        NSLog(@"arr is %@",arr);
    [MPcerficationModel CertificationWithUrl:string withFiles:arr withHeader:headField withSuccess:^(MPcerficationModel *model) {
        
        if (tag == 1) {
            leftDic = [NSDictionary dictionaryWithObjectsAndKeys:model.file_id,@"file_id",model.file_name,@"file_name",model.file_url,@"file_url", nil];
            NSLog(@"file_id is %@",leftDic);
        }else if (tag == 2) {
            rightDic = [NSDictionary dictionaryWithObjectsAndKeys:model.file_id,@"file_id",model.file_name,@"file_name",model.file_url,@"file_url", nil];
            NSLog(@"file_name is %@",rightDic);
        }else if (tag == 3) {
            centerDic = [NSDictionary dictionaryWithObjectsAndKeys:model.file_id,@"file_id",model.file_name,@"file_name",model.file_url,@"file_url", nil];
            NSLog(@"file_url is %@",centerDic);
        }

    } failure:^(NSError *error) {
        NSLog(@"error is :%@",error);
        [MPAlertView showAlertWithMessage:NSLocalizedString(@"Upload photos request timeout_key", nil) sureKey:^{
        }];
    }];
}
@end
