//
//  MPDeliveryController.m
//  MarketPlace
//
//  Created by Jiao on 16/3/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryController.h"
#import "MP3DPlanModel.h"
#import "MPDeliveryView.h"
#import "MPDeliveryDetailController.h"

#import "MP3DPlanModel.h"

@interface MPDeliveryController ()<MPDeliveryViewDelegate, MPDeliveryDetailControllerDelegate>

@end

@implementation MPDeliveryController
{
    MPDeliveryView *_deliveryView;
    MPDeliveryType _deliveryType;
    NSMutableDictionary *_tempDic;
    NSArray *_temp3DPlanArr;
    
    MP3DPlanModel *_currentPlan;
    BOOL renderBtn;
    BOOL designBtn;
    BOOL bomBtn;
    BOOL render;
    BOOL design;
    BOOL material;
}
#pragma mark - Init
- (instancetype)initWithType:(MPDeliveryType)type {
    self = [super init];
    if (self) {
        _deliveryType = type;
        renderBtn = NO;
        designBtn = NO;
        bomBtn = NO;
        render = NO;
        design = NO;
        material = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _temp3DPlanArr = [NSArray array];
    
    self.rightButton.hidden = YES;
    
    _deliveryView = [[MPDeliveryView alloc]initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT) andType:_deliveryType];
    _deliveryView.delegate = self;
    [self.view addSubview:_deliveryView];
    
    [self initData];
}


#pragma mark - Custom Method
- (void)initData {
    [MBProgressHUD showHUDAddedTo:_deliveryView animated:YES];
    WS(blockSelf);
    [MPStatusMachine getCurrentStatusWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id andSuccess:^(MPStatusModel *statusModel) {
        blockSelf.statusDetail = [[MPStatusMachine getCurrentStatusMessageWithCurNodeID:statusModel.workFlowModel.wk_cur_sub_node_id] firstObject];
        blockSelf.statusModel = statusModel;
        
        switch (_deliveryType) {
            case MPDeliveryTypeForMeasureSubmit: {
                blockSelf.titleLabel.text = @"我要交付";
                [blockSelf initDataForMeasureView];
                break;
            }
            case MPDeliveryTypeForDesignSubmit: {
                blockSelf.titleLabel.text = @"我要交付";
                [blockSelf initDataForDesignView];
                break;
            }
            case MPDeliveryTypeForMeasureView: {
                blockSelf.titleLabel.text = @"我的量房交付";
                [blockSelf initDataForMeasureView];
                break;
            }
            case MPDeliveryTypeForDesignView: {
                blockSelf.titleLabel.text = @"我的设计交付";
                [blockSelf initDataForDesignView];
                break;
            }
            default:
                break;
        }

    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        });
    }];
}

- (void)initDataForMeasureSubmit {
    WS(blockSelf);
    [MP3DPlanModel get3DPlansWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id withSuccess:^(NSArray *plansArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
            if (plansArray.count == 0) {
                [MPAlertView showAlertWithMessage:@"请登录Web端上传量房交付" sureKey:^{
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }];
                return ;
            }
            
            _temp3DPlanArr = plansArray;
            _currentPlan = plansArray[0];
            [blockSelf dataIsDesigner:YES hasArr_3D:YES hasArr_render:NO hasArr_design:YES hasArr_material:NO andBtn:NO andTitle:self.statusModel.wk_measureModel.community_name];
            [_deliveryView refreshDeliveryView];
        });
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
        });
    }];
}

- (void)initDataForDesignSubmit {
    WS(blockSelf);
    [MP3DPlanModel get3DPlansWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id withSuccess:^(NSArray *plansArray) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
            if (plansArray.count == 0) {
                [MPAlertView showAlertWithMessage:@"请登录Web端上传设计交付" sureKey:^{
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }];
                return ;
            }
            
            for (MP3DPlanModel *tempModel in plansArray) {
                if (tempModel.link == nil || [tempModel.link isKindOfClass:[NSNull class]] || [tempModel.link rangeOfString:@"null"].location != NSNotFound || [tempModel.link isEqualToString:@""]) {
                    [MPAlertView showAlertWithMessage:@"请确认已保存3D方案" sureKey:^{
                        [blockSelf.navigationController popViewControllerAnimated:YES];
                    }];
                    return ;
                }
            }
            
            _temp3DPlanArr = plansArray;
            [blockSelf dataIsDesigner:YES hasArr_3D:YES hasArr_render:NO hasArr_design:NO hasArr_material:NO andBtn:NO andTitle:self.statusModel.wk_measureModel.community_name];
            [_deliveryView refreshDeliveryView];            
        });
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
        });
    }];
}

