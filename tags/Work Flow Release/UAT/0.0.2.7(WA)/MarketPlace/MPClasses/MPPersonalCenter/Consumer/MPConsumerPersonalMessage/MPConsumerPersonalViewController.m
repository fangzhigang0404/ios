/**
 * @file    MPConsumerPresonalViewController.m
 * @brief   personal ViewController.
 * @author  Xue
 * @version 1.0
 * @date    2015-12-01
 */

#import "MPConsumerPersonalViewController.h"
#import "MPpersonMessageViewController.h"
#import "MPmessageViewController.h"
#import "MPHomeViewController.h"
#import "MPmoreViewController.h"
#import "MPDecoListViewController.h"
#import "MPIssueDemandViewController.h"
#import "AppController.h"
#import "MPMemberModel.h"
#import "MPHttpRequestManager.h"
#import "UIImageView+WebCache.h"
#import <UIButton+WebCache.h>

#define win_width [[UIScreen mainScreen] bounds].size.width
#define win_height [[UIScreen mainScreen] bounds].size.height
@interface MPConsumerPersonalViewController ()<UITableViewDataSource,UITableViewDelegate,UITabBarControllerDelegate>

{   /// To register, login button.
    UIButton *btn;
    /// head icon image.
    UIImageView *headIcon;
    /// test label.
    UILabel *label;
    /// array data.
    NSArray *array;
    /// tableaView.
    UITableView *tableView;
    /// name label.
    UILabel *XMlabel;
    UIImageView *imgView;
    UIButton *headButton;
    NSString *avatar;
    NSString *mobile;
}

@end

@implementation MPConsumerPersonalViewController

- (void)tapOnRightButton:(id)sender
{
    NSLog(@"chat search");
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBar.hidden = YES;
    //self.tabBarController.tabBar.hidden = NO;
//    [self viewDidLoad];
//    BOOL status = [AppController AppGlobal_GetLoginStatus];
//    if (status == NO) {
//        
//        
//
//        self.tabBarController.selectedIndex = 0;
//        //[AppController AppGlobal_ProccessLogin];
//        return;
//    }

       [self _dataPage];
}

