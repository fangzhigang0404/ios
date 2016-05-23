/**
 * @file    MPIssueDemandViewController.m
 * @brief   the controller of issue demand.
 * @author  niu
 * @version 1.0
 * @date    2015-01-20
 */

#import "MPIssueDemandViewController.h"
#import "MPPickerView.h"
#import "MPDecorationBaseModel.h"
#import "MPIssueDemandView.h"

@interface MPIssueDemandViewController ()<MPIssueDemandViewDelegate>

/// the block for edit over.
@property (nonatomic, copy) void (^refresh)(MPDecorationNeedModel *model);

@end

@implementation MPIssueDemandViewController
{
    MPPickerView *_picker;                  //!< _picker the picker view for choose information.
    MPDecorationNeedModel *_model;          //!< _model the model of decoration.
    NSString *_need_id;                     //!< _need_id the id of need.
    MPIssueDemandView *_issueDemandView;    //!< _issueDemandView the view for controller.
    MPDecorationVCType _isDetail;           //!< _isDetail the type for edit decoration.
}

- (instancetype)initWithType:(MPDecorationVCType)type
                      needID:(NSString *)need_id
                     refresh:(void(^) (MPDecorationNeedModel *))refresh {
    self = [super init];
    if (self) {
        self.refresh = refresh;
        _isDetail = type;
        _need_id = need_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
}

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initUI {
    self.view.backgroundColor = COLOR(237, 240, 243, 1);
    
    [self initNavigation];
    
    [self initIssueDemandView];
    
    [self updateUI];
}

- (void)initNavigation {
    /// seting tabBar.
    self.leftButton.frame = CGRectMake(4,20,60, 44);

    
    self.rightButton.hidden = YES;
    if (_isDetail == MPDecorationVCTypeDetail) {
        self.titleLabel.text = NSLocalizedString(@"just_title_demand_amend_message", nil);
    } else {
        self.titleLabel.text = NSLocalizedString(@"needKey", nil);
    }
}

- (void)initIssueDemandView {
    _issueDemandView = [[MPIssueDemandView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _issueDemandView.delegate = self;
    [self.view addSubview:_issueDemandView];
}

- (void)updateUI {
    if (_isDetail == MPDecorationVCTypeDetail) {
        [self requestDataIsAmend:NO];
    }
}

- (void)requestDataIsAmend:(BOOL)isAmend {
    [self showHUD];
    WS(weakSelf);
    [MPDecorationBaseModel createDecorateDetailWithNeedsId:_need_id success:^(NSDictionary *dict) {
        NSLog(@"dict:%@",dict);
        _model = [[MPDecorationNeedModel alloc] initWithDictionary:dict];
        [weakSelf hideHUD];
        if (isAmend) {
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_title_demand_amend_message_change", nil) sureKey:^{
                [weakSelf popBackAndUpdateListUI];
            }];
        } else {
            [_issueDemandView updateDecorationDetailUI:_model];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MPAlertView showAlertForNetError];
        [weakSelf hideHUD];
    }];
}

#pragma mark - MPIssueDemandViewDelegate
- (NSInteger)getNumOfSectionForIssueAmendView {
    return 1;
}

- (void)hidePickerInIssueAmendWhenScroll {
    [self hidePicker];
}

#pragma mark - MPIssueDemandCellDelegate
- (void)uploadDemandWithParameters:(NSDictionary *)parameters
                            header:(NSDictionary *)header
                            finish:(void(^) ())finish {
    [self showHUD];
    WS(weakSelf);
    [MPDecorationBaseModel issueDemandWithParam:parameters
                                  requestHeader:header
                                        success:^(NSDictionary *dict) {
        if (finish) finish();
        [weakSelf hideHUD];
        NSLog(@"**************************/nuploadDemand:%@",dict);
        [MPAlertView showAlertWithTitle:NSLocalizedString(@"just_tip_tishi_upload_success", nil)
                                message:NSLocalizedString(@"just_tip_tishi_success_message", nil)
                                sureKey:^{
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        if (finish) finish();
        [weakSelf hideHUD];
        [MPAlertView showAlertForNetError];
    }];
}

/// issue again.
- (void)issueAgainWithParameters:(NSDictionary *)parameters header:(NSDictionary *)header finish:(void (^)())finish{
    [self showHUD];
    WS(weafSelf);
    
    /// request net.
    [MPDecorationBaseModel createModifyDecorateDemandWithNeedsId:_need_id withParameters:parameters withRequestHeader:header success:^(NSDictionary *dict) {
        NSLog(@"parameters%@",parameters);
        
        [weafSelf hideHUD];
        if (finish) finish();
        [weafSelf requestDataIsAmend:YES];
    } failure:^(NSError *error) {
        if (finish) finish();
        [weafSelf hideHUD];
        [MPAlertView showAlertForNetError];
        NSLog(@"%@",error);
    }];
}

- (void)cancelDecoration {
    WS(weakSelf);
    [MPAlertView showAlertWithTitle:NSLocalizedString(@"just_cancel_need", nil)
                            message:NSLocalizedString(@"just_sure_delete_need", nil)
                            sureKey:^{
                                [weakSelf requestCancelDecorate];
                            } cancelKey:nil];
}

/// cancel decoration.
- (void)requestCancelDecorate {
    [self showHUD];
    WS(weakSelf);
    
    [MPDecorationBaseModel createCancleDecorateDemandWithNeedId:[_model.needs_id description] requestHeader:nil Success:^(NSString *string) {
        [weakSelf hideHUD];
        [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_sure_delete_need_success", nil) sureKey:^{
            _model.is_public = @"1";
            _model.end_day = NSLocalizedString(@"just_already_end", nil);
            [weakSelf popBackAndUpdateListUI];
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MPAlertView showAlertForNetError];
        [weakSelf hideHUD];
    }];
}

/// back to list and refresh.
- (void)popBackAndUpdateListUI {
    if (self.refresh) {
        self.refresh(_model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)chooseInfoWithType:(NSString *)type
                  componet:(NSInteger)componet
                   linkage:(BOOL)isLinkage {
    WS(weakSelf);
    [self removePicker];
    _picker = [[MPPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 220)
                                        plistName:type
                                     compontCount:componet
                                          linkage:isLinkage
                                           finish:^(NSString *componet1, NSString *componet2, NSString *componet3, BOOL isCancel, NSString *nian) {
        if (!isCancel)
            [_issueDemandView getPickerInfoInIssueAmendViewWithType:type
                                                          componet1:componet1
                                                          componet2:componet2
                                                          componet3:componet3];
        [weakSelf hidePicker];
    }];
    [self.view addSubview:_picker];
    [self showPicker];
    
}

- (void)showPicker {
    [UIView animateWithDuration:0.3 animations:^{
        _picker.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 220, CGRectGetWidth(self.view.frame), 220);
    }];
}

- (void)removePicker {
    [_picker removePickerView];
}

- (void)hidePicker {
    [UIView animateWithDuration:0.3 animations:^{
        _picker.frame = CGRectMake(0, CGRectGetHeight(self.view.frame),0, 0);
    } completion:^(BOOL finished) {
        [_picker removePickerView];
    }];
}

- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}



@end
