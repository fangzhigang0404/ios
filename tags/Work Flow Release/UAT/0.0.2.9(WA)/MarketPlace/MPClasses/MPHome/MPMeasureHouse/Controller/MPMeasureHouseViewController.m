/**
 * @file    MPMeasureHouseViewController.m
 * @brief   the controller of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-03-24
 */

#import "MPMeasureHouseViewController.h"
#import "MPPickerView.h"
#import "MPDecorationBaseModel.h"
#import "MPMeasureHouseView.h"
#import "MPMeasureInfoViewController.h"
#import "MPDesignerBaseModel.h"
#import "MPStatusMachine.h"
#import "MPStatusModel.h"
#import "MPRegionManager.h"
#import "MPMeasureTool.h"
#import "MPChatThreads.h"
#import "MPChatThread.h"

@interface MPMeasureHouseViewController ()<MPMeasureHouseViewDelegate>

@end

@implementation MPMeasureHouseViewController
{
    MPPickerView *_picker;                  //!< _picker the view of picker.
    MPMeasureHouseView *_measureHouseView;  //!< _measureHouseView the view of measure house.
    
    NSString *_designer_id;                 //!< _designer_id the id of designer.
    NSString *_measure_price;               //!< _measure_price the price of measure.
    NSString *_hs_uid;                      //!< _hs_uid the string of designer uid.
    MPDecorationNeedModel *_needModel;      //!< _needModel the model of decoration.
    BOOL _isBidder;                         //!< _isBidder the bool of bidder or not.
    NSString *_need_id;                     //!< _need_id the id of decoration.
    
    BOOL _im_bidder;                        //!< _im_bidder the bool of measure from IM.
    
    NSString *_thread_id;
}

- (instancetype)initWithDesignerID:(NSString *)designer_id
                     measure_price:(NSString *)measure_price
                            hs_uid:(NSString *)hs_uid
                         needModel:(MPDecorationNeedModel *)needModel
                          isBidder:(BOOL)isBidder
                            needID:(NSString *)need_id {
    self = [super init];
    if (self) {
        _designer_id = designer_id;
        _measure_price = measure_price;
        _hs_uid = hs_uid;
        _needModel = needModel;
        _isBidder = isBidder;
        _need_id = need_id;
    }
    return self;
}

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self initData];
    
    [self requestThreadID];
}