- (void)_dataPage{
    BOOL staus = [AppController AppGlobal_GetLoginStatus];
    if (staus == NO) {
        btn.hidden = NO;
        XMlabel.hidden = YES;
        headButton.hidden = YES;
        [btn addTarget:self action:@selector(loginbtn:) forControlEvents:7];

    }else {
        btn.hidden = YES;
//        [headButton setImage:[UIImage imageNamed:LOGONEW] forState:UIControlStateNormal];
//        XMlabel.text = @"Ducati";
        XMlabel.hidden = NO;
        headButton.hidden = NO;
        imgView.hidden = NO;
        imgView.image = [UIImage imageNamed:b_g];
        [headButton addTarget:self action:@selector(personBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self _personInformation];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /// notification tongzhi.

   // self.menuLabel.text = array[36];
    self.menuLabel.hidden = YES;
    self.leftButton.hidden = YES;
    
    self.titleLabel.text = NSLocalizedString(@"Personal Center_key", nil);
    self.rightButton.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    /// creat login in btn.
    self.view.backgroundColor = [UIColor grayColor];
     /// creat UITableView Personal center.
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, win_width, win_height - 64-44) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];

    /// To name determine whether a character is empty.
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 160 +64)];
    heardView.backgroundColor =[UIColor brownColor];
    btn = [UIButton buttonWithType:0];
    btn.frame = CGRectMake(100, 80 + 30, win_width-200, 30);
    [btn setTitle:NSLocalizedString(@"Log in_key", @"") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    tableView.tableHeaderView = heardView;
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, win_width , 160 +64)];
    imgView.tag = 2015;
    imgView.backgroundColor = [UIColor whiteColor];
    imgView.image = [UIImage imageNamed:b_g];

    [heardView addSubview:imgView];
    tableView.sectionFooterHeight = 1;
    headButton = [[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 72) / 2, 45, 72, 72)];
    headButton.layer.cornerRadius = 36;
    headButton.layer.masksToBounds = YES;
    [headButton setImage:[UIImage imageNamed:ICON_HEADER_DEFAULT] forState:UIControlStateNormal];
    /// The name label.
    XMlabel = [[UILabel alloc] initWithFrame:CGRectMake((win_width -120) / 2, 120, 120, 30)];
    //        XMlabel.backgroundColor = [UIColor orangeColor];
    XMlabel.textColor = [UIColor blackColor];
    XMlabel.textAlignment = NSTextAlignmentCenter;
    [heardView addSubview:XMlabel];
    [heardView addSubview:headButton];
    [heardView addSubview:btn];
    
    BOOL status = [AppController AppGlobal_GetLoginStatus];
    if (status == NO){
        [btn addTarget:self action:@selector(loginbtn:) forControlEvents:7];
        XMlabel.hidden = YES;
        headButton.hidden = YES;
        imgView.hidden = YES;
        btn.hidden = NO;
    }else {
        [headButton addTarget:self action:@selector(personBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.hidden = YES;
        imgView.hidden = NO;
        headButton.hidden = NO;
//        [headButton setImage:[UIImage imageNamed:LOGONEW] forState:UIControlStateNormal];
    }

}


- (void)_personInformation {
    
    //    self show
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    NSString *memderid = member.acs_member_id;
    //    NSString *hs_guid = [[NSUserDefaults standardUserDefaults] objectForKey:@"hs_guid"];
    NSString *hs_guid = member.hs_uid;
    NSString *acs_x_session = member.acs_x_session;
    if ([hs_guid isKindOfClass:[NSNull class]]) {
    }
    NSLog(@"hs_guid is %@",hs_guid);
       [MPMemberModel GetMemberACSToken];
    [userDefaults synchronize];
    NSDictionary * dic = @{@"X-Token":member.X_Token};
    
    NSLog(@"********%@",dic);
    NSLog(@"*********%@",memderid);
    NSLog(@"********%@",acs_x_session);
    
    [[MPAPI shareAPIManager] getMembersInformation:memderid withRequestHeard:dic WithSuccess:^(NSDictionary *dict) {
        NSLog(@"dict is -----------------%@",dict);
        avatar = [dict objectForKey:@"avatar"];
        if ([avatar isKindOfClass:[NSNull class]]) {
            [headButton setImage:[UIImage imageNamed:ICON_HEADER_DEFAULT] forState:UIControlStateNormal];
        }else {
            [headButton sd_setImageWithURL:[NSURL URLWithString:avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
        }
        NSLog(@"*********%@",avatar);
        
        NSString *nickname = [dict objectForKey:@"nick_name"];
        XMlabel.text = nickname;
        mobile = [dict objectForKey:@"mobile_number"];

        
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
        [headButton setImage:[UIImage imageNamed:ICON_HEADER_DEFAULT] forState:UIControlStateNormal];

    }];
}

/// message button click.
- (void)messageBut {
    
    MPmessageViewController *meVC = [[MPmessageViewController alloc] init];
    meVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:meVC animated:YES];
    
}
/// login button click.
- (void)loginbtn:(UIButton *)btn {
    [AppController AppGlobal_ProccessLogin];
}

#pragma UITableViewDelegate --delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else {
        return 3;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *identifier = @"cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (indexPath.row == 0 && indexPath.section == 1) {
        cell.textLabel.text = NSLocalizedString(@"The order management_key", @"");
        cell.imageView.image = [UIImage imageNamed:My_bid];
        UIImageView *_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 61, 7, 26, 26)];
        _imgView.image = [UIImage imageNamed:@""];
        [cell.contentView addSubview:_imgView];
        cell.accessoryType = UITableViewCellAccessoryNone;

    }else if (indexPath.row == 1 && indexPath.section == 1){

        cell.imageView.image = [UIImage imageNamed:My_center];
        cell.textLabel.text = NSLocalizedString(@"The message center_key", @"");


    }else if (indexPath.row == 2 && indexPath.section == 1){
        
        cell.textLabel.text = NSLocalizedString(@"More_key", @"");

        cell.imageView.image = [UIImage imageNamed:My_more];
    }else if (indexPath.row == 0 && indexPath.section == 0){
      
        cell.textLabel.text = NSLocalizedString(@"needKey", @"");
        cell.imageView.image = [UIImage imageNamed:My_zx];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if ([AppController AppGlobal_GetLoginStatus] == NO) return;

//    [AppController AppGlobal_GetLoginStatus];

    if (indexPath.section == 1 && indexPath.row == 0) {
        MPDecoListViewController *vc = [[MPDecoListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
       [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 1 && indexPath.row == 1) {

//        MPmessageViewController *meVC = [[MPmessageViewController alloc] init];
//        meVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:meVC animated:YES];
    }else if (indexPath.section == 1 && indexPath.row == 2) {
        MPmoreViewController *moVC = [[MPmoreViewController alloc] init];
        moVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:moVC animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 0) {
        
        if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            [MPAlertView showAlertWithMessage:@"功能开发中,敬请期待" sureKey:nil];
        } else {
            MPIssueDemandViewController *vc = [[MPIssueDemandViewController alloc] initWithType:MPDecorationVCTypeIssue needID:nil refresh:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}

- (void)personBtn:(UIButton *)btn {
    MPpersonMessageViewController *pmVC = [[MPpersonMessageViewController alloc] init];
    pmVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pmVC animated:YES];
}
/**
 *  notification thread.
 *
 *  @param text notification userinfo.
 */
- (void)tongzhi:(NSNotification *)text{
    
//    XMlabel.text = text.userInfo[@"user"];
//    btn.hidden = YES;
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    NSLog(@"**********LOGIN SUCCESS*********");
}
/// panGestureRecognized.
- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender {
    
    [self.frostedViewController panGestureRecognized:sender];
    
}

/// remove notification.
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"tongzhi" object:nil];
    
}
@end
