/**
 * @file    MPFindDesignersViewController.m
 * @brief   the frame of MPFindDesignersViewController.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPFindDesignersViewController.h"
#import "MPFindDesignersView.h"
#import "MPDesignerInfoModel.h"
#import "MPDesignerBaseModel.h"
#import "MPDesignerDetailViewController.h"
#import "MPSearchCaseViewController.h"
#import "MPChatRoomViewController.h"
#import "MPChatUtility.h"
@interface MPFindDesignersViewController ()<MPFindDesignersViewDelegate>

@end

@implementation MPFindDesignersViewController
{
    MPFindDesignersView *_findDesignersView;   //<! _listView the view for table.
    NSMutableArray *_arrayDS;                  //<! _arrayDS array for datasource.
    NSInteger _offset;                         //<! _offset offset how many.
    NSInteger _limit;                          //<! _limit limlt how many.
    BOOL _isLoadMore;                          //!< _isLoadMore load more or not.
}

#pragma mark MPBaseViewController overrides

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tapOnRightButton:(id)sender
{
    [self.navigationController pushViewController:[[MPSearchCaseViewController alloc] init] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initBar];
    
    [self initUI];
    
    [self initData];
}
- (void)initBar {
    //self.tabBarController.tabBar.hidden = YES;
    self.menuLabel.hidden = YES;
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"look_for_key", nil);
}

- (void)initUI {
    _findDesignersView = [[MPFindDesignersView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
    _findDesignersView.delegate = self;
    [self.view addSubview:_findDesignersView];
}

- (void)initData {
    _arrayDS = [NSMutableArray array];
    _limit = 10;
    _offset = 0;
}

- (void)requestData {
    WS(weakSelf);
    [MPDesignerBaseModel getDataWithParameters:@{@"limit":@(_limit),@"offset":@(_offset)} success:^(NSArray *array) {
        
        if (!_isLoadMore)
            [_arrayDS removeAllObjects];
        
        [weakSelf endRefreshView:_isLoadMore];
        [_arrayDS addObjectsFromArray:array];
        [_findDesignersView refreshFindDesignersUI];
        
    } failure:^(NSError *error) {
        
        [weakSelf endRefreshView:_isLoadMore];
        [MPAlertView showAlertForNetError];
        NSLog(@"%@",error);
    }];
}

#pragma mark - MPFindDesignersViewDelegate methods

- (NSInteger) getDesignerCellCount {
    return [_arrayDS count];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
    MPDesignerInfoModel *modelInfo = _arrayDS[index];
    modelInfo.member_id = modelInfo.designer.acs_member_id;
    
    MPDesignerDetailViewController *vc = [[MPDesignerDetailViewController alloc]
                                          initWithIsDesignerCenter:NO
                                          designerInfoModel:modelInfo
                                          isConsumerNeeds:NO
                                          needInfo:nil
                                          needInfoIndex:0];

    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - MPFindDesignersTableViewCellDelegate methods

- (MPDesignerInfoModel *)getDesignerLibraryModelForIndex:(NSUInteger) index
{
    MPDesignerInfoModel *model = nil;
    
    if ([_arrayDS count])
        return [_arrayDS objectAtIndex:index];
    
    return model;
}


-(void) startChatWithDesignerForIndex:(NSUInteger) index
{
    MPDesignerInfoModel *model = [_arrayDS objectAtIndex:index];
    if ([AppController AppGlobal_GetLoginStatus]) {
        
           [AppController chatWithVC:self
                       ReceiverID:[model.designer.acs_member_id description]
              ReceiverHomeStyleID:model.hs_uid
                     receiverName:model.nick_name
                          assetID:nil
                         isQRScan:NO];
        
    } else {
        [AppController AppGlobal_ProccessLogin];
    }
}


-(void) followDesignerForIndex:(NSUInteger) index {
    
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
