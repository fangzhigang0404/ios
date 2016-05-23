/**
 * @file    MPMeasureInfoViewController.h
 * @brief   the controller of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-03-24
 */

#import "MPMeasureInfoViewController.h"
#import "MPDecorationBaseModel.h"
#import "MPPickerView.h"
#import "MPMeasureModelToDict.h"
#import "MPMeaNeedView.h"

@interface MPMeasureInfoViewController ()<MPMeaNeedViewDelegate>

@end

@implementation MPMeasureInfoViewController
{
    NSMutableArray *_arrayDS;           //!< _arrayDS the array of datasource.
    NSMutableArray *_arrayClose;        //!< _arrayClose the array of show detail Information.
    MPPickerView *_picker;              //!< _arrayDS the view of picker.
    MPDecorationNeedModel *_needModel;  //!< _needModel the model of decoration.
    NSInteger _limlt;                   //!< _limlt the limit of request.
    NSInteger _offset;                  //!< _offset the offset of request.
    MPMeaNeedView *_measureNeedView;    //!< _measureNeedView the view of measure.
    NSInteger _count;                   //!< _count the count of needs.
    NSInteger _seletedIndex;            //!< _seletedIndex the index of seleted.
    
    NSString *_designerID;              //!< _designerID the id of designer.
    NSString *_measurePrice;            //!< _measurePrice the price of measure.
    NSString *_hs_uid;                  //!< _hs_uid the string of designer uid.
}

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (instancetype)initWithDesignerID:(NSString *)designer_id
                      measurePrice:(NSString *)measure_price
                             hsuid:(NSString *)hs_uid {
    self = [super init];
    if (self) {
        _designerID = designer_id;
        _measurePrice = measure_price;
        _hs_uid = hs_uid;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self initData];
    
    [self showHUD];
    
    [self requestData];
}

- (void)initData {
    _arrayDS = [NSMutableArray array];
    _arrayClose = [NSMutableArray array];
    _limlt = 100;
    _offset = 0;
    _count = 8;
    _seletedIndex = 0;
    _measurePrice = (_measurePrice == nil)?@"0.00":_measurePrice;
    _measurePrice = ([_measurePrice rangeOfString:@"null"].length == 4)?@"0.00":_measurePrice;

}

- (void)requestData {
    WS(weakSelf);
    [MPDecorationBaseModel getDataWithParameters:@{@"limit":@(_limlt),@"offset":@(_offset),@"is_need":@"yes"} success:^(NSArray *array,NSInteger nouse) {

        if (array.count == 2) {
            [_arrayDS addObjectsFromArray:array[0]];
            [_arrayClose addObjectsFromArray:array[1]];
        }
        [weakSelf hideHUD];
        if (_arrayDS.count > 0)
            _needModel = _arrayDS[0];
        else
            [MPAlertView showAlertWithTitle:nil message:NSLocalizedString(@"no_measure_info", nil) sureKey:^{
                [weakSelf tapOnLeftButton:nil];
            }];
        [_measureNeedView refreshMeaInfoUIWithSeletedIndex:_seletedIndex];

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [weakSelf hideHUD];
        if (weakSelf.refreshForLoadMore) weakSelf.refreshForLoadMore();
        [MPAlertView showAlertForNetError];
    }];
}

- (void)initUI {
    self.view.backgroundColor = COLOR(237, 240, 243, 1);
    
    [self initNavigation];
    
    [self initMeaNeedView];
}

- (void)initNavigation {
    /// seting tabBar.
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"just_measure_need", nil);
}

- (void)initMeaNeedView {
    _measureNeedView = [[[NSBundle mainBundle] loadNibNamed:@"MPMeaNeedView" owner:self options:nil] lastObject];
    _measureNeedView.delegate = self;
    _measureNeedView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
    [self.view addSubview:_measureNeedView];
}

#pragma mark -
- (NSString *)getNeedNameStrAtIndex:(NSInteger)index {
    MPDecorationNeedModel *model = _arrayDS[index];
    return (model.community_name == nil)?NSLocalizedString(@"just_tip_no_data", nil):model.community_name;
}

- (void)seletedAndShowNeedAtIndex:(NSInteger)index {
    BOOL flag = [_arrayClose[index] boolValue];
    [_arrayClose replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:!flag]];
    
    if (index != _seletedIndex) {
        BOOL seletedFlag = [_arrayClose[index] boolValue];
        [_arrayClose replaceObjectAtIndex:_seletedIndex withObject:[NSNumber numberWithBool:!seletedFlag]];
    }
    [_measureNeedView refreshMeaInfoUIWithSeletedIndex:index];

    [self downViewAndShowPicker];
    _needModel = _arrayDS[index];
    _seletedIndex = index;
}

