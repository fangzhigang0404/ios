/**
 * @file    MPdesignerView.m
 * @brief   the view of designer Message Center view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPdesignerView.h"
#import "MPdesignerUpTableViewCell.h"
#import "MPdesignerMessageTableViewCell.h"
#import "MPMemberModel.h"
#import "MPRegionManager.h"
#import "MPAlertView.h"
#import "MPCenterTool.h"

@interface MPdesignerView ()<UITableViewDelegate,UITableViewDataSource,headIconBtnClickBtnDelegate>
{
    UITableView *_tableView;
    NSArray  *array;
    UIImage *_image;
    MPMemberModel *_model;
    NSString *SJ;
    
}
@end
@implementation MPdesignerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor whiteColor];
    [self createTableView];
    
    return self;
}


- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MPdesignerMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPdesignerUpCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPdesignerUpTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPdesignerCellNext"];
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    
    _tableView.tableHeaderView = heardView;
    _tableView.sectionHeaderHeight = 14;
    _tableView.sectionFooterHeight = 1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    NSLocalizedString(@"nickname_key", nil)
    array = @[NSLocalizedString(@"nickname_key", nil),NSLocalizedString(@"user name_key", nil)
,NSLocalizedString(@"Mobile phone_key", nil),NSLocalizedString(@"gender_key", nil),NSLocalizedString(@"home_key", nil),NSLocalizedString(@"email_key", nil),NSLocalizedString(@"Amount of room cost_key_", nil),NSLocalizedString(@"Design_key", nil),NSLocalizedString(@"Real memberName_key", nil),NSLocalizedString(@"Id phone_key", nil)];
    [self addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if(section == 1) {
        return 8;
    }else {
        return 2;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 200;
    }else {
        return 50;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_model) {
        return 2;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];

    if (indexPath.section == 0 && indexPath.row == 0) {
        MPdesignerMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPdesignerUpCell"];
        if (_image) {
            [cell.headIconBtnClick setBackgroundImage:_image forState:UIControlStateNormal];

        }else {
            
            [MPCenterTool setHeadIcon:cell.headIconBtnClick
                               avator:_model.avatar];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        MPdesignerUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPdesignerCellNext"];
        cell.leftLabel.text = array[indexPath.row];
        if (indexPath.section == 1 && indexPath.row == 0) {
            if ([_model.nick_name rangeOfString:@"null"].length == 4 || _model.nick_name == nil) {
                cell.rightLabel.text = NSLocalizedString(@"just_tip_no_data_key", nil);
            }else{
                cell.rightLabel.text = _model.nick_name;
            }
            cell.imgView.image = [UIImage imageNamed:@"f_fx"];
            
        }else if (indexPath.section == 1 && indexPath.row == 1){
            if ([_model.hitachi_account rangeOfString:@"null"].length == 4 || _model.nick_name == nil) {
                cell.rightLabel.text = NSLocalizedString(@"just_tip_no_data_key", nil);
            }else{
               cell.rightLabel.text = _model.hitachi_account;
                }

            
        }else if (indexPath.section == 1 && indexPath.row == 3){
            if ([_model.gender rangeOfString:@"null"].length == 4 || _model.gender == nil) {
                cell.rightLabel.text = NSLocalizedString(@"just_tip_no_data_key", nil);
            }else{
                cell.rightLabel.text = _model.gender;
            }
            cell.imgView.image = [UIImage imageNamed:@"f_fx"];


        }else if (indexPath.section == 1 && indexPath.row == 2){
            if ([_model.mobile_number rangeOfString:@"null"].length == 4 || _model.mobile_number == nil) {
                cell.rightLabel.text = NSLocalizedString(@"Not binding mobile phone_key", nil);
            }else{
                cell.rightLabel.text = _model.mobile_number;
            }

        }else if (indexPath.section == 1 && indexPath.row == 5){
            if ([_model.email rangeOfString:@"null"].length == 4 || [_model.email isEqualToString:@""]){
                cell.rightLabel.text = NSLocalizedString(@"Unbounded email_key", nil);

            }else{
                
                cell.rightLabel.text = _model.email;
            }
        }else if (indexPath.section == 1 && indexPath.row == 4){

            NSDictionary *addressDict = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:_model.province withCityCode:_model.city andDistrictCode:_model.district];
            
            NSString *resultString = [NSString stringWithFormat:@"%@ %@ %@",addressDict[@"province"],addressDict[@"city"],addressDict[@"district"]];

            if ([resultString isEqualToString:@"null null null"] || [resultString isEqualToString:@"<null> <null> <null>"]) {
                resultString = NSLocalizedString(@"just_tip_no_data", nil);
            }
                cell.rightLabel.text = resultString;

            cell.imgView.image = [UIImage imageNamed:@"f_fx"];

        }else if (indexPath.section == 1 && indexPath.row == 7){
            
            if ([_model.design_price_max isEqualToString:@"0"]) {
                cell.rightLabel.text = NSLocalizedString(@"no_design_budget", nil);
            }else{
            SJ = [NSString stringWithFormat:@"%@-%@元/㎡",_model.design_price_min,_model.design_price_max];
                cell.rightLabel.text = SJ;
            }
            cell.imgView.image = [UIImage imageNamed:@"f_fx"];

        }else if (indexPath.section == 1 && indexPath.row == 6){
            
            if ([[_model.measurement_price description] rangeOfString:@"null"].length == 4 ||_model.measurement_price == nil) {
                cell.rightLabel.text = NSLocalizedString(@"no_design_budget", nil);
            }else{
                cell.rightLabel.text = [NSString stringWithFormat:@"%.2f元",[_model.measurement_price doubleValue]];
            }
            cell.imgView.image = [UIImage imageNamed:@"f_fx"];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *leftTitle;
    NSString *rightString;
    
    if ([AppController isHaveNetwork])
    { //添加遮罩，如没有网络连接则不允许修改>>>>>>>>

    if (indexPath.section == 0 && indexPath.row == 1) {
        return;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        leftTitle = array[0];
        if ([_model.nick_name rangeOfString:@"null"].length == 4 || _model.nick_name == nil) {
            rightString = NSLocalizedString(@"just_tip_no_data", nil);
        }else{
        rightString = _model.nick_name;
        }
    }else if (indexPath.section == 1 && indexPath.row == 3){
        leftTitle = array[3];
        rightString = _model.gender;
    }else if (indexPath.section == 1 && indexPath.row == 5){

    }else if (indexPath.section == 1 && indexPath.row == 6){
        if ([_model.measurement_price isEqualToString:@"(null)"]||_model.measurement_price == nil) {
            rightString = @"0";
        }else{
            rightString = [NSString stringWithFormat:@"%.2f",[_model.measurement_price doubleValue]];
        }
        leftTitle = array[6];
    }
    [self.delegate headIconBtnClickButton:nil withSection:indexPath.section andRow:indexPath.row withTitle:leftTitle andLeft:rightString];
    }//<<<<<<<<<添加遮罩，如没有网络连接则不允许修改
    else
    {
        [MPAlertView showAlertWithTitle:nil
                                message:NSLocalizedString(@"no_net_to_change", nil)
                                sureKey:nil];
    }
}
- (void)headBtnClick:(UIButton *)headBtn{
    if ([AppController isHaveNetwork])
        [self.delegate headIconBtnClickButton:headBtn withSection:100 andRow:100 withTitle:nil andLeft:nil];
    else
        [MPAlertView showAlertWithTitle:nil
                                message:NSLocalizedString(@"no_net_to_change", nil)
                                sureKey:nil];
}
- (void)reloadData:(MPMemberModel *)model andIMG:(UIImage *)image{
    
    _image = image;
    _model = model;
    [_tableView reloadData];
}
@end
