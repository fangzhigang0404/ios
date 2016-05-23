/**
 * @file    MPDesignerDetailViewController.m
 * @brief   the controller of designer detail.
 * @author  niu
 * @version 1.0
 * @date    2016-01-26
 */

#import "MPDesignerDetailViewController.h"
#import "MPDesignerDetailView.h"
#import "MPCaseDetailViewController.h"
#import "MPMeasureHouseViewController.h"
#import "MPDesignerBaseModel.h"
#import "MPCaseBaseModel.h"
#import "MPChatRoomViewController.h"
#import "MPCaseLibraryDetailViewController.h"
#import "MPMeasureTool.h"
#import "MPDecorationNeedModel.h"
#import "MPOrderEmptyView.h"

@interface MPDesignerDetailViewController ()<MPDesignerDetailViewDelegate>

@end

@implementation MPDesignerDetailViewController
{
    MPDesignerDetailView *_designerDetailView;  //!< _designerDetailView the view for controller.
    NSMutableArray *_arrayDS;                   //!< _arrayDS the array for datasource.
    NSInteger _offset;                          //!< _offset offset for request.
    NSInteger _limit;                           //!< _limit limit for request.
    BOOL _isLoadMore;                           //!< _isLoadMore bool is load more or not.
    NSString *_designerID;                      //!< _designerID the id for designer.
    
    MPDecorationNeedModel *_needModel;          //!< _needModel the model for decoration.
    NSInteger _index;                           //!< _index the index for designer in bidders.
    MPDesignerInfoModel *_model;                //!< _model the model for designer.
    BOOL _isDesignerPersonCenter;               //!< _isDesignerPersonCenter from designer person or not.
    BOOL _isConsumerNeeds;                      //!< _isConsumerNeeds from consumer or not.
    BOOL _isBidder;                             //!< _isBidder from consumer bidder or not.
    MPOrderEmptyView *_emptyView;               //!< _emptyView the view for no case.
    
    BOOL _firstRequestOver;
}

- (instancetype)initWithIsDesignerCenter:(BOOL)isDesignerPersonCenter
                       designerInfoModel:(MPDesignerInfoModel *)model
                         isConsumerNeeds:(BOOL)isConsumerNeeds
                                needInfo:(MPDecorationNeedModel *)needModel
                           needInfoIndex:(NSInteger)index {
    
    self = [super init];
    if (self) {
        _needModel = needModel;
        _index = index;
        _model = model;
        _isDesignerPersonCenter = isDesignerPersonCenter;
        _isConsumerNeeds = isConsumerNeeds;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = nil;
    [self initData];
    
    [self initUI];
    
    [self requestDesignerInfo];
}

- (void)tapOnLeftButton:(id)sender {
    if (_isConsumerNeeds && !_isBidder) {
        if (self.success)
            self.success();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initData {
    _arrayDS = [NSMutableArray array];
    _limit = 10;
    _offset = 0;
    _isBidder = YES;
    _firstRequestOver = NO;
}

- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _designerDetailView = [[MPDesignerDetailView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _designerDetailView.delegate = self;
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        self.rightButton.hidden = YES;
        _designerDetailView.isDesigner = YES;
    }
    
    self.rightButton.hidden = YES;

    [self.view addSubview:_designerDetailView];
}

- (void)requestDesignerInfo {
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:_designerDetailView animated:YES];
    _designerID = [_model.member_id description];
    
    NSDictionary *param;
    if (_isDesignerPersonCenter) {
        
        param = @{@"designer_id" : [MPMember shareMember].acs_member_id,
                  @"hs_uid"      : [MPMember shareMember].hs_uid};
    } else {

        if (!_designerID || !_model.hs_uid) {
            [MPAlertView showAlertForParameterError];
            return;
        }
        param = @{@"designer_id": _designerID,
                  @"hs_uid"     : _model.hs_uid};        
    }
    
    [MPDesignerBaseModel getDesignerInfoWithParam:param success:^(MPDesignerInfoModel *model) {
        
        [weakSelf finishRequestDesignerInfo:model];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_designerDetailView animated:YES];
        [MPAlertView showAlertForNetError];
        NSLog(@"%@",error);
    }];
}

- (void)finishRequestDesignerInfo:(MPDesignerInfoModel *)model {
    _model = model;
    self.titleLabel.text = model.nick_name;
    [self requestData];
}

- (void)requestData {
    WS(weakSelf);

    if (_isDesignerPersonCenter) {
        _designerID = [MPMember shareMember].acs_member_id;
    } else {
        _designerID = [_model.designer.acs_member_id description];
    }
    
    if (_designerID == nil) {
        [MPAlertView showAlertForParameterError];
        [weakSelf endRefreshView:NO];
        return;
    }
    
    [MPCaseBaseModel getDataWithParameters:@{@"designer_id":_designerID,@"offset":@(_offset),@"limit":@(_limit)} success:^(NSArray *array) {
        
        [MBProgressHUD hideHUDForView:_designerDetailView animated:YES];
        _firstRequestOver = YES;
        
        if (!_isLoadMore)
            [_arrayDS removeAllObjects];
        
        [weakSelf endRefreshView:_isLoadMore];
        [_arrayDS addObjectsFromArray:array];
        [_designerDetailView refreshDesignerDetailUI];
        if (_arrayDS.count == 0) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_tip_no_case", nil) autoDisappearAfterDelay:1];
            [self createEmptyView];
        } else {
            if (_emptyView) [_emptyView removeFromSuperview];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:_designerDetailView animated:YES];
        
        [weakSelf endRefreshView:_isLoadMore];
        NSLog(@"%@",error);
        [MPAlertView showAlertForNetError];
    }];
}

