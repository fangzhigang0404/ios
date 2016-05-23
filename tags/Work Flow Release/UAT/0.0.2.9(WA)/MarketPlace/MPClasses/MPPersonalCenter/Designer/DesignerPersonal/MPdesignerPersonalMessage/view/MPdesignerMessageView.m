/**
 * @file    MPdesignerMessageView.m
 * @brief   the view of MPdesignerMessageView view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPdesignerMessageView.h"
#import "MPdesigenTableViewCell.h"
#import "MPheadIconTableViewCell.h"
#import "MPMemberModel.h"
#import "MPRegionManager.h"
#import "MPAlertView.h"
#import "MPCenterTool.h"

@interface MPdesignerMessageView ()<UITableViewDataSource,UITableViewDelegate,HeadIconBtnclickDelegate>{
    
    NSArray *array;                 //!< array data.
    UITableView *_tableView;        //!< UITableView view.
    MPMemberModel *_tempModel;      //!< MPMember model.
}

@end
@implementation MPdesignerMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self creatTableView];
    }
    return self;
}


- (void)creatTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MPheadIconTableViewCell" bundle:nil] forCellReuseIdentifier:@"DesignHead"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPdesigenTableViewCell" bundle:nil] forCellReuseIdentifier:@"DesignCell"];
    array = @[NSLocalizedString(@"nickname_key",nil),NSLocalizedString(@"user name_key", nil),NSLocalizedString(@"My_QR_Code_key", nil),NSLocalizedString(@"Mobile phone_key", nil),NSLocalizedString(@"gender_key", nil),NSLocalizedString(@"home_key", nil),NSLocalizedString(@"email_key", nil)];
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    
    _tableView.tableHeaderView = heardView;
    _tableView.sectionHeaderHeight = 14;
    _tableView.sectionFooterHeight = 1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return 7;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0&&indexPath.row==0) {
        MPheadIconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DesignHead"];
        
        [MPCenterTool setHeadIcon:cell.headIcon
                           avator:_tempModel.avatar];
      
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    else {
        MPdesigenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DesignCell"];

        cell.leftLabel.text = array[indexPath.row];
        if (indexPath.section == 1 &&indexPath.row==0) {
            if ([_tempModel.nick_name isEqualToString:@"<null>"]) {
                cell.rightLabel.text = NSLocalizedString(@"just_tip_no_data", nil);

            }else {
            cell.rightLabel.text = _tempModel.nick_name;
            }
            cell.rightImgView.image = [UIImage imageNamed:@"f_fx"];

        }else if (indexPath.section == 1 &&indexPath.row==1){
            if ([_tempModel.acount isEqualToString:@"<null>"]) {
                cell.rightLabel.text = NSLocalizedString(@"just_tip_no_data", nil);
                
            }else {
                cell.rightLabel.text = _tempModel.acount;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (indexPath.section == 1 &&indexPath.row==2){
            
            UIImageView *_imgView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 61, 12, 26, 26)];
            _imgView.image = [UIImage imageNamed:Qr_code];
            [cell.contentView addSubview:_imgView];
            cell.rightImgView.image = [UIImage imageNamed:@"f_fx"];

        }else if (indexPath.section == 1 &&indexPath.row==3){
            if ([_tempModel.mobile_number isEqualToString:@"<null>"]) {
                cell.rightLabel.text = NSLocalizedString(@"Not binding mobile phone_key", nil);
                
            }else {
                cell.rightLabel.text = _tempModel.mobile_number;
            }
            cell.accessoryType = UITableViewCellAccessoryNone;

        }else if (indexPath.section == 1 &&indexPath.row==4){
            if ([_tempModel.gender isEqualToString:@"<null>"]) {
                cell.rightLabel.text = NSLocalizedString(@"just_tip_no_data", nil);
                
            }else {
                cell.rightLabel.text = _tempModel.gender;
            }
            cell.rightImgView.image = [UIImage imageNamed:@"f_fx"];

        }else if (indexPath.section == 1 &&indexPath.row==5){

            NSDictionary *addressDict = [[MPRegionManager sharedInstance]
                                         getRegionWithProvinceCode:_tempModel.province
                                                      withCityCode:_tempModel.city
                                                   andDistrictCode:_tempModel.district];
            
            NSString *resultString = [NSString stringWithFormat:@"%@ %@ %@",addressDict[@"province"],addressDict[@"city"],addressDict[@"district"]];
            if ([resultString isEqualToString:@"null null null"]||[resultString isEqualToString:@"<null> <null> <null>"]) {
                resultString = NSLocalizedString(@"just_tip_no_data", nil);
            }
            cell.rightLabel.text = resultString;
            
            cell.rightImgView.image = [UIImage imageNamed:@"f_fx"];

        }else if (indexPath.section == 1 &&indexPath.row==6){
            
            if ([_tempModel.email isEqualToString:@"<null>"]) {
                
                cell.rightLabel.text = NSLocalizedString(@"Unbounded email_key", nil);
                
            }else {
                
                cell.rightLabel.text = _tempModel.email;
                
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;

        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title;
    NSString *right;
    if ([AppController isHaveNetwork]) {
        
        if (indexPath.section == 1 &&indexPath.row==0) {
            title = array[0];
            right = _tempModel.nick_name;
        }else if (indexPath.section == 1 &&indexPath.row==1){
            title = array[1];
            
        }else if (indexPath.section == 1 &&indexPath.row==2){
            title = array[2];
            
        }else if (indexPath.section == 1 &&indexPath.row==3){
            title = array[3];
        }else if (indexPath.section == 1 &&indexPath.row==4){
            title = array[4];
            right = _tempModel.gender;
            
        }else if (indexPath.section == 1 &&indexPath.row==5){
            
        }else if (indexPath.section == 1 &&indexPath.row==6){
            title = array[6];
            
        }else if (indexPath.section == 0 &&indexPath.row==0){
            return;
        }
        
        [self.delegate tableViewSection:indexPath.section withTableViewRow:indexPath.row withTitle:title withRight:right withBtn:nil];
    }
    else
    {
        [MPAlertView showAlertWithTitle:nil
                                message:NSLocalizedString(@"no_net_to_change", nil)
                                sureKey:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 200;
    }
    
    return 50;
}
- (void)mutavleDcitionary:(MPMemberModel *)model andIMG:(UIImage *)image {

    _tempModel = model;
    [_tableView reloadData];

}
- (void)HeadIconBtnClick:(UIButton *)btn {
    if ([AppController isHaveNetwork])
    { //添加遮罩，如没有网络连接则不允许修改
        [self.delegate tableViewSection:0 withTableViewRow:0 withTitle:nil withRight:nil withBtn:btn];
    }else
    {
        [MPAlertView showAlertWithTitle:nil
                                message:NSLocalizedString(@"no_net_to_change", nil)
                                sureKey:nil];
    }
}

@end
