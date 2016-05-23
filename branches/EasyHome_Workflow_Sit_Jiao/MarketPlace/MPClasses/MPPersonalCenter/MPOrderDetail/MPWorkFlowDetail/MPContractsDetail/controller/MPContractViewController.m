//
//  MPContractViewController.m
//  MarketPlace
//
//  Created by Jiao on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPContractViewController.h"
#import "MPDesignContractDetailView.h"
#import "MPDesignContractModel.h"
#import "MPSenddesigncontract.h"
#import "MPPayMentViewController.h"
#import "MPRegionManager.h"

@interface MPContractViewController ()<MPDesignContractDetailViewDeleagate>

@end

@implementation MPContractViewController
{
    MPDesignContractDetailView * _contractView;
    CGRect _textFieldF;
}

- (instancetype)initWithNeedsID:(NSString *)needs_id
                  andDesignerID:(NSString *)designer_id {
    self = [super init];
    if (self) {
        self.statusModel = [[MPStatusModel alloc]init];
        self.statusModel.needs_id = needs_id;
        self.statusModel.designer_id = designer_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.rightButton.hidden = YES;
    _contractView = [[MPDesignContractDetailView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _contractView.deleage = self;
    [self.view addSubview:_contractView];
    self.rightButton.hidden = YES;
    [self initData];
}
- (void)initData {
    WS(blockSelf);
    [MBProgressHUD showHUDAddedTo:_contractView animated:YES];
    
    ///获取当前状态
    [MPStatusMachine getCurrentStatusWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id andSuccess:^(MPStatusModel *statusModel) {
        blockSelf.statusDetail = [[MPStatusMachine getCurrentStatusMessageWithCurNodeID:statusModel.workFlowModel.wk_cur_sub_node_id] objectAtIndex:2];
        blockSelf.statusModel = statusModel;
        blockSelf.contractModel = [MPDesignContractModel designContractWithModel:statusModel.wk_contractModel];
        
        ///获取获取设计师信息
        [MPDesignContractModel getDesignerInformationWithDesignerID:(NSString *)blockSelf.statusModel.designer_id withHSUID:(NSString *)blockSelf.statusModel.hs_uid withSuccess:^(NSString *realName, NSString *mobile, NSString *email) {
            
            blockSelf.contractModel.designer_name = realName;
            blockSelf.contractModel.designer_mobile = mobile;
            blockSelf.contractModel.designer_email = email;

        ///判断是否有合同
        if (blockSelf.contractModel.isNew) {
            ///没有合同则设计师需创建合同
            if ([AppController AppGlobal_GetIsDesignerMode]) {
                
                
                    ///获取合同编号
                    [MPDesignContractModel getContractNOWithSuccess:^(NSString *contract_no) {
                        blockSelf.contractModel.contract_no = contract_no;
                        
                        ///初次获取消费者信息
                        blockSelf.contractModel.consumer_name = blockSelf.statusModel.wk_measureModel.contacts_name;
                        blockSelf.contractModel.consumer_mobile = blockSelf.statusModel.wk_measureModel.contacts_mobile;
                        
                        NSDictionary *regionDic = [[MPRegionManager sharedInstance] getRegionWithProvinceCode:blockSelf.statusModel.wk_measureModel.province withCityCode:blockSelf.statusModel.wk_measureModel.city andDistrictCode:blockSelf.statusModel.wk_measureModel.district];
                        blockSelf.contractModel.consumer_addr = [NSString stringWithFormat:@"%@%@%@",regionDic[@"province"],regionDic[@"city"],regionDic[@"district"]];
                        
                        blockSelf.contractModel.consumer_addrDe = blockSelf.statusModel.wk_measureModel.community_name;
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:_contractView animated:YES];
                            
                            [_contractView refreshContractView];
                        });
                    } andFailure:^{
                        NSLog(@"获取合同编号失败");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:_contractView animated:YES];
                            [MPAlertView showAlertWithMessage:@"获取信息失败" sureKey:^{
                                [blockSelf.navigationController popViewControllerAnimated:YES];
                            }];
                        });
                    }];
                
            }else {
                ///没有合同，如果是消费者，则提示等待合同
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:_contractView animated:YES];
                    [MPAlertView showAlertWithMessage:@"请等待设计师发送设计合同..." sureKey:^{
                        [blockSelf.navigationController popViewControllerAnimated:YES];
                    }];
                });
            }
            
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:_contractView animated:YES];
                [blockSelf.view addSubview:_contractView];
                [_contractView refreshContractView];
            });
        }
            } andFailure:^(NSError *error) {
            NSLog(@"获取设计师信息失败");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:_contractView animated:YES];
                [MPAlertView showAlertWithMessage:@"获取信息失败" sureKey:^{
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }];
            });
        }];
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_contractView animated:YES];
            [MPAlertView showAlertWithMessage:@"获取信息失败" sureKey:^{
                [blockSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    if (keyboardRect.origin.y < _textFieldF.origin.y + _textFieldF.size.height) {
        [UIView animateWithDuration:animationDuration animations:^{
            CGFloat bY =_textFieldF.origin.y + _textFieldF.size.height - keyboardRect.origin.y + 5;
            
            CGFloat y = _contractView.conTableView.contentOffset.y;
            _contractView.conTableView.contentOffset = CGPointMake(0, y + bY);
        }];
    }
}

- (void)textFieldFrame:(CGRect)frame {
    _textFieldF = frame;
}

- (void)addrY:(CGFloat)y_dif {
    [UIView animateWithDuration:0.4f animations:^{
        CGFloat y = _contractView.conTableView.contentOffset.y;
        _contractView.conTableView.contentOffset = CGPointMake(0, y + y_dif);
    }];
}

- (MPDesignContractModel *)updateCell {
    return self.contractModel;
}

- (MPStatusDetail *)updateCellUI {
    return self.statusDetail;
}

- (void)detailsBtn:(MPDesignContractModel *)model{
    
    MPSenddesigncontract * vc = [[MPSenddesigncontract alloc]init];
    vc.statusModel = self.statusModel;
    vc.selectShow = self.statusDetail.selectShow;
    vc.TotalCost = model.contract_charge;
    vc.FristCost = model.contract_first_charge;
    vc.EndCost = model.balance_payment;
    vc.fromVC = self.fromVC;
    vc.design_sketch = model.design_sketch;
    vc.render_map = model.render_map;
    vc.design_sketch_plus = model.design_sketch_plus;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)Sendbtn:(MPDesignContractModel *)model {
    WS(blockSelf);
    if ([[AppController AppGlobal_GetMemberInfoObj].memberType isEqualToString:@"designer"]) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [MPDesignContractModel createDesignContractWithNeedID:self.statusModel.needs_id withModel:model success:^(MPDesignContractModel *model) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
                [MPAlertView showAlertWithMessage:@"发送合同成功！" sureKey:^{
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }];
            });
            
        } failure:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
                [MPAlertView showAlertWithMessage:@"发送合同失败！" sureKey:nil];
            });
        }];
    }else {
        MPPayMentViewController *vc = [[MPPayMentViewController alloc]initWithPayType:MPPayForContractFirst];
        vc.statusModel = self.statusModel;
        vc.fromVC = self.fromVC;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    NSLog(@"vc gone");
}
@end