- (void)initData {
    _im_bidder = NO;
    WS(weakSelf);
    [self showHUD];

    if (!_isBidder) {

        if (_hs_uid == nil) {
            [self hideHUD];
            return;
        }
        
        NSDictionary *param = @{@"designer_id":_designer_id,
                                @"hs_uid"     :_hs_uid};
        [MPDesignerBaseModel getDesignerInfoWithParam:param success:^(MPDesignerInfoModel *model) {
            [weakSelf hideHUD];
            _measure_price = [model.designer.measurement_price description];
            if ([model.designer.is_real_name integerValue] == 2) {
                [_measureHouseView refreshIssueDemandUI];
            } else {
                [MPAlertView showAlertWithMessage:NSLocalizedString(@"designer_certification", nil) sureKey:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }
        } failure:^(NSError *error) {
            [weakSelf hideHUD];
            [MPAlertView showAlertWithMessage:@"获取设计师资料失败,请重新尝试" sureKey:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }];
    } else {
        
        if (_need_id && !_needModel) {
            _im_bidder = YES;
            [MPStatusMachine getCurrentStatusWithNeedsID:_need_id withDesignerID:_designer_id andSuccess:^(MPStatusModel *statusModel) {
                
                [weakSelf hideHUD];
                [weakSelf changeStatusModelToNeedModel:statusModel];
                [_measureHouseView refreshIssueDemandUI];
            } andFailure:^(NSError *error) {
                [weakSelf hideHUD];
                [MPAlertView showAlertWithMessage:@"获取项目资料失败,请重新尝试" sureKey:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }];

        }
        [self hideHUD];
    }
}

- (void)changeStatusModelToNeedModel:(MPStatusModel *)model {

    _needModel = [[MPDecorationNeedModel alloc] init];
    MPWKMeasureModel *measureModel  = model.wk_measureModel;
    _needModel.contacts_name        = measureModel.contacts_name;
    _needModel.contacts_mobile      = measureModel.contacts_mobile;
    _needModel.decoration_budget    = measureModel.decoration_budget;
    _needModel.design_budget        = measureModel.design_budget;
    _needModel.house_type           = measureModel.house_type;
    _needModel.house_area           = measureModel.house_area;
    _needModel.room                 = measureModel.room;
    _needModel.living_room          = measureModel.living_room;
    _needModel.toilet               = measureModel.toilet;
    _needModel.decoration_style     = measureModel.decoration_style;
    
    NSDictionary *addressDict       = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:measureModel.province
                                                                                     withCityCode:measureModel.city
                                                                                  andDistrictCode:measureModel.district];
    _needModel.province             = measureModel.province;
    _needModel.city                 = measureModel.city;
    _needModel.district             = measureModel.district;
    _needModel.province_name        = addressDict[@"province"];
    _needModel.city_name            = addressDict[@"city"];
    _needModel.district_name        = addressDict[@"district"];
    
    _needModel.community_name       = measureModel.community_name;
    _measure_price                  = measureModel.measurement_fee;
    _needModel.needs_id             = (id)_need_id;
}

- (void)requestThreadID {
    NSArray* members = @[[MPMember shareMember].acs_member_id,_designer_id,ADMIN_USER_ID];
    [[MPChatHttpManager sharedInstance] retrieveMultipleMemberThreads:members withOffset:0 andLimit:10 success:^(MPChatThreads *threads) {
        
        if (threads.threads.count > 0) {
            MPChatThread *thread = threads.threads[0];
            _thread_id = thread.thread_id;

        } else {
            _thread_id = @"";
        }
        [_measureHouseView refreshIssueDemandUI];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        _thread_id = @"";
        [_measureHouseView refreshIssueDemandUI];
    }];

}

- (void)initUI {
    [self initNavigation];
    
    [self initMeasureHouseView];
}

- (void)initNavigation {
    /// seting tabBar.
    //self.tabBarController.tabBar.hidden = YES;
    [self.rightButton setImage:[UIImage imageNamed:MEASURE_HOUSE_GET_NEED] forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(SCREEN_WIDTH - 41, 32, 20, 20);
    if (_isBidder) {
        self.rightButton.hidden = YES;
    }
    self.titleLabel.text = NSLocalizedString(@"just_string_measure_table", nil);
}

- (void)initMeasureHouseView {
    _measureHouseView = [[MPMeasureHouseView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _measureHouseView.delegate = self;
    [self.view addSubview:_measureHouseView];
}

- (void)tapOnRightButton:(id)sender {
    MPMeasureInfoViewController *vc = [[MPMeasureInfoViewController alloc]
                                       initWithDesignerID:_designer_id
                                       measurePrice:_measure_price
                                       hsuid:_hs_uid];
    vc.thread_id = _thread_id;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MPMeasureHouseViewDelegate
- (NSInteger)getNumOfSectionForMeasureHouseView {
    return 1;
}

- (void)hidePickerInMeasureHouseWhenScroll {
    [self hidePicker];
}

#pragma mark - MPMeasureHouseCellDelegate
- (NSString *)getMeasureHousePrice {
    return _measure_price = [NSString stringWithFormat:@"%.2f",[_measure_price floatValue]];
}

- (NSString *)getMeasureDesignerId {
    return _designer_id;
}

- (MPDecorationNeedModel *)getNeedInfo {
    if (_isBidder) {
        return _needModel;
    }
    return nil;
}

- (NSString *)getHsUid {
    if (_hs_uid == nil) {
        return @"";
    }
    return _hs_uid;
}

- (NSString *)getThreadId {
    if (_thread_id == nil || [_thread_id rangeOfString:@"null"].length == 4) {
        return @"";
    }
    return _thread_id;
}

- (void)sendMeasureTableWithParameters:(NSDictionary *)parameters
                                header:(NSDictionary *)header
                              isBidder:(BOOL)isBidder
                                finish:(void(^) ())finish {
    [self showHUD];
    WS(weakSelf);
    
    if (!isBidder) {
        [MPDecorationBaseModel measureByConsumerSelfChooseDesignerNoNeedIdWithParam:parameters
                                                                      requestHeader:header
                                                                            success:^(NSDictionary *dict) {
            if (finish) finish();
            [MPAlertView showAlertWithTitle:NSLocalizedString(@"just_tip_tishi_success", nil) message:NSLocalizedString(@"just_tip_tishi_success_order_message", nil) sureKey:^{
               [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            [weakSelf hideHUD];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (finish) finish();
            [weakSelf hideHUD];
            [MPAlertView showAlertForNetError];
            NSLog(@"%@",error);
        }];
    } else {
        [MPDecorationBaseModel measureByConsumerSelfChooseDesignerWithParam:parameters
                                                              requestHeader:nil
                                                                    success:^(NSDictionary *dict) {
            [weakSelf hideHUD];
            if (finish) finish();
            [MPAlertView showAlertWithTitle:NSLocalizedString(@"just_tip_tishi", nil) message:NSLocalizedString(@"just_tip_tishi_success_order_message", nil) sureKey:^{
                if (weakSelf.success)
                    weakSelf.success();
                if (_im_bidder)
                    [MPMeasureTool saveMeasureSuccessInfo];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf hideHUD];
            if (finish) finish();
            [MPAlertView showAlertForNetError];
            NSLog(@"%@",error);
        }];
    }
}

- (void)chooseInfoWithType:(NSString *)type
                  componet:(NSInteger)componet
                   linkage:(BOOL)isLinkage {
    WS(weakSelf);
    [self removePicker];
    _picker = [[MPPickerView alloc] initWithFrame:CGRectMake(0,
                                                             self.view.frame.size.height,
                                                             self.view.frame.size.width,
                                                             220)
                                        plistName:type
                                     compontCount:componet
                                          linkage:isLinkage
                                           finish:^(NSString *componet1, NSString *componet2, NSString *componet3, BOOL isCancel, NSString *nian) {
                                               if (!isCancel)
                                                   [_measureHouseView getPickerInfoInIssueAmendViewWithType:type
                                                                                                 componet1:componet1
                                                                                                 componet2:componet2
                                                                                                 componet3:componet3
                                                                                                       nian:nian];
                                               
                                               else
                                                   [_measureHouseView getPickerInfoInIssueAmendViewWithType:nil
                                                                                                   componet1:nil
                                                                                                   componet2:nil
                                                                                                   componet3:nil
                                                                                                        nian:nil];
                                               [weakSelf hidePicker];
                                           }];
    [self.view addSubview:_picker];
    dispatch_async_get_main_safe(^{
        [weakSelf showPicker];
    });
}

- (void)showPicker {
    [UIView animateWithDuration:0.3 animations:^{
        _picker.frame = CGRectMake(0, self.view.frame.size.height - 220, self.view.frame.size.width, 220);
    }];
}

- (void)removePicker {
    [_picker removePickerView];
}

- (void)hidePicker {
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        _picker.frame = CGRectMake(0, self.view.frame.size.height,0, 0);
    } completion:^(BOOL finished) {
        [weakSelf removePicker];
    }];
}

- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:_measureHouseView animated:YES];
}

- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:_measureHouseView animated:YES];
}

@end
