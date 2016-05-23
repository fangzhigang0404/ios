/**
 * @file    MPpersonMessageViewController.m
 * @brief   the view of MPpersonMessageViewController
 * @author  fu
 * @version 1.0
 * @date    2015-12-24
 */

#import "MPpersonMessageViewController.h"
#import "MPnameViewController.h"
#import "MPAPI.h"
#import "UIImageView+WebCache.h"
#import "MPMemberModel.h"
#import "MBProgressHUD.h"
#import "AppController.h"
#import "MPFileUtility.h"
#import "MPQRCodeGenerate.h"
#import "MPUIImageView.h"
#import "MPMarketplaceSettings.h"

@interface MPpersonMessageViewController ()<UITableViewDataSource,NSURLSessionTaskDelegate,UITableViewDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,PassTrendValueDelegate>

{   /// The first set of data.
    NSArray *data;
    /// A second group of data.
    NSArray *downData;
    /// imageView.
    UIImageView *imgView;
    /// array data.
    NSArray *array;
    /// userDefautls.
    NSUserDefaults *userDefaults;
    /// clabel.
    UILabel *cLabel;
    /// nlabel.
    UILabel *nLabel;
    UILabel *nclLabel;
    NSMutableArray *_array;
    NSString *nick_name;
    NSString *address;
    NSString *mobile_number;
    NSString *certificate_code;
    NSString *certificate_type;
    NSString *true_name;
    NSString *user_email;
    NSString *gender;
    UILabel *emailLabel;
    UILabel *genderLabel;
    UIImage *image;
    UILabel *signatureLabel;
    UIImageView *headImageView;
    UIActionSheet *myActionSheet ;
    UILabel *RealLabel;
    UILabel *IDcardLabel;
    UILabel *numbCardLabel;
    NSString *file_id;
    NSString *downUrl;
    NSString *avatar;
    UILabel *user_name;
    NSString *userName;
    NSString *email;
    UILabel *headLabel;
}
@end

@implementation MPpersonMessageViewController

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
/// show HUD
- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/// hide HUD
- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /// Do any additional setup after loading the view.
     NSLog(@"MPpersonMessageViewController lounch");
    
    NSString *pathField = [[NSBundle mainBundle] pathForResource:@"perSon" ofType:@"plist"];
    array = [[NSArray alloc] initWithContentsOfFile:pathField];
    self.view.backgroundColor = [UIColor orangeColor];
    //self.tabBarController.tabBar.hidden = YES;
    self.menuLabel.text = NSLocalizedString(@"The basic information_key", nil);
    self.rightButton.hidden = YES;

    imgView = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2,30, 80, 80)];
//    imgView.backgroundColor = [UIColor orangeColor];
    headLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2,120, 80, 20)];

    _array = [NSMutableArray array];

    /// Initialize the UITableView.
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

    tableView.sectionFooterHeight = 1;
    tableView.sectionHeaderHeight = 1;
    userDefaults = [NSUserDefaults standardUserDefaults];
    [self _initData];
}
- (void)_initData{
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
//    NSString *memderid = member.member_id;

//    NSString *member_id = [userDefaults objectForKey:@"member_id"];
    
    NSString *member_id = member.member_id;

    [MPMemberModel MemberInformation:member_id withSuccess:^(MPMemberModel *model) {
        
        nick_name = model.nick_name;
        gender = model.gender;
        address = model.address;
        true_name = model.true_name;
        user_email = model.user_email;
        NSString *emaili = model.email;
        email = [NSString stringWithFormat:@"%@",emaili];
        mobile_number = model.mobile_number;
        avatar = model.avatar;
        NSLog(@"avatar is%@",avatar);
        userName = model.acount;
        NSLog(@"nick_name is %@",nick_name);
        [tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];

    
}
/// Variable height support.
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
    }
        return 10;
    
}
#pragma mark -- UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 1;
        
    }else {
        
        return 7;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   static NSString *identifier = @"cell";
   

    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0 && indexPath.row == 0) {
        imgView.layer.cornerRadius = 40;
        imgView.layer.masksToBounds = YES;
        if (image == nil) {
            if ([avatar isKindOfClass:[NSNull class]]) {
                
            }else {
                [imgView sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
            }
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
         headLabel.text = @"上传头像";
        headLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:imgView];
        headLabel.backgroundColor = [UIColor grayColor];
        headLabel.layer.cornerRadius = 8.0;
        headLabel.layer.masksToBounds = YES;

        [cell.contentView addSubview:headLabel];

    }else if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"nickname_key", @"");
        cLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 135, 0, 100, 40)];
        cLabel.text = nick_name;
        cLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:cLabel];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedString(@"My_QR_Code_key", @"");
        
        UIImageView *_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 61, 7, 26, 26)];
        _imgView.image = [UIImage imageNamed:Qr_code];
        [cell.contentView addSubview:_imgView];

    }else if (indexPath.section == 1 && indexPath.row == 6) {
        cell.textLabel.text = NSLocalizedString(@"home_key", @"");
        nLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 0, 80, 40)];
