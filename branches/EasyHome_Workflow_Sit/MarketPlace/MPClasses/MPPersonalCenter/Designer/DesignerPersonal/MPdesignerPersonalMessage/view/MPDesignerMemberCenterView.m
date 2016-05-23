/**
 * @file    MPDesignerMemberCenterView.m
 * @brief   the view of designer Message Center view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPDesignerMemberCenterView.h"
#import "MPDesignerCenterTableViewCell.h"
#import "MPDesignerCenterViewCell.h"
#import "MPMemberModel.h"
#import "MPCenterTool.h"

@interface MPDesignerMemberCenterView ()<UITableViewDelegate,UITableViewDataSource,headIconBtnClickDelegate>
{
    UITableView *_tableView;          ///<! Global tableView.
    NSArray *array;                   ///<! The words on the cell array.
    NSString *avatar;                 ///<! Member center headIcon.
    NSString *nickname;               ///<! Member center nickName.
    NSString *audit_status;           ///<! The designer review status.
    NSArray *_array;                  ///<! The images on the cell array.
    NSString *is_loho;                ///<! loho is review status.
}
@end
@implementation MPDesignerMemberCenterView

/// Initialize the view.
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createTableView];
    }
    return self;
}

-(void)loadInformation {
    
    MPMemberModel *Umodel = [MPCenterTool getPersonCenterInfo];
    avatar = Umodel.avatar;
    nickname = Umodel.nick_name;
    is_loho = Umodel.is_loho;
    audit_status = [MPCenterTool getAuditStatus];
    [_tableView reloadData];
}

/// creat tableView.
- (void)createTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MPDesignerCenterTableViewCell" bundle:nil] forCellReuseIdentifier:@"DesignerCenterCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPDesignerCenterViewCell" bundle:nil] forCellReuseIdentifier:@"DesiCenterCell"];
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    
    _tableView.tableHeaderView = heardView;
    _tableView.sectionHeaderHeight = 14;
    _tableView.sectionFooterHeight = 1;
    array = @[NSLocalizedString(@"set meal_key", nil),NSLocalizedString(@"My home page_key", nil),NSLocalizedString(@"Should the management_key", nil),NSLocalizedString(@"Decoration order_key", nil),NSLocalizedString(@"My assets_key", nil),NSLocalizedString(@"The message center_key", nil),NSLocalizedString(@"More_key", nil)];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _array = @[@"MyNorth",My_home,My_bid,My_project,Myassets,My_center,My_more];

    [self addSubview:_tableView];
}
#pragma mark --------------------TableViewDelegate-----------------------
/// custom view for header. will be adjusted to default or specified header height.
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    
    //section text as a label
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , 10)];
   
    return lbl;
    
}
/// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        if ([is_loho isEqualToString:@"1"]) {
            
            return 2;
            
        }else {
            
            return 1;
        }
        
    }else {
        
    return 6;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 267;
    }else {
        return 49.75;
    }
}
// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}
- (void)tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate headIconBtnClick:nil cerficationBtnClick:nil withSection:indexPath.section withRow:indexPath.row];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (indexPath.section == 0 && indexPath.row == 0) {
        MPDesignerCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DesignerCenterCell"];
        
        [MPCenterTool setHeadIcon:cell.headIconBtn
                           avator:avatar];
        
        if ([audit_status isEqualToString:@"0"]) {
            cell.tishiLabel.text = NSLocalizedString(@"Warm prompt!Your information is_key", nil);
            [cell.adumitBtn setTitle:NSLocalizedString(@"In the review_key", nil) forState:UIControlStateNormal];
        }else if ([audit_status isEqualToString:@"1"]||[audit_status isEqualToString:@"3"]){
            cell.tishiLabel.text = NSLocalizedString(@"Warm prompt!Your information after verification_key", nil);
            [cell.adumitBtn setTitle:NSLocalizedString(@"Not through_key", nil) forState:UIControlStateNormal];
        }else if ([audit_status isEqualToString:@"2"]){
            cell.adumitView.hidden = YES;
            cell.cerfication.hidden = NO;
        }
        if ([nickname isEqualToString:@"<null>"]) {
            cell.nick_Name.text = NSLocalizedString(@"just_tip_no_data", nil);
        }else {
        cell.nick_Name.text = nickname;
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else {
        MPDesignerCenterViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DesiCenterCell"];
        cell.leftLabel.text = array[indexPath.row + 1];
        cell.leftImage.image = [UIImage imageNamed:_array[indexPath.row + 1]];
        cell.rightImage.image = [UIImage imageNamed:@"f_fx"];
        if (indexPath.section == 0 && indexPath.row == 1) {
            
            cell.leftLabel.text = array[0];
            cell.leftImage.image = [UIImage imageNamed:_array[0]];
            cell.rightImage.image = [UIImage imageNamed:@"f_x"];

        }else if (indexPath.section == 1 &&indexPath.row ==3) {
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    
    return cell;
    
}
/// Click on the consumer call delegate method.
-(void) headIconBtnClick:(UIButton *)btn cerficationBtnClick:(UIButton *)btnClick {
    
    [self.delegate headIconBtnClick:btn cerficationBtnClick:btnClick withSection:100 withRow:100];
    
}
/// Request back to receive data.
- (void)reloadData:(MPMemberModel *)model{
    
    avatar = model.avatar;
    nickname = model.nick_name;
    is_loho = model.is_loho;
    [_tableView reloadData];
}

- (void)certification:(NSString *)cerfication {
    
    audit_status = cerfication;
    [_tableView reloadData];
    
}
@end
