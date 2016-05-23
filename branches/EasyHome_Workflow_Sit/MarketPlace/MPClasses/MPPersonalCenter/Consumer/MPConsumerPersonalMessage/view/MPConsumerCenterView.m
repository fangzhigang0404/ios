/**
 * @file    MPConsumerCenterView.m
 * @brief   the view of MPConsumerCenterView.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPConsumerCenterView.h"
#import "MPConsumerPersonelTableViewCell.h"
#import "MPConsumerTableViewCell.h"
#import "MPConsumerPersonalCenterViewController.h"
#import "MPMemberModel.h"
#import "MPCenterTool.h"

@interface MPConsumerCenterView ()<UITableViewDataSource, UITableViewDelegate,MPFindDesignersTableViewCellDelegate>
{
   UITableView *_tableView;   //!< UITableView view.
    NSArray *array;           //!< array data.
    NSArray *Img;             //!< image array data.
    MPMemberModel *_model;    //!< MPMember model.
}
@end

@implementation MPConsumerCenterView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createTableView];
    }
    return self;
}

- (void)createTableView{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT - 64-44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;

    //    NSString *arrrr = NSLocalizedString(@"cancel_Key", nil);
    //    array = @[NSLocalizedString(@"cancel_Key", nil),@"2",@"3",@"4",@"5",@"6",@"7"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPConsumerPersonelTableViewCell" bundle:nil] forCellReuseIdentifier:@"ConstonerCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPConsumerTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellConsumer"];
    array = @[NSLocalizedString(@"Check requirements_key", nil),NSLocalizedString(@"I decorate a project_key", nil),NSLocalizedString(@"The message center_key", nil),NSLocalizedString(@"More_key", nil)];
    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.1)];
    
    _tableView.tableHeaderView = heardView;
    _tableView.sectionHeaderHeight = 14;
    _tableView.sectionFooterHeight = 1;
    Img = @[My_zx,My_bid,My_center,My_more];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addSubview:_tableView];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else {
        return 3;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 267;
    }
    return 49.75;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    
    if (section ==0) {
        return nil;
    }else {
        return view;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0&&indexPath.row==0) {
        MPConsumerPersonelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ConstonerCell"];
        cell.delegate = self;
        
        [MPCenterTool setHeadIcon:cell.button
                           avator:_model.avatar];
        
        if ([_model.nick_name rangeOfString:@"null"].length == 4) {
            cell.nickName.text = NSLocalizedString(@"just_tip_no_data", nil);
        }else {
        cell.nickName.text = _model.nick_name;
        }
        return cell;
        
    }else if (indexPath.section == 0&&indexPath.row==1){
        MPConsumerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellConsumer"];
        cell.lableText.text = array[0];
        cell.imgView.image = [UIImage imageNamed:Img[0]];
        cell.rightView.image = [UIImage imageNamed:@"f_x"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        MPConsumerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellConsumer"];
        cell.lableText.text = array[indexPath.row+1];
        cell.imgView.image = [UIImage imageNamed:Img[indexPath.row+1]];
        cell.rightView.image = [UIImage imageNamed:@"f_fx"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.delegate tableViewSection:indexPath.section withTableViewRow:indexPath.row];
    
}

-(void) BtnClickConsumer:(UIButton *)btn {
    
    [self.delegate BtnClickConsumer:btn];
    
}

- (void)reloadData:(MPMemberModel *)model {
    
    _model = model;
    [_tableView reloadData];
    
}

@end