//        NSString *string = [address substringToIndex:2];
        if ([address isEqualToString:@"<null>"]) {
            nLabel.text = @"暂无数据";
        }else {
        nLabel.text = address;
        }
        nLabel.textAlignment = NSTextAlignmentRight;
        
        [cell.contentView addSubview:nLabel];

        
    }else if (indexPath.section == 1 && indexPath.row == 4) {
        cell.textLabel.text = NSLocalizedString(@"Mobile phone_key", @"");
        nclLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 155, 0, 120, 40)];
        if ([mobile_number isEqualToString:@"<null>"]) {
            nclLabel.text = @"未绑定手机";
        }else {
        nclLabel.text = mobile_number;
        }
        nclLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryType = UITableViewCellAccessoryNone;

        [cell.contentView addSubview:nclLabel];

    }else if (indexPath.section == 1 && indexPath.row == 5) {
        cell.textLabel.text = NSLocalizedString(@"email_key", @"");
        emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 265, 0, 245, 40)];
        emailLabel.text = email;
        emailLabel.font = [UIFont systemFontOfSize:15];
        emailLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryType = UITableViewCellAccessoryNone;

        [cell.contentView addSubview:emailLabel];

    }else if (indexPath.section == 1 && indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedString(@"gender_key", @"");
        genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 115, 0, 80, 40)];
        genderLabel.text = gender;
        genderLabel.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:genderLabel];

    }else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedString(@"user name_key", @"");
        user_name = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 155, 0, 120, 40)];
        user_name.text = userName;
        user_name.textAlignment = NSTextAlignmentRight;
        cell.accessoryType = UITableViewCellAccessoryNone;

        [cell.contentView addSubview:user_name];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {

        return 200;
    }

        return 40;
}
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView1 cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        myActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel_Key", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open_camera_key", nil), NSLocalizedString(@"photo_albums_key", nil),nil];
        myActionSheet.tag = indexPath.section *100;
        [myActionSheet showInView:self.view];
        return;
    }
    MPnameViewController *naVC = [[MPnameViewController alloc] init];
    naVC.trendDelegate = self;
    naVC.titleString = cell.textLabel.text;
    if (indexPath.section == 1 && indexPath.row == 4) {

        return;
    }if (indexPath.section == 1 && indexPath.row == 6) {
        naVC.nameString = nLabel.text;

    }if (indexPath.section == 1 && indexPath.row == 2) {
        
        [self createQRCodeView];

        return;
    }if (indexPath.section == 1 && indexPath.row == 1) {
        naVC.nameString = cLabel.text;

    }if (indexPath.section == 1 && indexPath.row == 5) {

        return;
        
    }if (indexPath.section == 1 && indexPath.row == 3) {
        naVC.nameString = genderLabel.text;
        
    }if (indexPath.section == 1 && indexPath.row == 0) {

        return;
        
    }
    [self.navigationController pushViewController:naVC animated:YES];

}