- (void)initDataForMeasureView {
    WS(blockSelf);
    [MP3DPlanModel getMeasureDeliveryWithNeedsID:self.statusModel.needs_id withDesingerID:self.statusModel.designer_id withSucces:^(MP3DPlanModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!model) {
                if ([AppController AppGlobal_GetIsDesignerMode]) {
                    [blockSelf initDataForMeasureSubmit];
                    return;
                }
                [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
                [MPAlertView showAlertWithMessage:@"请耐心等待设计师发送量房交付" sureKey:^{
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }];
                return ;
            }
            
            [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
            _deliveryType = MPDeliveryTypeForMeasureView;
            _temp3DPlanArr = [NSArray arrayWithObject:model];
            _currentPlan = model;
            [blockSelf dataIsDesigner:NO hasArr_3D:YES hasArr_render:YES hasArr_design:YES hasArr_material:YES andBtn:NO andTitle:self.statusModel.wk_measureModel.community_name];
            [_deliveryView refreshDeliveryView];
        });
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
        });
    }];
}

- (void)initDataForDesignView {
    WS(blockSelf);
    [MP3DPlanModel getDesignDeliveryWithNeedsID:self.statusModel.needs_id withDesingerID:self.statusModel.designer_id withSucces:^(MP3DPlanModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!model) {
                if ([AppController AppGlobal_GetIsDesignerMode]) {
                    [blockSelf initDataForDesignSubmit];
                    return;
                }
                [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
                [MPAlertView showAlertWithMessage:@"请耐心等待设计师发送设计交付" sureKey:^{
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                }];
                return ;
            }
            
            [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
            _deliveryType = MPDeliveryTypeForDesignView;
            _temp3DPlanArr = [NSArray arrayWithObject:model];
            _currentPlan = model;
            [blockSelf dataIsDesigner:NO hasArr_3D:YES hasArr_render:YES hasArr_design:YES hasArr_material:YES andBtn:NO andTitle:self.statusModel.wk_measureModel.community_name];
            [_deliveryView refreshDeliveryView];
        });
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
            [MPAlertView showAlertWithMessage:@"请耐心等待设计师发送设计交付" sureKey:^{
                [blockSelf.navigationController popViewControllerAnimated:YES];
            }];
        });
    }];
}

- (void)dataIsDesigner:(BOOL)isDesigner hasArr_3D:(BOOL)arr_3D hasArr_render:(BOOL)arr_render hasArr_design:(BOOL)arr_design hasArr_material:(BOOL)arr_material andBtn:(BOOL)btn andTitle:(NSString *)title{
    _tempDic = [NSMutableDictionary dictionary];
    [_tempDic setValue:@(isDesigner) forKey:@"isDesigner"];
    [_tempDic setValue:@(arr_3D) forKey:@"arr_3D"];
    [_tempDic setValue:@(arr_render) forKey:@"arr_render"];
    [_tempDic setValue:@(arr_design) forKey:@"arr_design"];
    [_tempDic setValue:@(arr_material) forKey:@"arr_material"];
    [_tempDic setObject:@(btn) forKey:@"button"];
    [_tempDic setObject:title forKey:@"title"];
}
- (void)dataIsDesigner:(BOOL)isDesigner hasArr_design:(BOOL)arr_design andBtn:(BOOL)btn andTitle:(NSString *)title {
    _tempDic = [NSMutableDictionary dictionary];
    [_tempDic setValue:@(isDesigner) forKey:@"isDesigner"];
    [_tempDic setValue:@(arr_design) forKey:@"arr_design"];
    [_tempDic setObject:@(btn) forKey:@"button"];
    [_tempDic setObject:title forKey:@"title"];
}

#pragma mark - MPDeliveryBaseCellDelegate
- (NSDictionary *)updateUI {
    return _tempDic;
}

