/**
 * @file    MPdesignerMessageCenterViewController.m
 * @brief   the view of designer Message Center view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPdesignerMessageCenterViewController.h"
#import "MPdesignerView.h"
#import "AppController.h"
#import "MPMemberModel.h"
#import "MPnameViewController.h"
#import "MPPickerView.h"
#import "MPQRCodeGenerate.h"
#import "MPUIImageView.h"
#import "UIImageView+WebCache.h"
#import "MPQRCodeReader.h"
#import "MPAddressSelectedView.h"
#import "MPRegionManager.h"
#import "MPcerficationInformationModel.h"
#import "MPCenterTool.h"

@interface MPdesignerMessageCenterViewController ()<headIconBtnClickDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,PassTrendValueDelegate,MPAddressSelectedDelegate>
{
    UIActionSheet *myActionSheet;
    MPdesignerView *designerView;
    UIImage *image;
    MPMemberModel *_model;
    NSString *nickname;
    NSString *gender;
    NSString *address;
    NSString *avatar;
    MPPickerView *_picker;
    MPAddressSelectedView *pickView;
    UILabel *addressLabel;

    UIView *feiView;
    
}
@end

@implementation MPdesignerMessageCenterViewController

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    designerView = [[MPdesignerView alloc] initWithFrame:CGRectMake(0, 63, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    designerView.delegate = self;
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"The basic information_key", nil);
    [self.view addSubview:designerView];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 1;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];

    feiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    feiView.backgroundColor = [UIColor blackColor];
    feiView.alpha = 0;
    [feiView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideFeiView)]];
    
    [self _reloadData];
    
    if (![AppController isHaveNetwork]) {
        MPMemberModel *model = [MPCenterTool getPersonCenterInfo];
        [designerView reloadData:model andIMG:[UIImage imageNamed:model.avatar]];
    }
}


- (void)_reloadData {
    
    [MBProgressHUD showHUDAddedTo:designerView animated:YES];
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *memderid = member.acs_member_id;
    NSString *hs_guid = member.hs_uid;
    
    if ([hs_guid isKindOfClass:[NSNull class]]) {
    }
    
    WS(weakSelf);
    [MPMemberModel DesignerInformation:memderid withSuccess:^(MPMemberModel *model) {
        _model = model;
        
        if ([[_model.design_price_min description] rangeOfString:@"null"].length == 4) {
            _model.design_price_min = @"0";
        }
        if ([[_model.design_price_max description] rangeOfString:@"null"].length == 4) {
            _model.design_price_max = @"0";
        }
        [weakSelf memberInfo:memderid];
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:designerView animated:YES];
        if ([AppController isHaveNetwork]) {
            [MPAlertView showAlertForNetError];
        }
    }];
    
}

- (void)memberInfo:(NSString *)memderid {
    
    [MPMemberModel MemberInformation:memderid withSuccess:^(MPMemberModel *model) {
        
        NSLog(@"model is %@",model);
        _model.hitachi_account = model.hitachi_account;
        _model.gender = model.gender;
        _model.avatar = model.avatar;
        _model.nick_name = model.nick_name;
        _model.mobile_number = model.mobile_number;
        
        [MPCenterTool savePersonCenterInfo:model];
        [designerView reloadData:_model andIMG:nil];
        [MBProgressHUD hideHUDForView:designerView animated:YES];
    } failure:^(NSError *error) {
//        [MPAlertView showAlertForNetError];
        NSLog(@"当前没有网络连接");
        [MBProgressHUD hideHUDForView:designerView animated:YES];
        if ([AppController isHaveNetwork]) {
            [MPAlertView showAlertForNetError];
        }
    }];
    
}

-(void) headIconBtnClickButton:(UIButton *)btn withSection:(NSInteger)section andRow:(NSInteger)row withTitle:(NSString *)title andLeft:(NSString *)string{
    if (btn) {
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel_Key", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open_camera_key", nil), NSLocalizedString(@"photo_albums_key", nil),nil];
        [myActionSheet showInView:self.view];
    }else if ((section == 1 && row == 0)||(section == 1 && row == 3)||(section == 1 && row == 6)) {
        
        MPnameViewController *nameVC = [[MPnameViewController alloc] init];
        
        if (row == 3) nameVC.isSex = YES;
        
        nameVC.nameString = string;
        nameVC.titleString = title;
        nameVC.trendDelegate = self;
        [self.navigationController pushViewController:nameVC animated:YES];
    }else if (section == 1 && row == 7) {
        [self removePicker];
        [self showFeiView];
        WS(weakSelf);
        _picker = [[MPPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 220)
                                            plistName:@"DesignBudgetcenter"
                                         compontCount:1
                                              linkage:NO
                                               finish:^(NSString *componet1, NSString *componet2, NSString *componet3, BOOL isCancel, NSString *nian) {
                                                   if (!isCancel){
                                                    NSArray *_array = [componet1 componentsSeparatedByString:@"-"];
                                                       _model.design_price_min = _array[0];
                                                       _model.design_price_max = _array[1];

                                                   [designerView reloadData:_model andIMG:nil];
                                                   }
                                                   NSLog(@"%@",componet1);
                                                   if (componet1.length != 0) {
                                                       [self _upDateDesignerInformation:componet1];
                                                   }
                                                   NSLog(@"%@",componet1);
                                                   
                                                   [weakSelf hidePicker];
                                                   [weakSelf hideFeiView];
                                               }];
        [self.view addSubview:_picker];
        [self showPicker];
        return;

    }

    if ((section == 1 && row == 4)) {
        [self _selectAddress];
        return;
    }
    [self hideMyPicker];
    [self removePicker];
}

- (void)_selectAddress {
    
    [self showMyPicker];
    
    if (pickView==nil) {
        pickView = [[MPAddressSelectedView alloc] initPickview];
        
    }
    pickView.delegate = self;
    
    
    [pickView show];
    
}

- (void)showFeiView {
    [self.view addSubview:feiView];
    feiView.alpha = 0.4;

}

- (void)hideFeiView {
    feiView.alpha = 0 ;
    [self hidePicker];

}

- (void)showMyPicker {
    
    [self.view addSubview:self.maskView];
    [self.view bringSubviewToFront:self.maskView];
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
        [self.maskView removeFromSuperview];
        [pickView removeFromSuperview];
        
    }];
    
    
}

#pragma mark MPAddressSelectedDelegate
- (void)selectedAddressinitWithProvince:(NSString *)province withCity:(NSString *)city withTown:(NSString *)town isCertain:(BOOL)isCertain {
    
    [self hideMyPicker];
    if (isCertain) {
        
        NSDictionary *addressDict = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:province withCityCode:city andDistrictCode:town];
        
        NSString *resultString = [NSString stringWithFormat:@"%@ %@ %@",addressDict[@"province"],addressDict[@"city"],addressDict[@"district"]];
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
        _model.province = province;
        _model.district = town;
        _model.city = city;
        
        [designerView reloadData:_model andIMG:nil];

        [self updateMemberInformation:province withCity:city withTown:town MemberInformation:self.provice_name withCity:self.city_name withTown:self.district_name];
        
    }else{
        
    }
    
}

- (void)createQRCodeView {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    
    
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    NSDictionary *inforDict = [NSDictionary dictionaryWithObjectsAndKeys:member.mobile_number,@"mobile_number",_model.nick_name,@"name",member.acs_member_id,@"member_id",_model.avatar,@"avatar",member.memberType,@"member_type", nil];
    
    NSLog(@"designer information:%@",inforDict);
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
        titleStringLabel.text = NSLocalizedString(@"Please sweep the yard_key", nil);
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
         
         backgroundView.alpha=0;
         
     }
     completion:^(BOOL finished) {
         [backgroundView removeFromSuperview];
     }];
    
}


- (void)_upDateDesignerInformation:(NSString *)infor {
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *memderid = member.acs_member_id;
    
    NSArray *Farray = [infor componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    NSLog(@"array:%@",Farray);
    NSString *min = _model.design_price_min;
    NSString *max = _model.design_price_max;
    
    NSString *laingfang;
    if ([_model.measurement_price isEqualToString:@"<null>"]) {
        laingfang = @"";
    }else{
        laingfang = _model.measurement_price;
    }
    if (Farray.count == 1) {
        laingfang = Farray[0];
//        Design.text = laingfang;
        NSLog(@"*********%@",laingfang);
    }else {
        min = Farray[0];
        max = Farray[1];
    }
    if ([min isEqualToString:@"<null>"]||[max isEqualToString:@"<null>"]) {
        min = @"";
        max = @"";
    }
    NSLog(@"min is %@",min);
    NSLog(@"max is %@",max);
    /*
     style_long_names   擅长风格   String
     introduction            自我介绍   String
     experience                  工作经验     Integer
     measurement_price     量房费        Double
     design_price_min        设计费最小  Double
     design_price_max       设计费最大   Double
     personal_honour         个人荣誉      String
     diy_count                  3D数量        Integer
     case_count                 效果图数量   Integer
     theme_pic                  主题            String
     */
    if ([_model.style_long_names isEqualToString:@"<null>"]||_model.style_long_names == nil) {
        
        _model.style_long_names = @"";
    }
    if ([_model.introduction isEqualToString:@"<null>"]||_model.introduction == nil) {
        
        _model.introduction = @"";
    } if ([_model.experience isEqualToString:@"<null>"]||_model.experience == nil) {
        
        _model.experience = @"";
    } if ([_model.personal_honour isEqualToString:@"<null>"]||_model.personal_honour == nil) {
        
        _model.personal_honour = @"";
    } if ([_model.diy_count isEqualToString:@"<null>"]||_model.diy_count == nil) {
        
        _model.diy_count = @"";
    } if ([_model.case_count isEqualToString:@"<null>"]||_model.case_count == nil) {
        
        _model.case_count = @"";
    } if ([_model.theme_pic isEqualToString:@"<null>"]||_model.theme_pic == nil) {
        
        _model.theme_pic = @"";
    }
    NSDictionary *param = @{@"design_price_min":min,
                            @"design_price_max":max,
                            @"measurement_price":laingfang,
                            @"style_long_names":_model.style_long_names,
                            @"introduction":_model.introduction,
                            @"experience":_model.experience,
                            @"personal_honour":_model.personal_honour,
                            @"diy_count":_model.diy_count,
                            @"case_count":_model.case_count,
                            @"theme_pic":_model.theme_pic};
    NSDictionary * dic = [MPMemberModel getHeaderAuthorizationHsUid];
