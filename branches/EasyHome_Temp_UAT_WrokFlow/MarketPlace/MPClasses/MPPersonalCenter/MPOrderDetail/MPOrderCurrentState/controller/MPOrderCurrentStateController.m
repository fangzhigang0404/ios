/**
 * @file    MPOrderCurrentStateController.m
 * @brief   the controller of current asset status.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-27
 *
 */

#import "MPOrderCurrentStateController.h"
#import "MPOrderCurrentStateModel.h"
#import "MPOrderCurrentStateView.h"
#import "MPAPI.h"
#import "MPMeasureDetialController.h"
#import "MPStatusMachine.h"
#import "MPPayMentViewController.h"
#import "MPContractViewController.h"
#import "MPDeliveryController.h"
#import "MPMyProjectInfoViewController.h"
@interface MPOrderCurrentStateController ()<MPOrderCurrentStateViewDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, strong) MPOrderCurrentStateView *orderStateView;
@end

@implementation MPOrderCurrentStateController
{
    NSMutableArray *_arrayDS;
    MBProgressHUD *_hud;
    MPStatusModel *_statusModel;
    BOOL _isLoadMore;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _arrayDS = [NSMutableArray array];
        [_arrayDS addObjectsFromArray:[MPOrderCurrentStateModel getScheduleData]];
    }
    return self;
}

#pragma mark -Lazy Loading
- (MPOrderCurrentStateView *)orderStateView {
    if (_orderStateView == nil) {
        _orderStateView = [[MPOrderCurrentStateView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
        [self.view addSubview:_orderStateView];
    }
    return _orderStateView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.rightButton setImage:[UIImage imageNamed:@"projectmaterial"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initUI];
    [self.orderStateView refreshOrderStateView];
}
- (void)tapOnLeftButton:(id)sender
{
    if (self.backStatus) {
        self.backStatus(_statusModel.workFlowModel.wk_cur_sub_node_id);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initDataBack:(void(^)())back {

    WS(blockSelf);
    [MPStatusMachine getCurrentStatusWithNeedsID:self.needs_id withDesignerID:self.designer_id andSuccess:^(MPStatusModel *statusModel) {
        _statusModel = statusModel;
         blockSelf.titleLabel.text = statusModel.wk_measureModel.community_name;
        [MPOrderCurrentStateModel flashWithStatus:statusModel andSuccess:^(NSInteger nodeID, NSInteger flashID) {
            blockSelf.orderStateView.nodeID = nodeID;
            blockSelf.orderStateView.flashID = flashID;

            if (back) {
                back();
            }
        }];
    } andFailure:^(NSError *error) {
        MPLog(@"获取当前状态错误：%@",[NSString stringWithFormat:@"%@",error.description]);
        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
            [blockSelf endRefreshView:_isLoadMore];
        });
        
        

    }];
    
    
}

- (void)initUI {
    /// 待定
   
    self.view.backgroundColor = [UIColor whiteColor];
//    self.rightButton.hidden = YES;
    self.orderStateView.delegate = self;
    
}



#pragma mark - MPOrderCurrentStateViewDelegate
- (NSInteger)getContractCount {
    return _arrayDS.count;
}

- (void)didSelectCellAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
            MPMeasureDetialController *vc = [[MPMeasureDetialController alloc]init];
            vc.statusModel = _statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:{
            MPPayMentViewController *vc = [[MPPayMentViewController alloc]initWithPayType:MPPayForMeasure];
            vc.statusModel = _statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:{
            if ([_statusModel.workFlowModel.wk_cur_sub_node_id isEqualToString:@"33"]) {
                MPDeliveryController *vc;
                if ([AppController AppGlobal_GetIsDesignerMode]) {
                    vc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForMeasureSubmit];
                }else {
                    vc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForMeasureView];
                }
                vc.statusModel = _statusModel;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            MPContractViewController *vc = [[MPContractViewController alloc]init];
            vc.fromVC = self;
            vc.statusModel = _statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 3:{
            MPPayMentViewController *vc = [[MPPayMentViewController alloc]initWithPayType:MPPayForContractFirst];
            vc.statusModel = _statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 4:{
            MPPayMentViewController *vc = [[MPPayMentViewController alloc]initWithPayType:MPPayForContractLast];
            vc.statusModel = _statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 5:{
            MPDeliveryController *vc;
            if ([AppController AppGlobal_GetIsDesignerMode]) {
                if ([_statusModel.workFlowModel.wk_cur_sub_node_id isEqualToString:@"61"]) {
                    vc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForDesignView];
                }else {
                    vc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForDesignSubmit];
                }
            }else {
                vc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForDesignView];
            }
            vc.statusModel = _statusModel;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            break;
    }
    
}

- (void)tapOnRightButton:(id)sender {
    
    MPMyProjectInfoViewController *vc = [[MPMyProjectInfoViewController alloc] init];
    vc.statusModel = _statusModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - MPOrderCurrentStateCellDelegate
- (MPOrderCurrentStateModel *) getContractModelForIndex:(NSUInteger)index {
    if ([_statusModel.workFlowModel.wk_cur_sub_node_id isEqualToString:@"33"] && index == 2) {
        MPOrderCurrentStateModel *model = _arrayDS[index];
        if ([[AppController AppGlobal_GetMemberInfoObj].memberType isEqualToString:@"designer"]) {
            model.title = @"上传量房交付物";
            model.detailTitle = @"上传量房交付物";
        }else {
            model.title = @"接收量房交付物";
            model.detailTitle = @"接收量房交付物";
        }
        return model;
    }
    return _arrayDS[index];
}
@end