- (void)goToDeliveryDetailForIndex:(NSInteger)index {
    MPDeliveryDetailController *vc;
    switch (index) {
        case 0: {
            vc = [[MPDeliveryDetailController alloc]initWithFilesArray:_temp3DPlanArr andType:DeTypeForMy3D andControllerType:_deliveryType];
            break;
        }
        case 1: {
            vc = [[MPDeliveryDetailController alloc]initWithFilesArray:_currentPlan.delivery_renderArr andType:DeTypeForRender andControllerType:_deliveryType];
            break;
        }case 2: {
            vc = [[MPDeliveryDetailController alloc]initWithFilesArray:_currentPlan.delivery_designArr andType:DeTypeForDesign andControllerType:_deliveryType];
            break;
        }
        case 3: {
            vc = [[MPDeliveryDetailController alloc]initWithFilesArray:_currentPlan.delivery_BOMArr andType:DeTypeForMaterial andControllerType:_deliveryType];
            break;
        }
        case 4: {
            vc = [[MPDeliveryDetailController alloc]initWithFilesArray:_currentPlan.delivery_designArr andType:DeTypeForMeasure andControllerType:_deliveryType];
            break;
        }
        default:
            break;
    }
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendDelivery {
    WS(blockSelf);
    switch (_deliveryType) {
        case MPDeliveryTypeForMeasureSubmit: {
            NSLog(@"提交量房交付物");
            [MBProgressHUD showHUDAddedTo:_deliveryView animated:YES];
            [MP3DPlanModel submitMeasureDeliveryWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id withModel:_currentPlan withSuccess:^(NSDictionary *dict) {
               dispatch_async(dispatch_get_main_queue(), ^{
                   [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
                   [MPAlertView showAlertWithMessage:@"发送量房交付成功" sureKey:^{
                       [blockSelf.navigationController popViewControllerAnimated:YES];
                   }];
               });
            } andFailure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
                });
            }];
            break;
        }
        case MPDeliveryTypeForDesignSubmit: {
            [MBProgressHUD showHUDAddedTo:_deliveryView animated:YES];
            [MP3DPlanModel submitDesignDeliveryWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id withModel:_currentPlan withSuccess:^(NSDictionary *dict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
                    [MPAlertView showAlertWithMessage:@"发送设计交付成功" sureKey:^{
                        [blockSelf.navigationController popViewControllerAnimated:YES];
                    }];
                });
            } andFailure:^(NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:_deliveryView animated:YES];
                });
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark - MPDeliveryDetailControllerDelegate
- (void)selectedFiles:(NSArray *)files withType:(MPDeliveryDetailType)type withHas:(BOOL)has{
    
    switch (type) {
        case DeTypeForRender: {
            _currentPlan.delivery_renderArr = files;
            renderBtn = has;
            break;
        }
        case DeTypeForMeasure:
        case DeTypeForDesign: {
            _currentPlan.delivery_designArr = files;
            designBtn = has;
            break;
        }
        case DeTypeForMaterial: {
            _currentPlan.delivery_BOMArr = files;
            bomBtn = has;
            break;
        }
            
        default:
            break;
    }
    BOOL flag = NO;
    if (renderBtn && designBtn && bomBtn) {
        flag = YES;
    }
    
    if (_deliveryType == MPDeliveryTypeForMeasureSubmit) {
        flag = designBtn;
        design = YES;
    }
    [self dataIsDesigner:YES hasArr_3D:YES hasArr_render:render hasArr_design:design hasArr_material:material andBtn:flag andTitle:self.statusModel.wk_measureModel.community_name];
    [_deliveryView refreshDeliveryView];
}

- (void)selectedPlan:(MP3DPlanModel *)model {
    _currentPlan = model;
    if (_currentPlan) {
        render = _currentPlan.delivery_renderArr.count > 0 ? YES : NO;
        design = _currentPlan.delivery_designArr.count > 0 ? YES : NO;
        material = _currentPlan.delivery_BOMArr.count > 0 ? YES : NO;
    }else {
        render = NO;
        design = NO;
        material = NO;
    }
    renderBtn = NO;
    designBtn = NO;
    bomBtn = NO;
    [self dataIsDesigner:YES hasArr_3D:YES hasArr_render:render hasArr_design:design hasArr_material:material andBtn:NO andTitle:self.statusModel.wk_measureModel.community_name];
    [_deliveryView refreshDeliveryView];
    if (!render && !design && !material) {
        for (MP3DPlanModel *model in _temp3DPlanArr) {
            model.isSelected = NO;
            for (MP3DPlanDetailModel *deModel in model.delivery_renderArr) {
                deModel.isSelected = NO;
            }
            for (MP3DPlanDetailModel *deModel in model.delivery_designArr) {
                deModel.isSelected = NO;
            }
            for (MP3DPlanDetailModel *deModel in model.delivery_BOMArr) {
                deModel.isSelected = NO;
            }
        }
    }
}
@end
