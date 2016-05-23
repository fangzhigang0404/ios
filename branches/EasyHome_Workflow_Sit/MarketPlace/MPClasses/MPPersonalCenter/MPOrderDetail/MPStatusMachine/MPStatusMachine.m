//
//  MPStateMachine.m
//  MarketPlace
//
//  Created by Jiao on 16/1/27.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPStatusMachine.h"
#import "MPAPI.h"
#import "MPStatusModel.h"

#import "MPMeasureDetialController.h"
#import "MPPayMentViewController.h"
#import "MPContractViewController.h"
#import "MPDeliveryController.h"
#import "MPOpenMeaVCTool.h"

#define STATUS_MACHINE_ERROR @"status_machine_error_key"

@implementation MPStatusMachine

#pragma mark -SharedInstance
+ (instancetype)sharedInstance {
    
    static MPStatusMachine *s_state = nil;
    static dispatch_once_t s_predicate;
    dispatch_once(&s_predicate, ^{
        s_state = [[super allocWithZone:NULL]init];
    });
    
    return s_state;
}

///override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [MPStatusMachine sharedInstance];
}

///override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return [MPStatusMachine sharedInstance];
}

#pragma mark -Custom Method
+ (void)getCurrentStatusWithNeedsID:(NSString *)needs_id
                     withDesignerID:(NSString *)designer_id
                         andSuccess:(void(^)(MPStatusModel *))success
                         andFailure:(void(^)(NSError *))failure {
    [MPAPI getCurrentStatusWithNeedID:needs_id withDesignerID:designer_id andSuccess:^(NSDictionary *dict) {
        if (success) {
            success([MPStatusModel getCurrentStatusModelWithDict:dict[@"requirement"]]);
        }
    } andFailure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        MPLog(@"获取当前状态出错：%@",error.description);
    }];
}

+ (NSString *)getCurrentNodeName:(MPStatusModel *)statusModel {
    
    NSString *fileName;
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        fileName = @"MPCurrentNodeDesigner";
    }else {
        fileName = @"MPCurrentNodeConsumer";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSString *errorStr = NSLocalizedString(STATUS_MACHINE_ERROR, nil);
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSString *str;
    for (NSDictionary *wk_template in array) {
        if ([wk_template[@"wk_template_id"] isEqualToString:statusModel.workFlowModel.wk_template_id]) {

            for (NSDictionary *wk_cur_node in wk_template[@"wk_cur_node"]) {
                if ([wk_cur_node[@"wk_cur_node_id"] isEqualToString:statusModel.workFlowModel.wk_cur_node_id]) {
                    str = [NSString stringWithFormat:@"%@",wk_cur_node[@"nName"]];
                    return str;
                }
            }
        }
    }
    return errorStr;
    
}

+ (NSString *)getCurrentSubNodeName:(NSString *)sub_node_id {
    NSString *fileName;
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        fileName = @"MPSubNodeMsgDesigner";
    }else {
        fileName = @"MPSubNodeMsgConsumer";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSString *errorStr = NSLocalizedString(STATUS_MACHINE_ERROR, nil);
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSDictionary *wk_cur_sub_node in array) {
        if ([wk_cur_sub_node[@"wk_cur_sub_node_id"] isEqualToString:sub_node_id]) {
            return wk_cur_sub_node[@"wk_cur_sub_name"];
        }
    }
    return errorStr;
}

+ (NSArray *)getCurrentStatusMessageWithCurNodeID:(NSString *)cur_nodeID {
    NSString *fileName;
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        fileName = @"MPSubNodeMsgDesigner";
    }else {
        fileName = @"MPSubNodeMsgConsumer";
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *cur_node in array) {
        if ([cur_node[@"wk_cur_sub_node_id"] isEqualToString:cur_nodeID]) {
            for (NSDictionary *dict in cur_node[@"detail"]) {
                [resultArray addObject:[MPStatusDetail getStatusDetailWithDict:dict]];
            }
        }
    }
    
    return resultArray;
}

