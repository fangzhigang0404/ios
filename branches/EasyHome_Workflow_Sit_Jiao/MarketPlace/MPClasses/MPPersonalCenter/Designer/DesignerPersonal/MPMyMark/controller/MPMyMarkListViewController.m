//
//  MPMyMarkListViewController.m
//  MarketPlace
//
//  Created by xuezy on 16/1/19.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMyMarkListViewController.h"
#import "MPAPI.h"
#import "MPDesignerlist.h"
#import "MBProgressHUD.h"
#import "MPMarkModel.h"
#import "MJRefresh.h"
#import "MPMyMarkListView.h"
#import "MPEditDemandViewController.h"
#import "MPMyProjectViewController.h"
#import "MPChatRoomViewController.h"
@interface MPMyMarkListViewController ()<MPMyMarkViewDelegate>

@end

@implementation MPMyMarkListViewController
{
    MPMyMarkListView *_myMarkView;
    NSMutableArray *markArray;
    NSMutableArray *markingArray;
    NSMutableArray *loseBidArray;
    NSString *tableType;
    NSInteger _offset;
    NSInteger _limit;
    BOOL _isLoadMore;
}

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated: YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBar];
    [self initData];
    [self initUI];
    
    [self requestData];
}

- (void)initBar {
    //self.tabBarController.tabBar.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"Should the management_key", nil);
    self.rightButton.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:241.0/255 blue:245.0/255 alpha:1];
}
- (void)initData {
    markArray = [NSMutableArray array];
    markingArray = [NSMutableArray array];
    loseBidArray = [NSMutableArray array];
    
    _offset = 0;
    _limit = 100;
    _isLoadMore = NO;
    tableType = @"one";
}
- (void)initUI {
    _myMarkView = [[MPMyMarkListView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
    _myMarkView.delegate = self;
    [self.view addSubview:_myMarkView];
}

- (void)requestData {
    
    WS(weakSelf);

    [MPMarkModel getDataWithParameters:@{@"limit":@(_limit),@"offset":@(_offset)} success:^(NSArray *array) {
        
        if (!_isLoadMore) {
            [markArray removeAllObjects];
            [markingArray removeAllObjects];
            [loseBidArray removeAllObjects];
            
        }

        for (int i =0; i<array.count; i++) {
            MPMarkModel *model = [array objectAtIndex:i];
            
            if ([model.bidding_status isEqualToString:@"0"]) {
                
                [markArray addObject:model];
            }else if([model.bidding_status isEqualToString:@"1"]) {
                [markingArray addObject:model];
            }else {
                [loseBidArray addObject:model];
            }
            
        }
        
        [_myMarkView refreshFindDesignersUI];
        [weakSelf endRefreshView:_isLoadMore];


    } failure:^(NSError *error) {
      
        [weakSelf endRefreshView:_isLoadMore];
        [MPAlertView showAlertForNetError];
        NSLog(@"%@",error);

    }];
    
}

///// 显示开始
//- (void)showHUD {
//    [MBProgressHUD showHUDAddedTo:myMarkTableView animated:YES];
//}
//
///// 请求结束
//- (void)hideHUD {
//    [MBProgressHUD hideAllHUDsForView:myMarkTableView animated:YES];
//}

- (void)selectTypeAtString:(NSString *)type {
    tableType = type;
}

#pragma mark - MPMyMarkViewDelegate methods

- (NSInteger) getDesignerCellCount {
    
    if ([tableType isEqualToString:@"one"]) {
        return markArray.count;
    }else if ([tableType isEqualToString:@"two"]){
        return markingArray.count;
    }else{
        return loseBidArray.count;
    }
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
}

- (void)findDesignersViewRefreshLoadNewData:(void (^)())finish {
    self.refreshForLoadNew = finish;
    _offset = 0;
    _isLoadMore = NO;
    [self requestData];
}

- (void)findDesignersViewRefreshLoadMoreData:(void (^)())finish {
    self.refreshForLoadMore = finish;
    _offset += _limit;
    _isLoadMore = YES;
    [self requestData];
}

#pragma mark - MPMyMarkTableViewCellDelegate methods

- (MPMarkModel *)getDesignerLibraryModelForIndex:(NSUInteger) index
{
    MPMarkModel *model = nil;
    
    if ([tableType isEqualToString:@"one"]) {
        return [markArray objectAtIndex:index];
    }else if ([tableType isEqualToString:@"two"]){
        return [markingArray objectAtIndex:index];
    }else{
        return [loseBidArray objectAtIndex:index];
    }

    return model;
}


-(void) startChatWithDesignerForIndex:(NSUInteger) index
{
   
    MPMarkModel *model = nil;
    
    
    if ([tableType isEqualToString:@"one"]) {
        model= [markArray objectAtIndex:index];
    }else if ([tableType isEqualToString:@"two"]){
        model =  [markingArray objectAtIndex:index];
    }else{
        model =  [loseBidArray objectAtIndex:index];
    }

    MPEditDemandViewController *vc = [[MPEditDemandViewController alloc] init];
    vc.needs_id = model.needs_id;
    vc.type = @"bidding";
    [self.navigationController pushViewController:vc animated:YES];
}


-(void) followDesignerForIndex:(NSUInteger) index {
    
//    [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_tip_IM_is_not_ready", nil)
//                              sureKey:nil];
    
    MPMarkModel *model = nil;
    
    
    if ([tableType isEqualToString:@"one"]) {
        model= [markArray objectAtIndex:index];
    }else if ([tableType isEqualToString:@"two"]){
        model =  [markingArray objectAtIndex:index];
    }else{
        model =  [loseBidArray objectAtIndex:index];
    }

    if ([model.acs_member_id isEqualToString:@"()"] || [model.thread_id isEqualToString:@""] || model.thread_id.length == 0) {
        
        
        return;
    }
    
    if ([AppController AppGlobal_GetLoginStatus]) {
        
        MPChatRoomViewController* ctrl = [[MPChatRoomViewController alloc] initWithThread:model.thread_id withReceiverId:model.acs_member_id withReceiverName:model.user_name withAssetId:model.needs_id loggedInUserId:[AppController AppGlobal_GetMemberInfoObj].acs_member_id];
        [self.navigationController pushViewController:ctrl animated:YES];
//        [AppController chatWithVC:self
//                       ReceiverID:model.acs_member_id
//              ReceiverHomeStyleID:nil
//                     receiverName:model.user_name
//                          assetID:nil
//                         isQRScan:NO];

    } else {
        [AppController AppGlobal_ProccessLogin];
    }


}

- (void)pushToMyProject:(NSUInteger)index {

    NSLog(@"我的项目");
    MPMyProjectViewController *vc = [[MPMyProjectViewController alloc] init];
    vc.is_loho = self.is_loho;
    [self customPushViewController:vc animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
