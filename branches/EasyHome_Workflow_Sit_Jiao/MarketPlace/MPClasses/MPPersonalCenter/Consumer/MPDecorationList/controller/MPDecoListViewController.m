/**
 * @file    MPDecoListViewController.m
 * @brief   the controller of needs list.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPDecoListViewController.h"
#import "MPDecorationBaseModel.h"
#import "MPIssueDemandViewController.h"
#import "MPDecoListView.h"
#import "MPPopupDesignerView.h"
#import "MPOrderCurrentStateController.h"
#import "MPStatusModel.h"
#import "MPMeasureHouseViewController.h"
#import "MPChatRoomViewController.h"
#import "MPChatHttpManager.h"
#import "MPDecoPageView.h"
#import "MPOrderEmptyView.h"
#import "MPDesignerDetailViewController.h"
#import "MPDesignerInfoModel.h"

@interface MPDecoListViewController ()<MPDecoListViewDelegate>

@end

@implementation MPDecoListViewController
{
    NSMutableArray *_arrayDS;           //!< _arrayDS array for datasource.
    NSMutableArray *_arrayClose;        //!< _arrayClose the array for close or not.
    NSInteger _limit;                   //!< _limit limlt how many.
    NSInteger _offset;                  //!< _offset offset how many.
    MPDecoListView *_listView;          //!< _listView the view for table.
    NSInteger _index;                   //!< _index index of need in needs list.
    NSInteger _lastIndex;               //!< _lastIndex last index of need in needs list.
    NSInteger _designerIndex;           //!< _designerIndex the index of designer in bidders.
    MPDecorationNeedModel *_model;      //!< _model the model of current need.
    MPDecorationNeedModel *_lastModel;  //!< _lastModel the model of last need.
    NSInteger _lastX;                   //!< _lastX the num when scroll begin.
    UIButton *_loadMoreBtn;             //!< _loadMoreBtn the button for load more data.
    MPDecoPageView *_pageView;          //!< _pageView the view for page.
    MPOrderEmptyView *_emptyView;       //!< _emptyView the view for no needs.
    NSInteger _needsCount;
}

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initData];
    [self initUI];
    [self requestData];
}

- (void)initData {
    _arrayDS = [NSMutableArray array];
    _arrayClose = [NSMutableArray array];
    _limit = 10;
    _offset = 0;
    _index = 0;
    _needsCount = 0;
}

- (void)initUI {
    /// init view of table.
    _listView = [[MPDecoListView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _listView.delegate = self;
    [self.view addSubview:_listView];
    
    [self addLoadMoreButton];
    /// init something of Bar.
    self.titleLabel.text = NSLocalizedString(@"The order management_key", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.rightButton setImage:[UIImage imageNamed:ISSUE_DECORATION]
                      forState:UIControlStateNormal];
    
    
    _pageView = [[[NSBundle mainBundle] loadNibNamed:@"MPDecoPageView" owner:self options:nil] lastObject];
    _pageView.frame = CGRectMake(120, SCREEN_HEIGHT - 80, SCREEN_WIDTH - 240, 20);
    [self.view addSubview:_pageView];
}

- (void)addLoadMoreButton {
    _loadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loadMoreBtn.frame = CGRectMake(0, CGRectGetHeight(_listView.frame) - 50, CGRectGetWidth(_listView.frame), 50);
    [_loadMoreBtn setTitle:NSLocalizedString(@"just_tip_for_load_more", nil)
                  forState:UIControlStateNormal];
    [_loadMoreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_loadMoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_loadMoreBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _loadMoreBtn.hidden = YES;
    [_listView addSubview:_loadMoreBtn];
}

- (void)buttonClick:(UIButton *)button {
    _offset += _limit;
    [self requestData];
}

- (void)changeButtonTitle {
    [_loadMoreBtn setTitle:NSLocalizedString(@"just_tip_for_load_more", nil)
                  forState:UIControlStateNormal];
    _loadMoreBtn.hidden = YES;
}

- (void)tapOnRightButton:(id)sender {
    
    if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
        [MPAlertView showAlertWithMessage:@"功能开发中,敬请期待" sureKey:nil];
    } else {
        [self.navigationController pushViewController:[[MPIssueDemandViewController alloc] initWithType:MPDecorationVCTypeIssue needID:nil refresh:nil] animated:YES];
    }
}

/// request data.
- (void)requestData {
    WS(weakSelf);
    [self showHUD];
    [_loadMoreBtn setTitle:NSLocalizedString(@"just_tip_for_click_load_more", nil)
                  forState:UIControlStateNormal];
    [MPDecorationBaseModel getDataWithParameters:@{@"limit":@(_limit),@"offset":@(_offset)} success:^(NSArray *array,NSInteger needsCount) {
        if (array.count == 0) {
            [_loadMoreBtn setTitle:NSLocalizedString(@"just_tip_for_load_more_end", nil)
                          forState:UIControlStateNormal];
        } else {
            [_loadMoreBtn setTitle:NSLocalizedString(@"just_tip_for_load_more_over", nil)
                          forState:UIControlStateNormal];
        }
        [weakSelf performSelector:@selector(changeButtonTitle) withObject:nil afterDelay:1.2];
        for (id obj in array) {
            [_arrayDS addObject:obj];
            [_arrayClose addObject:[NSNumber numberWithBool:YES]];
        }

        if (_arrayDS.count == 0) {
            _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MPOrderEmptyView" owner:self options:nil] lastObject];
            _emptyView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
            [self.view addSubview:_emptyView];
        } else {
            if (_emptyView) [_emptyView removeFromSuperview];
            
            if (needsCount != 0) {
                _needsCount = needsCount;
                [_pageView setPageNumWithCount:needsCount index:_index];
            }
            [_listView refreshDecoListUI];
        }
        [weakSelf hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [weakSelf hideHUD];
        [weakSelf performSelector:@selector(changeButtonTitle) withObject:nil afterDelay:1.2];
        [MPAlertView showAlertForNetError];
    }];
}

- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:_listView animated:YES];
}

- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:_listView animated:YES];
}

#pragma mark - MPDecoListViewDelegate 
- (NSInteger)getDecoListCount {
    return _arrayDS.count;
}

- (BOOL)isBeishu:(NSInteger)index {
    MPDecorationNeedModel *model = _arrayDS[index];
    if ([model.is_beishu isEqualToString:@"1"]) {
        return NO;
    }
    return YES;
}

- (void)draggingWithContentOffsetX:(NSInteger)x {
    _lastX = x;
}

- (void)deceleratingWithContentOffsetX:(NSInteger)x {
    
    _loadMoreBtn.hidden = YES;

    if (x == CGRectGetWidth(_listView.frame) * (_arrayDS.count - 1)) {
        _loadMoreBtn.hidden = NO;
        _index = _arrayDS.count - 1;
    }else if (_lastX == x && x != 0) {
        _model = _lastModel;
        _index = _lastIndex;
    }
    else if (x == 0)
        _index = 0;
    [self updatePageView];
}

#pragma mark - MPDecoListCollectionViewCellDelegate
- (NSInteger)getDecoListHeaderCountForIndex:(NSUInteger) index {
    [_pageView updatePageViewWithIndex:index];
    _lastIndex = _index;
    _index = index;
    _lastModel = _model;
    _model = _arrayDS[index];
    _model.bidders = [[self deleteRefuseDesigner:_model.bidders] copy];
    return _model.bidders.count;
}

- (NSMutableArray *)deleteRefuseDesigner:(NSArray *)array {
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger i = 0; i < array.count; i++) {
        MPDecorationBidderModel *model = array[i];
        if (!([model.wk_cur_node_id isEqualToString:@"1"] &&
            [model.wk_cur_sub_node_id isEqualToString:@"12"])) {
            [arr addObject:model];
        }
    }
    return arr;
}

- (NSInteger)showDecoInfoWithSection:(NSInteger)section {
    if (_arrayClose.count > section) {
        if ([_arrayClose[section] integerValue]) {
            return 0;
        }
        return 1;
    }
    return 0;
}

#pragma mark - MPDecoDesiViewDelegate
- (MPDecorationNeedModel *)getBidderDesignerModelAtIndex:(NSInteger)index {
    MPDecorationBidderModel *model = _model.bidders[index - 1];
    model.need_id = [_model.needs_id description];
    return _model;
}

- (void)didSeletedDesignerAtIndex:(NSInteger)index
                      bidderModel:(MPDecorationBidderModel *)model
                        needModel:(MPDecorationNeedModel *)needModel {

    NSInteger node = [model.wk_cur_node_id integerValue];
    if (node == -1 && [model.template_id isEqualToString:@"1"]) {
        [MPPopupDesignerView showBidderDesignerInfoAddTo:self.view
                                                   model:model
                                               needModel:needModel
                                                   index:index - 1
                                                delegate:self
                                                animated:YES];
        
    }else if (node == -1) {
        
    } else {
        [self pushToOrderVC:model];
    }
}

- (void)didClickDesignerIocnAtIndex:(NSInteger)index
                        bidderModel:(MPDecorationBidderModel *)model
                          needModel:(MPDecorationNeedModel *)needModel {
    
    MPDesignerInfoModel *designerInfoM = [[MPDesignerInfoModel alloc] init];
    designerInfoM.member_id = model.designer_id;
    designerInfoM.hs_uid = model.uid;
    
    BOOL isConsumerNeed = NO;
    if ([model.wk_cur_node_id integerValue] == -1 && [model.template_id isEqualToString:@"1"]) {
        isConsumerNeed = YES;
    } else if ([model.wk_cur_node_id integerValue] == -1) {
        return;
    }
    
    MPDesignerDetailViewController *vc = [[MPDesignerDetailViewController alloc]
                                          initWithIsDesignerCenter:NO
                                          designerInfoModel:designerInfoM
                                          isConsumerNeeds:isConsumerNeed
                                          needInfo:needModel
                                          needInfoIndex:_designerIndex];
    
    vc.thread_id = model.design_thread_id;
    WS(weakSelf);
    vc.success = ^(){
        [weakSelf chooseDesigner:model];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MPDecoTopViewDelegate 
- (MPDecorationNeedModel *)getNeedModelAtIndex:(NSInteger)index {
    return _model;
}

- (void)didSeletedTopView:(NSInteger)index {
    BOOL flag = [_arrayClose[index] boolValue];
    [_arrayClose replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!flag]];
    [_listView refreshDecoListUI];
}

- (void)editDecorationWithNeedId:(NSString *)need_id index:(NSInteger)index {
    MPIssueDemandViewController *detailVC = [[MPIssueDemandViewController alloc] initWithType:MPDecorationVCTypeDetail needID:need_id refresh:^(MPDecorationNeedModel *model) {
        if (model != nil) {
            [_arrayDS replaceObjectAtIndex:index withObject:model];
        }
        [_listView refreshDecoListUI];
    }];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - MPDecoInfoCellDelegate
- (MPDecorationNeedModel *)getModelForDecoInfoViewAtIndex:(NSInteger)index {
    return _model;
}

#pragma mark - MPBidderDesignerInfoViewDelegate
- (void)clickedButtonAtIndex:(MPBidderButtonIndex)buttonIndex
                       index:(NSInteger)index
                 bidderModel:(MPDecorationBidderModel *)model
                   needModel:(MPDecorationNeedModel *)needModel {
    
    [MPPopupDesignerView hideAllViewAnimated:YES];
    _designerIndex = index;
    switch (buttonIndex) {
        case MPBidderButtonIndexMeasure:{
            if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
                [MPAlertView showAlertWithMessage:@"功能开发中,敬请期待" sureKey:nil];
            } else {
                [self chooseTaMeasure:model needModel:needModel];
            }
            break;
        }
        case MPBidderButtonIndexChat:{
            [self openChatRoom:model];
            NSLog(@"chat");
            break;
        }
        case MPBidderButtonIndexRefuse:{
            WS(weakSelf);
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_sure_delete", nil) sureKey:^{
                [weakSelf requestToRefuseDesigner:model];
            } cancelKey:nil];
            NSLog(@"refuse");
            break;
        }
        case MPBidderButtonIndexHeader:{
            [self pushToDesignerDetailInfoVC:model needModel:needModel];
            NSLog(@"look designer info");
            break;
        }
        default:
            break;
    }
}

#pragma mark - MPDecoBeishuCellDelegate
- (MPDecorationNeedModel *)getDecorationModelAtIndex:(NSInteger)index {
    [_pageView updatePageViewWithIndex:index];
    _lastIndex = _index;
    _index = index;
    _lastModel = _model;
    _model = _arrayDS[index];
    return _model;
}

- (void)callPhoneNumber:(NSString *)phoneNumber {
    [MPAlertView showAlertWithTitle:nil
                            message:[NSString stringWithFormat:@"%@%@?",NSLocalizedString(@"just_tip_call", nil),phoneNumber]
                     cancelKeyTitle:NSLocalizedString(@"cancel_Key", nil)
                      rightKeyTitle:NSLocalizedString(@"just_tip_call", nil)
                           rightKey:^{
                          
        [[UIApplication sharedApplication]
            openURL:[NSURL URLWithString:
                [NSString stringWithFormat:@"tel://%@",phoneNumber]]];
                          
    } cancelKey:nil];
}

- (void)chatWithDesigner:(MPDecorationNeedModel *)model {
    if (model.bidders.count >0) {
        MPDecorationBidderModel *modelBidder = model.bidders[0];

        if (model.beishu_thread_id.length == 0) {
            [MPAlertView showAlertForParameterError];
            return ;
        }
        MPChatRoomViewController *vc = [[MPChatRoomViewController alloc]
                                          initWithThread:model.beishu_thread_id
                                          withReceiverId:[modelBidder.designer_id description]
                                        withReceiverName:modelBidder.user_name
                                             withAssetId:nil
                                          loggedInUserId:[MPMember shareMember].acs_member_id];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - methods
- (void)requestToRefuseDesigner:(MPDecorationBidderModel *)model {
    [self showHUD];
    WS(weakSelf);

    [MPDecorationBaseModel deleteDesignerWithNeedId:model.need_id designerId:[model.designer_id description] withParameters:nil withRequestHeader:nil success:^(NSDictionary *dictionary) {
        [weakSelf hideHUD];
        [weakSelf deleteDesigner:model];
    } failure:^(NSError *error) {
        [weakSelf hideHUD];
        [MPAlertView showAlertForNetError];
        NSLog(@"%@",error);
    }];
}

- (void)deleteDesigner:(MPDecorationBidderModel *)model {
    model.wk_cur_sub_node_id = @"12";
    model.wk_cur_node_id = @"1";
    [_listView refreshDecoListUI];
}

- (void)chooseTaMeasure:(MPDecorationBidderModel *)model
              needModel:(MPDecorationNeedModel *)needModel{
    WS(weakSelf);

    MPMeasureHouseViewController *vc = [[MPMeasureHouseViewController alloc]
                                        initWithDesignerID:[model.designer_id description]
                                        measure_price:(model.measurement_fee == nil)?@"0":model.measurement_fee
                                        hs_uid:nil
                                        needModel:needModel
                                        isBidder:YES
                                        needID:nil];
    
    vc.success = ^(){
        [weakSelf chooseDesigner:model];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chooseDesigner:(MPDecorationBidderModel *)model {
    model.wk_cur_sub_node_id = @"11";
    model.wk_cur_node_id = @"1";
    [_listView refreshDecoListUI];
}

- (void)pushToOrderVC:(MPDecorationBidderModel *)model {
    MPOrderCurrentStateController *vc = [[MPOrderCurrentStateController alloc] init];
    vc.needs_id = model.need_id;
    vc.designer_id = [model.designer_id description];
    vc.backStatus = ^(NSString *sub_nodeID){
        model.wk_cur_sub_node_id = sub_nodeID;
        [_listView refreshDecoListUI];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToDesignerDetailInfoVC:(MPDecorationBidderModel *)model needModel:(MPDecorationNeedModel *)needModel{
    
    MPDesignerInfoModel *designerInfoM = [[MPDesignerInfoModel alloc] init];
    designerInfoM.member_id = model.designer_id;
    designerInfoM.hs_uid = model.uid;
    
    MPDesignerDetailViewController *vc = [[MPDesignerDetailViewController alloc]
                                          initWithIsDesignerCenter:NO
                                          designerInfoModel:designerInfoM
                                          isConsumerNeeds:YES
                                          needInfo:needModel
                                          needInfoIndex:_designerIndex];
    
    vc.thread_id = model.design_thread_id;
    WS(weakSelf);
    vc.success = ^(){
        [weakSelf chooseDesigner:model];
    };

    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openChatRoom:(MPDecorationBidderModel *)model {
    
    if (model.design_thread_id.length == 0) {
        [MPAlertView showAlertForParameterError];
        return;
    }
    
    MPChatRoomViewController *vc = [[MPChatRoomViewController alloc]
                                    initWithThread:model.design_thread_id
                                    withReceiverId:[model.designer_id description]
                                  withReceiverName:model.user_name
                                       withAssetId:model.need_id
                                    loggedInUserId:[MPMember shareMember].acs_member_id];
    WS(weakSelf);
    vc.success = ^(){
        [weakSelf chooseDesigner:model];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)updatePageView {
    [_pageView updatePageViewWithIndex:_index];
    if (_needsCount - _index <= 1) {
        _loadMoreBtn.hidden = YES;
    }
}

@end