- (void)createEmptyView {
    if (_emptyView) return;
    
    _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MPOrderEmptyView" owner:self options:nil] lastObject];
    CGFloat emptyViewY = [AppController AppGlobal_GetIsDesignerMode]?212.0f:255.0f;
    _emptyView.frame = CGRectMake(0, emptyViewY + NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - emptyViewY - NAVBAR_HEIGHT);
    
    _emptyView.imageViewY.constant = 80.0f;
    
    NSString *emptyInfo;

    if (_isDesignerPersonCenter) {
        emptyInfo = NSLocalizedString(@"just_tip_no_case_designer", nil);
    } else {
        emptyInfo = NSLocalizedString(@"just_tip_no_case_other", nil);
    }
    _emptyView.infoLabel.text = emptyInfo;
    [self.view addSubview:_emptyView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.3;
    [_emptyView addSubview:view];
}

#pragma mark - MPDesignerDetailViewDelegate
- (NSInteger)getDesignerDetailCaseCount {
    if (_firstRequestOver) {
        return _arrayDS.count + 1;
    }
    return 0;
}

- (void)didSelectCellAtIndex:(NSInteger)index {
    if (index == 0) {
        return;
    }
    
    MPCaseModel * model = [_arrayDS objectAtIndex:index-1];
    
    MPCaseLibraryDetailViewController *caseDetail = [[MPCaseLibraryDetailViewController alloc] init];
    caseDetail.model = model;
    caseDetail.case_id = model.case_id;
    caseDetail.arrayDS = _arrayDS;
    caseDetail.index = index-1;
    caseDetail.needModel = _needModel;
    caseDetail.bidderIndex = _index;
    caseDetail.thread_id = _thread_id;
    caseDetail.success = self.success;
    caseDetail.success = ^(){
        _isBidder = NO;
    };
    caseDetail.hs_uid = _model.hs_uid;
    [self customPushViewController:caseDetail animated:YES];

    
}

- (void)designerDetailViewRefreshLoadNewData:(void (^)())finish {
    self.refreshForLoadNew = finish;
    _offset = 0;
    _isLoadMore = NO;
    [self requestData];
}

- (void)designerDetailViewRefreshLoadMoreData:(void (^)())finish {
    self.refreshForLoadMore = finish;
    _offset += _limit;
    _isLoadMore = YES;
    [self requestData];
}

#pragma mark - MPDesignerDetailHeaderTableViewCellDelegate 
- (MPDesignerInfoModel *)getDesignerInfoModel {
    return _model;
}

- (void)chatWithDesigner {
    if ([AppController AppGlobal_GetLoginStatus]) {
        
        if (_isConsumerNeeds && _needModel) {
            if (self.thread_id.length == 0) {
                [MPAlertView showAlertForParameterError];
                return;
            }
            
            MPChatRoomViewController *vc = [[MPChatRoomViewController alloc]
                                            initWithThread:_thread_id
                                            withReceiverId:_designerID
                                            withReceiverName:_model.nick_name
                                            withAssetId:[_needModel.needs_id stringValue]
                                            loggedInUserId:[MPMember shareMember].acs_member_id];
            WS(weakSelf);
            vc.success = ^(){
                _isBidder = NO;
                if (weakSelf.success) {
                    weakSelf.success();
                }
            };
            [self.navigationController pushViewController:vc animated:YES];

        } else if (!_isConsumerNeeds && _needModel) {
            
            if (self.thread_id.length == 0) {
                [MPAlertView showAlertForParameterError];
                return;
            }
            
            MPChatRoomViewController *vc = [[MPChatRoomViewController alloc]
                                            initWithThread:_thread_id
                                            withReceiverId:_designerID
                                            withReceiverName:_model.nick_name
                                            withAssetId:[_needModel.needs_id stringValue]
                                            loggedInUserId:[MPMember shareMember].acs_member_id];
            [self.navigationController pushViewController:vc animated:YES];
            
        } else {
            [AppController chatWithVC:self
                           ReceiverID:_designerID
                  ReceiverHomeStyleID:_model.hs_uid
                         receiverName:_model.nick_name
                              assetID:nil
                             isQRScan:NO];
        }
        
        
    } else {
        [AppController AppGlobal_ProccessLogin];
    }
}

- (void)chooseTAMeasure {
    if (![AppController AppGlobal_GetLoginStatus]) {
        [AppController AppGlobal_ProccessLogin];
        return;
    }
    
    if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
        [MPAlertView showAlertWithMessage:@"功能开发中,敬请期待" sureKey:nil];
    } else {
        
        MPMeasureHouseViewController *vc;
        if (_isConsumerNeeds) {
            
            MPDecorationBidderModel *model = _needModel.bidders[_index];
            
            vc = [[MPMeasureHouseViewController alloc]
                  initWithDesignerID:[model.designer_id description]
                  measure_price:(model.measurement_fee == nil)?@"0":model.measurement_fee
                  hs_uid:model.uid
                  needModel:_needModel
                  isBidder:_isBidder
                  needID:nil];
            
            vc.success = ^(){
                _isBidder = NO;
            };

        } else {
            
            if ([_model.designer.is_real_name integerValue] == 2) {
                vc = [[MPMeasureHouseViewController alloc]
                      initWithDesignerID:[_model.designer.acs_member_id description]
                      measure_price:[_model.designer.measurement_price description]
                      hs_uid:_model.hs_uid
                      needModel:nil
                      isBidder:NO
                      needID:nil];
                
            } else {
                
                [MPAlertView showAlertWithMessage:NSLocalizedString(@"designer_certification", nil)
                          autoDisappearAfterDelay:1];
                return;
            }
        } 
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - MPDesignerDetailTableViewCellDelegate
- (MPCaseModel *)getDesignerDetailModelAtIndex:(NSInteger)index {
    if (_arrayDS.count) {
        return _arrayDS[index - 1];
    }
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
