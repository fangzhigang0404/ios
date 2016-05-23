/**
 * @file    MPAboutViewController.m
 * @brief   the controller of about.
 * @author  niu
 * @version 1.0
 * @date    2016-03-29
 */

#import "MPAboutViewController.h"
#import "MPAboutWebViewController.h"
#import "MPCallViewController.h"
#import "MPAboutWebViewController.h"

@interface MPAboutViewController ()<UITableViewDataSource,UITableViewDelegate>

/// tableView.
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MPAboutViewController
{
    NSArray *_arrayDS;
}

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavigationBar];
    [self initUI];
    [self initData];
}

- (void)initUI {
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)initData {
    _arrayDS = @[NSLocalizedString(@"just_tip_about_info", nil),
                 NSLocalizedString(@"just_tip_about_call", nil),
                 NSLocalizedString(@"just_tip_about_copyright", nil),
                 NSLocalizedString(@"just_tip_about_version", nil)];
}

- (void)initNavigationBar {
    self.titleLabel.text = NSLocalizedString(@"About the designer_key", nil);
    self.rightButton.hidden = YES;
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayDS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }

    if (indexPath.row == 3) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 21)];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = ColorFromRGA(0x999999, 1);
        label.text = [AppController AppGlobal_GetAppMainVersion];
        cell.accessoryView = label;
    } else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = _arrayDS[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
         MPAboutWebViewController *reVC = [[MPAboutWebViewController alloc] initWithParm:NSLocalizedString(@"just_tip_about_info", nil) withFile:@"About"];
         [self.navigationController pushViewController:reVC animated:YES];

    } else if (indexPath.row == 1) {
        
        [self.navigationController pushViewController:[[MPCallViewController alloc] init] animated:YES];
    } else if (indexPath.row == 2) {
        
        MPAboutWebViewController *reVC = [[MPAboutWebViewController alloc] initWithParm:NSLocalizedString(@"just_tip_about_copyright", nil) withFile:@"legal"];
        [self.navigationController pushViewController:reVC animated:YES];
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc]init];
    return footerView;
}

-(void)viewDidLayoutSubviews
{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