//
    [MPcerficationInformationModel updataGetdesignersInformation:memderid withParam:param withRequestHeard:dic withSuccess:^(MPcerficationInformationModel *model) {
        
        [designerView reloadData:_model andIMG:nil];

     } failure:^(NSError *error) {
    
     }];
    
}

- (void)showPicker {
    [UIView animateWithDuration:0.3 animations:^{
        _picker.frame = CGRectMake(0, self.view.frame.size.height - 220, self.view.frame.size.width, 220);
    }];
}

- (void)removePicker {
    [_picker removePickerView];
}

- (void)hidePicker {
    [UIView animateWithDuration:0.3 animations:^{
        _picker.frame = CGRectMake(0, self.view.frame.size.height,0, 0);
        [self performSelector:@selector(removePicker) withObject:nil afterDelay:0.3];
    }];
}


-(void)passTrendValues:(NSString *)values andtitle:(NSString *)title {
    

    if ([title isEqualToString:NSLocalizedString(@"nickname_key", nil)]) {
        _model.nick_name = values;
    }if ([title isEqualToString:NSLocalizedString(@"gender_key", nil)]) {
        _model.gender = values;
    }if ([title isEqualToString:NSLocalizedString(@"home_key", nil)]) {
        _model.address = values;
    }if ([title isEqualToString:NSLocalizedString(@"Amount of room cost_key_", nil)]) {
        _model.measurement_price = values;
        [self _upDateDesignerInformation:values];
        return;
    }
   

    [self updateMemberInformation:nil withCity:nil withTown:nil MemberInformation:nil withCity:nil withTown:nil];
    
}
- (void)updateMemberInformation:(NSString *)province withCity:(NSString *)city withTown:(NSString *)town MemberInformation:(NSString *)province_name withCity:(NSString *)city_name withTown:(NSString *)town_name{
    
    
    NSString *_gender;
    if ([_model.gender isEqualToString:NSLocalizedString(@"wemenKey", nil)]) {
        _gender = @"1";
    }else if ([_model.gender isEqualToString:NSLocalizedString(@"menKey", nil)]){
        _gender = @"2";
    }else {
        _gender = @"0";
    }
    NSString *url;
    if (url == nil) {
        url = _model.avatar;
    }
    if (province == nil) {
        province = _model.province;
    }if (city == nil) {
        city = _model.city;
    }if (town == nil) {
        town = _model.district;
    }if (province_name == nil) {
        province_name = _model.province_name;
    }if (city_name == nil) {
        city_name = _model.city_name;
    }if (town_name == nil) {
        town_name = _model.district_name;
    }
    
    if (_gender          == nil ||
        _model.nick_name == nil ||
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
    /*
     home_phone 家庭住址String
     birthday        生日     String
     zip_code        邮编    String
     */
    if ([_model.home_phone isEqualToString:@"<null>"]||_model.home_phone == nil) {
        _model.home_phone = @"";
    }
    if ([_model.birthday isEqualToString:@"<null>"]||_model.birthday == nil) {
        _model.birthday = @"";
    }
    if ([_model.zip_code isEqualToString:@"<null>"]||_model.zip_code == nil) {
        _model.zip_code = @"";
    }
    if (_model.nick_name!=nil)
        _model.nick_name=[_model.nick_name stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSDictionary *param = @{@"gender":_gender,
                            @"nick_name":_model.nick_name,
                            @"avatar":url,
                            @"province":province,
                            @"city":city,
                            @"district":town,
                            @"province_name":province_name,
                            @"city_name":city_name,
                            @"district_name":town_name,
                            @"home_phone":_model.home_phone,
                            @"birthday":_model.birthday,
                            @"zip_code":_model.zip_code};
   
    NSLog(@"param is %@",param);
    NSLog(@"url is %@",url);
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *member_id = member.member_id;
    
    [MPMemberModel UpdataMemberInformation:member_id withParam:param withSuccess:^(MPMemberModel *model) {
        
        NSLog(@"icon image url :%@",url);
        [designerView reloadData:_model andIMG:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"error is ********************%@",error);
    }];
    
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
        
        [self updatePhoto];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}
- (void)updatePhoto {
    
    MPMember *memeber = [AppController AppGlobal_GetMemberInfoObj];
    NSDictionary *heard = @{@"X-Token":memeber.X_Token};
    NSData *dataImage;
    dataImage = UIImagePNGRepresentation(image);
    [MPMemberModel updataMembersAvatar:heard withFile:dataImage withSuccess:^(MPMemberModel *model) {
        
            _model.avatar = model.avatar;
            [designerView reloadData:_model andIMG:nil];

        
    } failure:^(NSError *error) {
        [MPAlertView showAlertWithMessage:@"上传头像失败" sureKey:nil];
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