+ (void)mpPerformCurrentEventWithController:(__kindof UIViewController *)vc
                                withNeedsID:(NSString *)needs_id
                             withDesignerID:(NSString *)designer_id
                         withDesignerhs_uid:(NSString *)uid
                            andCurSubNodeID:(NSString *)wk_cur_sub_node_id {

    NSAssert(vc, @"UIViewController must be present");
    NSInteger cur_sub_node_id = [wk_cur_sub_node_id integerValue];
    switch (cur_sub_node_id) {
        case -1:{
            [MPOpenMeaVCTool openMeasureVCYingbiaoWithDesignerID:designer_id hs_uid:uid needID:needs_id vc:vc];
            break;//邀请量房后续商榷
        }
        case 0:
              if (uid!=nil)
                  [MPOpenMeaVCTool openMeasureVCZixuanWithDesignerID:designer_id hs_uid:uid vc:vc];
             break;
        case 11:
        case 12:
        case 14:{
            MPMeasureDetialController *mpvc = [[MPMeasureDetialController alloc]initWithNeedID:needs_id andDesignerID:designer_id];
            [vc.navigationController pushViewController:mpvc animated:YES];
            break;
        }
        case 13: {
            MPPayMentViewController *mpvc = [[MPPayMentViewController alloc]initWithPayType:MPPayForMeasure];
            mpvc.statusModel = [[MPStatusModel alloc]init];
            mpvc.statusModel.needs_id = needs_id;
            mpvc.statusModel.designer_id = designer_id;
            [vc.navigationController pushViewController:mpvc animated:YES];
            break;
        }
        case 21:
        case 22:
        case 31:{
            MPContractViewController *mpvc = [[MPContractViewController alloc]initWithNeedsID:needs_id andDesignerID:designer_id];
            mpvc.fromVC = vc;
            [vc.navigationController pushViewController:mpvc animated:YES];
            break;
        }
        case 33: {
            MPDeliveryController *mpvc;
            if ([AppController AppGlobal_GetIsDesignerMode]) {
                mpvc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForMeasureSubmit];
            }else {
                mpvc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForMeasureView];
            }
            mpvc.statusModel = [[MPStatusModel alloc]init];
            mpvc.statusModel.needs_id = needs_id;
            mpvc.statusModel.designer_id = designer_id;
            [vc.navigationController pushViewController:mpvc animated:YES];
            break;
        }
        case 41:
        case 42: {
            MPPayMentViewController *mpvc = [[MPPayMentViewController alloc]initWithPayType:MPPayForContractLast];
            mpvc.statusModel = [[MPStatusModel alloc]init];
            mpvc.statusModel.needs_id = needs_id;
            mpvc.statusModel.designer_id = designer_id;
            [vc.navigationController pushViewController:mpvc animated:YES];
            break;
        }
        case 51:
        case 52:{
            MPDeliveryController *mpvc;
            if ([AppController AppGlobal_GetIsDesignerMode]) {
                mpvc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForDesignSubmit];
            }else {
                mpvc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForDesignView];
            }
            mpvc.statusModel = [[MPStatusModel alloc]init];
            mpvc.statusModel.needs_id = needs_id;
            mpvc.statusModel.designer_id = designer_id;
            [vc.navigationController pushViewController:mpvc animated:YES];
            break;
        }
        case 61:
        case 62:{
            MPDeliveryController *mpvc = [[MPDeliveryController alloc] initWithType:MPDeliveryTypeForDesignView];

            mpvc.statusModel = [[MPStatusModel alloc]init];
            mpvc.statusModel.needs_id = needs_id;
            mpvc.statusModel.designer_id = designer_id;
            [vc.navigationController pushViewController:mpvc animated:YES];
            break;

        }
        default:
            break;
    }
}

+ (void)getCurrentIconWithCurSubNodeId:(NSString *)wk_cur_sub_node_id
                           withSuccess:(void(^)(NSString *, NSString *))success {
    NSString *fileName;
    if ([AppController AppGlobal_GetIsDesignerMode]) {
        fileName = @"MPActionIconDesigner";
    }else {
        fileName = @"MPActionIconConsumer";
    }
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    for (NSDictionary *icon in array) {
        NSString *sub_node_id = icon[@"sub_node_id"];
        NSString *iconName = icon[@"iconName"];
        if ([icon[@"iconName"] isEqualToString:@""]) {
            iconName = nil;
        }
        NSString *iconTitle = icon[@"iconTitle"];
        if ([sub_node_id isEqualToString:wk_cur_sub_node_id]) {
            if (success) {
                success(iconName, iconTitle);
            }
            return;
        }
    }
}

+ (void)getCurrentIconWithNeedsID:(NSString *)needs_id
                   withDesignerID:(NSString *)designer_id
                      withSuccess:(void(^)(NSString *, NSString *))success
                       andFailure:(void(^)(NSError *))failure {
    
    [MPStatusMachine getCurrentStatusWithNeedsID:needs_id withDesignerID:designer_id andSuccess:^(MPStatusModel *statusModel) {
        [MPStatusMachine getCurrentIconWithCurSubNodeId:statusModel.workFlowModel.wk_cur_sub_node_id withSuccess:success];
    } andFailure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end