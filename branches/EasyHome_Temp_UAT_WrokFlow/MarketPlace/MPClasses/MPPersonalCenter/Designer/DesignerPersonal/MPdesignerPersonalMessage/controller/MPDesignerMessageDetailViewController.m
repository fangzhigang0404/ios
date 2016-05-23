/**
 * @file    MPDesignerMessageDetailViewController.m
 * @brief   the view of MPConsumerCenterMessage view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPDesignerMessageDetailViewController.h"
#import "MPdesignerMessageView.h"
#import "AppController.h"
#import "MPMemberModel.h"
#import "MPnameViewController.h"
#import "UIButton+WebCache.h"
#import "MPQRCodeGenerate.h"
#import "MPUIImageView.h"
#import <UIImageView+WebCache.h>
#import "MPAddressSelectedView.h"
#import "MPRegionManager.h"
#import "MPPickerView.h"
#import "MPCenterTool.h"

@interface MPDesignerMessageDetailViewController ()<MPFindConsumerDelegate,PassTrendValueDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,MPAddressSelectedDelegate>
{
    MPdesignerMessageView *designView;   //!< The consumer view.
    NSString *nick_name;                 //!< nickName string.
    NSString *email;                     //!< email string.
    UIImage *image;                      //!< selected upload photo.
    UIActionSheet *myActionSheet;        //!< UIActionSheet.
    UIButton *button;
    NSString *avatar;                    //!< head icon.
    MPMemberModel *_tempModel;           //!< MPMember model.
    MPPickerView *_picker;
    MPAddressSelectedView *pickView;     //!< address selected view.
    UILabel *addressLabel;               //!< address label.
}
@end

@implementation MPDesignerMessageDetailViewController
- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    designView = [[MPdesignerMessageView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    designView.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"The basic information_key", nil);
    
    [self.view addSubview:designView];

    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 1;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    [self requestData];
}
- (void)requestData{
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
   
    NSString *member_id = member.acs_member_id;
    
    [MPMemberModel MemberInformation:member_id withSuccess:^(MPMemberModel *model) {

        [MPCenterTool savePersonCenterInfo:model];

        _tempModel = model;
        dispatch_async(dispatch_get_main_queue(), ^{
            [designView mutavleDcitionary:model andIMG:nil];
        });
        
    } failure:^(NSError *error) {
        NSLog(@"当前没有网络连接");
        
        MPMemberModel *model = [MPCenterTool getPersonCenterInfo];
                
        [designView mutavleDcitionary:model andIMG:nil];
    }];
    

}
- (void)tableViewSection:(NSInteger)section withTableViewRow:(NSInteger)row withTitle:(NSString *)title withRight:(NSString *)rithtTitle withBtn:(UIButton *)btn{
    if (section == 0 && row == 0) {
        
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel_Key", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open_camera_key", nil), NSLocalizedString(@"photo_albums_key", nil),nil];
        [myActionSheet showInView:self.view];
        
    }
    
    if ((section == 1 && row == 0)||(section == 1 && row == 4)) {
        MPnameViewController *reVC = [[MPnameViewController alloc] init];
        if (row == 4) reVC.isSex = YES;
        reVC.titleString = title;
        reVC.nameString = rithtTitle;
        reVC.trendDelegate = self;
        [self.navigationController pushViewController:reVC animated:YES];
    }
    if (section == 1 && row == 2) {
        [self createQRCodeView];
        
        return;
    }
    if (section == 1 && row == 5) {
        [self _selectAddress];
    }
}
- (void)_selectAddress {
    
    [self showMyPicker];
    
    if (pickView==nil) {
        
        pickView = [[MPAddressSelectedView alloc] initPickview];
        
    }
    
    pickView.delegate = self;
    
    
    [pickView show];
    
}

- (void)showMyPicker {
    
    

    [self.view addSubview:self.maskView];
//    [self.view bringSubviewToFront:self.maskView];
    self.maskView.alpha = 0.4;
    [UIView animateWithDuration:0.3 animations:^{
        pickView.frame = CGRectMake(0, SCREEN_HEIGHT-pickView.frame.size.height, SCREEN_WIDTH, pickView.frame.size.height);
        
    }];
    
}

- (void)hideMyPicker {
    
    self.maskView.alpha = 0 ;
    [UIView animateWithDuration:0.3 animations:^{
        pickView.frame = CGRectMake(0, SCREEN_HEIGHT+pickView.frame.size.height, SCREEN_WIDTH, pickView.frame.size.height);
        
        
        
    } completion:^(BOOL finished) {
        [pickView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
    
    
}

#pragma mark MPAddressSelectedDelegate
- (void)selectedAddressinitWithProvince:(NSString *)province withCity:(NSString *)city withTown:(NSString *)town isCertain:(BOOL)isCertain {
    
    [self hideMyPicker];
    if (isCertain) {
        
        NSDictionary *addressDict = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:province withCityCode:city andDistrictCode:town];
        
        NSString *resultString = [NSString stringWithFormat:@"%@-%@-%@",addressDict[@"province"],addressDict[@"city"],addressDict[@"district"]];
        self.provice = province;
        self.city = city;
        self.provice_name = addressDict[@"province"];
        self.city_name = addressDict[@"city"];
        
        if ([town isEqualToString:@" "]) {
            self.district_name = @"none";
            self.district = @"0";
            
        }else {
            
            self.district = town;
            self.district_name = [NSString stringWithFormat:@"%@",addressDict[@"district"]];
        }

        addressLabel.text = resultString;
        addressLabel.textColor = [UIColor blackColor];
        _tempModel.province = province;
        _tempModel.district = town;
        _tempModel.city = city;
        
        [designView mutavleDcitionary:_tempModel andIMG:nil]; 
        
        [self updateMemberInformation:province withCity:city withTown:town MemberInformation:self.provice_name withCity:self.city_name withTown:self.district_name];
        
    }else{
        
    }
    
}
- (void)createQRCodeView {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    
    
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    NSDictionary *inforDict = [NSDictionary dictionaryWithObjectsAndKeys:member.mobile_number,@"mobile_number",_tempModel.nick_name,@"name",member.acs_member_id,@"member_id",_tempModel.avatar,@"avatar",member.memberType,@"member_type",member.hs_uid,@"hs_uid", nil];

    if (_tempModel.nick_name.length == 0) {
        [MPAlertView showAlertWithMessage:NSLocalizedString(@"Data is empty_key", nil) sureKey:nil];
        return;
    }
    
    NSLog(@"member information:%@",inforDict);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inforDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *informationString= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[MPQRCodeGenerate shareQRCodeGenerate] createQRCodeWithString:informationString complete:^(UIImage *QRImage) {
        
        UIImageView *closeImageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2+200, NAVBAR_HEIGHT+120, 26, 26)];
        closeImageview.image = [UIImage imageNamed:QR_CLOSE];
        [backgroundView addSubview:closeImageview];
        
        UIImageView *QRCodeImageview = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-200)/2, NAVBAR_HEIGHT+150,200, 200)];
        QRCodeImageview.image = QRImage;
        QRCodeImageview.layer.cornerRadius = 5.0f;
        [backgroundView addSubview:QRCodeImageview];
        
        MPUIImageView *iconImageview = [[MPUIImageView alloc] initWithFrame:CGRectMake(0, 0, 90, 90) withRadius:8.0 withBoderWidth:5 andBorderColor:[UIColor whiteColor]];
        iconImageview.center = QRCodeImageview.center;
        //            iconImageview.image = [UIImage imageNamed:@"bb"];
        [iconImageview sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
        
        // [backgroundView addSubview:iconImageview];
        UILabel *titleStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+350, SCREEN_WIDTH, 30)];
        titleStringLabel.text = NSLocalizedString(@"sao_ma_beishu", nil);
        titleStringLabel.textColor = [UIColor whiteColor];
        titleStringLabel.textAlignment = NSTextAlignmentCenter;
        titleStringLabel.font = [UIFont systemFontOfSize:14.0];
        [backgroundView addSubview:titleStringLabel];
    }];
    
    
    //    backgroundView.backgroundColor=[UIColor blackColor];
    [window addSubview:backgroundView];
    
    //    backgroundView.alpha = 0.8f;
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    
    [backgroundView addGestureRecognizer: tap];
    
    
    [UIView
     animateWithDuration:0.3
     
     animations:^{
         
         backgroundView.backgroundColor = [[UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1] colorWithAlphaComponent:0.6f];
         
     }
     completion:^(BOOL finished) {
         
         
     }];
    
    
}

-(void)hideImage:(UITapGestureRecognizer*)tap{
    
    UIView *backgroundView=tap.view;
    [UIView
     animateWithDuration:0.3
     
     animations:^{
         
         backgroundView.alpha = 0;
         
     }
     completion:^(BOOL finished) {
         [backgroundView removeFromSuperview];
     }];
    
}

-(void)passTrendValues:(NSString *)values andtitle:(NSString *)title {
    NSLog(@"%@%@",values,title);
    if ([title isEqualToString:NSLocalizedString(@"nickname_key", nil)]) {
        _tempModel.nick_name = values;
        
    }if ([title isEqualToString:NSLocalizedString(@"gender_key", nil)]) {
        _tempModel.gender = values;
    }if ([title isEqualToString:NSLocalizedString(@"home_key", nil)]) {
        _tempModel.address = values;
    }

    [self updateMemberInformation:nil withCity:nil withTown:nil MemberInformation:nil withCity:nil withTown:nil];
}

/// Address update membership information.
- (void)updateMemberInformation:(NSString *)province withCity:(NSString *)city withTown:(NSString *)town MemberInformation:(NSString *)province_name withCity:(NSString *)city_name withTown:(NSString *)town_name{

    
    
        NSString *_gender;
        if ([_tempModel.gender isEqualToString:NSLocalizedString(@"wemenKey", nil)]) {
            _gender = @"1";
        }else if ([_tempModel.gender isEqualToString:NSLocalizedString(@"menKey", nil)]){
            _gender = @"2";
        }else {
            _gender = @"0";
        }
    NSString *url;
        if (url == nil) {
            url = _tempModel.avatar;
        }
    if (province == nil) {
        province = _tempModel.province;
    }if (city == nil) {
        city = _tempModel.city;
    }if (town == nil) {
        town = _tempModel.district;
    }if (province_name == nil) {
        province_name = _tempModel.province_name;
    }if (city_name == nil) {
        city_name = _tempModel.city_name;
    }if (town_name == nil) {
        town_name = _tempModel.district_name;
    }
    
    if (_gender          == nil ||
    _tempModel.nick_name == nil ||
        url              == nil ||
        province         == nil ||
        city             == nil ||
        town             == nil ||
        province_name         == nil ||
        city_name             == nil ||
        town_name             == nil) {
        [MPAlertView showAlertForParameterError];
        return;
    }

    
    if (_tempModel.nick_name!=nil)
        _tempModel.nick_name=[_tempModel.nick_name stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([_tempModel.home_phone isEqualToString:@"<null>"]||_tempModel.home_phone == nil) {
        _tempModel.home_phone = @"";
    }
    if ([_tempModel.birthday isEqualToString:@"<null>"]||_tempModel.birthday == nil) {
        _tempModel.birthday = @"";
    }
    if ([_tempModel.zip_code isEqualToString:@"<null>"]||_tempModel.zip_code == nil) {
        _tempModel.zip_code = @"";
    }

        NSDictionary *param = @{@"gender":_gender,
                                @"nick_name":_tempModel.nick_name,
                                @"avatar":url,
                                @"address":_tempModel.address,
                                @"province":province,
                                @"city":city,
                                @"district":town,
                                @"home_phone":_tempModel.home_phone,
                                @"birthday":_tempModel.birthday,
                                @"zip_code":_tempModel.zip_code,
                                @"province_name":province_name,
                                @"city_name":city_name,
                                @"district_name":town_name};
    
        NSLog(@"param is %@",param);
        NSLog(@"url is %@",url);
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *member_id = member.member_id;

        [MPMemberModel UpdataMemberInformation:member_id withParam:param withSuccess:^(MPMemberModel *model) {
            
                NSLog(@"icon image url :%@",url);
                [designView mutavleDcitionary:_tempModel andIMG:nil];

        } failure:^(NSError *error) {
            NSLog(@"error is ********************%@",error);
        }];

}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet:(UIActionSheet *)actionSheet  clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    /// Click on the menu button after of the response.
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"**********CANCLE**********");
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

#pragma mark -- UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:@"public.image"])
    {
        UIImage  *oldImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        NSData *dataImage;
        
        if (UIImagePNGRepresentation(oldImage) == nil)
        {
            dataImage = UIImageJPEGRepresentation(oldImage, 0.0);
        }
        else
        {
            dataImage = UIImagePNGRepresentation(oldImage);
        }
        image = [self imageWithImageSimple:oldImage scaledToSize:CGSizeMake(200, 200)];
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [designView mutavleDcitionary:_tempModel andIMG:image];
//        });
        
        [self updatePhoto];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}
- (void)updatePhoto {
    
    NSDictionary *heard = [MPMemberModel getHeaderAuthorization];
    NSData *dataImage;
    dataImage = UIImagePNGRepresentation(image);
    
    [MPMemberModel updataMembersAvatar:heard withFile:dataImage withSuccess:^(MPMemberModel *model) {
        
        _tempModel.avatar = model.avatar;
        
        [designView mutavleDcitionary:_tempModel andIMG:image];


    } failure:^(NSError *error) {
        
    }];
}

//压缩照片
- (UIImage*)imageWithImageSimple:(UIImage*)imageOld scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [imageOld drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

@end