#pragma MPMeaNeedViewDelegate
- (NSInteger)getSectionInMeaNeedTableView {
    if (_arrayDS.count > _count) {
        return _count;
    }
    return _arrayDS.count;
}

- (NSInteger)getRowsInMeaNeedTableView:(NSInteger)section {
    if (_arrayClose.count > section) {
        if ([_arrayClose[section] integerValue]) {
            return 0;
        }
        return 1;
    }
    return 0;
}

- (void)chooseMeasureDateInPicker {
    WS(weakSelf);
    [self removePicker];
    CGRect rect = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 220);
    _picker = [[MPPickerView alloc] initWithFrame:rect
                                        plistName:@"MeasureTime"
                                     compontCount:4
                                          linkage:YES
                                           finish:^(NSString *componet1, NSString *componet2, NSString *componet3, BOOL isCancel, NSString *nian) {
                                               if (!isCancel)
                                                   
                                                   [_measureNeedView getMeaDateWithComponet1:componet1
                                                                                   componet2:componet2
                                                                                   componet3:componet3
                                                                                        nian:nian];
                                               [weakSelf downViewAndShowPicker];
                                           }];
    [self.view addSubview:_picker];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf upViewAndShowPicker];
    });
}

- (NSString *)getMeasurePriceForMeaNeedView {
    return _measurePrice;
}

- (void)sendMeasureNeedWithDate:(NSString *)date
                       complete:(void(^) ())complete {
    NSLog(@"%@",date);
    WS(weakSelf);
    [self showHUD];
    NSDictionary *body = [MPMeasureModelToDict getMeasureBodyWithModel:_needModel
                                                           measureDate:date
                                                            designerId:_designerID
                                                           mesurePrice:_measurePrice
                                                                hs_uid:_hs_uid
                                                              threadID:_thread_id];
    
    [MPDecorationBaseModel measureByConsumerSelfChooseDesignerNoNeedIdWithParam:body requestHeader:nil success:^(NSDictionary *dict) {
        if (complete) complete();
        [MPAlertView showAlertWithTitle:NSLocalizedString(@"just_tip_tishi_success", nil) message:NSLocalizedString(@"just_tip_tishi_success_order_message", nil) sureKey:^{
            [weakSelf popToChatVC];
        }];
        [weakSelf hideHUD];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (complete) complete();
        [weakSelf hideHUD];
        [MPAlertView showAlertForNetError];
        NSLog(@"%@",error);
    }];
}

- (void)hidePopupUI {
    [self downViewAndShowPicker];
}

- (void)loadMoreDataComplete:(void(^) ())complete {
    _count += 8;
    [_measureNeedView refreshMeaInfoUIWithSeletedIndex:_seletedIndex];
    if (complete) complete();
}

#pragma Mark- MPMeaInfoCellDelegate
- (MPDecorationNeedModel *)getModelForMeaNeedInfoView {
    return _arrayDS[_seletedIndex];
}

- (void)scrollWillHidePicker {
    [self downViewAndShowPicker];
}

- (void)popToChatVC {
    NSArray *array = self.navigationController.viewControllers;
    if (array.count > 2) {
        [self.navigationController popToViewController:array[array.count - 3] animated:YES];
    } else {
        NSLog(@"pop error in measure info vc");
    }
}

#pragma mark- methods
- (void)upViewAndShowPicker {
    [UIView animateWithDuration:0.3 animations:^{
        _measureNeedView.frame = CGRectMake(_measureNeedView.frame.origin.x,
                                            _measureNeedView.frame.origin.x + NAVBAR_HEIGHT - 230,
                                            _measureNeedView.frame.size.width,
                                            _measureNeedView.frame.size.height);

        _picker.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 220, CGRectGetWidth(self.view.frame), 220);
    }];
}

- (void)removePicker {
    [_picker removePickerView];
}

- (void)downViewAndShowPicker {
    [UIView animateWithDuration:0.3 animations:^{
        _picker.frame = CGRectMake(0, CGRectGetHeight(self.view.frame),0, 0);
        
        _measureNeedView.frame = CGRectMake(_measureNeedView.frame.origin.x,
                                            _measureNeedView.frame.origin.x + NAVBAR_HEIGHT,
                                            _measureNeedView.frame.size.width,
                                            _measureNeedView.frame.size.height);
        
    } completion:^(BOOL finished) {
        [_picker removePickerView];
    }];
}

- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:_measureNeedView animated:YES];
}

- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:_measureNeedView animated:YES];
}

@end