- (void)createQRCodeView {
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    
    
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    NSDictionary *inforDict = [NSDictionary dictionaryWithObjectsAndKeys:member.mobile_number,@"mobile_number",nick_name,@"name",member.acs_member_id,@"member_id",avatar,@"avatar",member.memberType,@"member_type", nil];
    
    NSLog(@"消费者信息:%@",inforDict);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inforDict options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *informationString= [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[MPQRCodeGenerate shareQRCodeGenerate] createQRCodeWithString:informationString complete:^(UIImage *QRImage) {
        
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
         
         backgroundView.alpha=0;
         
     }
     completion:^(BOOL finished) {
         [backgroundView removeFromSuperview];
     }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section

{
    
    //section text as a label
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, SCREEN_WIDTH -20, 15)];
    

    return lbl;
    
}

- (void)passTrendValues:(NSString *)values andtitle:(NSString *)title {
    

    if ([title isEqualToString:NSLocalizedString(@"nickname_key", nil)]) {
        cLabel.text = values;
    }else if ([title isEqualToString:NSLocalizedString(@"home_key", nil)]) {
        nLabel.text = values;
    }else if ([title isEqualToString:NSLocalizedString(@"Mobile phone_key", nil)]) {
        nclLabel.text = values;
    }else if ([title isEqualToString:NSLocalizedString(@"email_key", nil)]) {
        emailLabel.text = values;
    }else if ([title isEqualToString:NSLocalizedString(@"gender_key", nil)]) {
        genderLabel.text = values;
    }else if ([title isEqualToString:NSLocalizedString(@"Home phone_key", nil)]) {
        signatureLabel.text = values;
    }else if ([title isEqualToString:NSLocalizedString(@"Real memberName_key", nil)]) {
        RealLabel.text = values;
    }else if ([title isEqualToString:NSLocalizedString(@"Document type_key", nil)]) {
        IDcardLabel.text = values;
    }else if ([title isEqualToString:NSLocalizedString(@"Id phone_key", nil)]) {
        numbCardLabel.text = values;
        
    }else if ([title isEqualToString:NSLocalizedString(@"user name_key", nil)]) {
        user_name.text = values;
    }
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];

    NSString *member_id = member.member_id;
    [self memberInformationUpdate:member_id withUrl:nil withTag:0];
    NSLog(@"ios trend :%@",values);
}
#pragma mark --memberInformation
- (void)memberInformationUpdate:(NSString *)member_id withUrl:(NSString *)url withTag:(NSUInteger)tag{
    NSString *_gender;
    if ([genderLabel.text isEqualToString:NSLocalizedString(@"wemenKey", nil)]) {
        _gender = @"1";
    }else if ([genderLabel.text isEqualToString:NSLocalizedString(@"menKey", nil)]){
        _gender = @"2";
    }else {
        _gender = @"0";
    }
    if (url == nil) {
        url = avatar;
    }
    
    NSDictionary *param = @{@"gender":_gender,
                            @"nick_name":cLabel.text,
                            @"avatar":url,
                            @"address":nLabel.text};
    NSLog(@"param is %@",param);
    NSLog(@"url is %@",url);
    [MPMemberModel UpdataMemberInformation:member_id withParam:param withSuccess:^(MPMemberModel *model) {
        
        if (tag == 1) {
            
            NSLog(@"icon image url :%@",url);
        }
        [self hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"error is ********************%@",error);
        [self hideHUD];
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
        
      UIImage * Oldimage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData *dataImage;
        if (UIImagePNGRepresentation(Oldimage) == nil)
        {
            dataImage = UIImageJPEGRepresentation(Oldimage, 0.0);
        }
        else
        {
            dataImage = UIImagePNGRepresentation(Oldimage);
        }
//        [self getUrl:nil];
       image = [self imageWithImageSimple:Oldimage scaledToSize:CGSizeMake(200, 200)];
        imgView.image =image;

        [self updatePhoto];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
    
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
- (void)updatePhoto {
    [self showHUD];
    MPMember *memeber = [AppController AppGlobal_GetMemberInfoObj];
    NSDictionary *heard = @{@"X-Token":memeber.X_Token};
    NSData *dataImage;
    dataImage = UIImagePNGRepresentation(imgView.image);
    
    [[MPAPI shareAPIManager] updataMembersAvatar:heard withFile:dataImage witSuccess:^(NSDictionary *dict) {
        NSLog(@"***************%@",dict);

         NSLog(@"上传头像成功");
        [self hideHUD];
    } failure:^(NSError *error) {
        [self hideHUD];
         NSLog(@"上传头像失败: %@",error.description);
    }];
}
-(void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"上传失败");
}
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)getUrl:(NSString *)titleUrl {
    [self showHUD];
    [[MPAPI shareAPIManager] uploadPhoto:nil withsuccess:^(NSDictionary *dictionary) {
        
        NSLog(@"dictionary is %@",dictionary);
        
        NSString *string = [dictionary objectForKey:@"server"];
        NSLog(@"server is %@",string);
        [self upload:string];
        
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];

}

- (void)upload:(NSString *)string {
    NSString *sesion= [userDefaults objectForKey:@"acs_x_session"];
    MPMember *memeber = [AppController AppGlobal_GetMemberInfoObj];
    NSLog(@"************%@",sesion);
    NSDictionary *headField = [NSDictionary dictionaryWithObjectsAndKeys:[MPMarketplaceSettings sharedInstance].afc,@"X-AFC",memeber.acs_x_session,@"X-Session", nil];
    //    NSString * str1 = [NSString stringWithFormat:@"http://%@/api/v2/files/upload?unzip=false&public=true",string];
    NSData *dataImage = UIImagePNGRepresentation(imgView.image);
    NSString *destDateString = [MPFileUtility getUniqueFileName];
    NSArray *arr = [NSArray arrayWithObject:[NSDictionary dictionaryWithObjectsAndKeys:dataImage,@"data",destDateString,@"name",[NSString stringWithFormat:@"%@.png",destDateString],@"fileName",@"image/png",@"type", nil]];
    
//    NSLog(@"arr is %@",arr);
    [[MPAPI shareAPIManager] createUploadPhotosWithUrl:string withFiles:arr withHeader:headField success:^(NSDictionary *dict) {
        
        NSArray *files = [dict objectForKey:@"files"];
        NSDictionary *dic = files[0];
        file_id = [dic objectForKey:@"file_id"];
        NSLog(@"file_id is ********%@",file_id);
        [self _initImage:file_id];
    } failure:^(NSError *error) {
        
        NSLog(@"error is :%@",error);
        [self hideHUD];
    }];

}
/// According to the field_id for photos.
- (void)_initImage:(NSString *)fild_id {
    [[MPAPI shareAPIManager] uploadPhoto:nil withsuccess:^(NSDictionary *dictionary) {
        
        NSLog(@"dictionary is %@",dictionary);
        
        NSString *string = [dictionary objectForKey:@"server"];
        [[MPAPI shareAPIManager] downloadfield:fild_id andtitle:string success:^(NSDictionary *dict) {
            
            NSLog(@"dict is *************%@",dict);
            
            downUrl = [dict objectForKey:@"download_url"];
            
//            [tableView reloadData];
            MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
            
            NSString *member_id = member.member_id;

            [self memberInformationUpdate:member_id withUrl:downUrl withTag:1];
        } failure:^(NSError *error) {
            NSLog(@"error is %@",error);
        }];
    } failure:^(NSError *error) {
        NSLog(@"error is ******************%@",error);
    }];
}
@end
