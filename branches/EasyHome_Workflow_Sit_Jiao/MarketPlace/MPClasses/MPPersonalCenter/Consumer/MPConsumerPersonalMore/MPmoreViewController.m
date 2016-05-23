/**
 * @file    MPmoreViewController.m
 * @brief   the view of MPmoreViewController
 * @author  fu
 * @version 1.0
 * @date    2015-12-30
 */
#import "MPmoreViewController.h"
#import "SDWebImageManager.h"
#import "MPFileUtility.h"
#import "MPAboutViewController.h"

@interface MPmoreViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MPmoreViewController
{
    UITableView *_tableView;
    NSString *_cacheStr;
}

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"MPmoreViewController lounch");
    self.view.backgroundColor = [UIColor orangeColor];
    //self.tabBarController.tabBar.hidden = YES;
    self.titleLabel.text = @"更多";
    self.rightButton.hidden = YES;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    
    [self.view addSubview:_tableView];
}

#pragma mark --UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"moreCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
   UIView *speView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, SCREEN_WIDTH, 1)];
   speView.backgroundColor = [UIColor colorWithRed:(247.0/255.0) green:(247.0/255.0) blue:(247.0/255.0) alpha:1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView addSubview:speView];
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedString(@"About the designer_key", @"");
    }else if (indexPath.section == 0 && indexPath.row == 0) {
        _cacheStr = [NSString stringWithFormat:@"%.1fM",[self getCacheSize]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 21)];
        label.text = _cacheStr;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        cell.accessoryView = label;
        cell.textLabel.text = NSLocalizedString(@"just_clear_cache_data_button", nil);
    }else if (indexPath.section == 1 && indexPath.row == 0){
        cell.textLabel.text = NSLocalizedString(@"just_login_out", nil);
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

/// Called after the user changes the selection.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 1) {
        
        [self.navigationController pushViewController:[[MPAboutViewController alloc] init] animated:YES];
    } else if (indexPath.section == 0 && indexPath.row == 0) {
        
        if ([_cacheStr isEqualToString:@"0.0M"]) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_no_cache", nil)
                      autoDisappearAfterDelay:1];
            return;
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"just_clear_cache", nil)
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel_Key", nil)
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        
        WS(weakSelf);
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"just_clear_cache_data", nil)
                                                         style:UIAlertActionStyleDestructive
                                                       handler:^(UIAlertAction *action) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:tableView animated:YES];
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] cleanDisk];

            [weakSelf fileOperation];
            [weakSelf performSelector:@selector(clearOver:) withObject:hud afterDelay:1];
        }];
        
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:action];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else if (indexPath.section == 1 && indexPath.row == 0){
        
        NSUserDefaults * UserInf = [NSUserDefaults standardUserDefaults];
        [UserInf removeObjectForKey:@"UserInformation"];//退出时清除本地用户信息
        [AppController AppGlobal_ProccessLogout];
        [AppController AppGlobal_SetLoginStatus:NO];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"creat" object:nil];

    }
}

- (void)clearOver:(MBProgressHUD *)hud {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:CLEAR_HUD_OK]];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"just_string_success", nil);
    [hud hide:YES afterDelay:1];
    [_tableView reloadData];
}

- (void)fileOperation {
    [MPFileUtility clearCacheContent];
}

- (CGFloat)getCacheSize {
    NSUInteger byteSize = [SDImageCache sharedImageCache].getSize;
    // M
    CGFloat imageSize = byteSize / 1000.0 / 1000.0;
    
    NSString *docDir = [NSString stringWithFormat:@"%@%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"],@"/mpstore"];
    
    CGFloat imCache = [self folderSizeAtPath:docDir];
    
    return imageSize + imCache;
}

- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (CGFloat)folderSizeAtPath:(NSString*) folderPath {
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1000.0 * 1000.0);
}

@end
