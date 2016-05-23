//
//  MPIssueDemandSheet.m
//  MarketPlace
//
//  Created by WP on 16/2/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPIssueDemandSheet.h"
#import "MPDecorationBaseModel.h"
#import "MBProgressHUD.h"

@implementation MPIssueDemandSheet

+ (void)createSheetWithParameters:(NSDictionary *)parmeter alertController:(void(^)(UIAlertController *alertController))alertController finish:(void(^) (MPDecorationNeedModel *model))finish {
    UIView *view = parmeter[@"view"];
    NSString *limit = parmeter[@"limit"];
    NSString *offset = parmeter[@"offset"];
    [self showHUD:view];
    WS(weakSelf);
    [MPDecorationBaseModel getDataWithParameters:@{@"limit":limit,@"offset":offset} success:^(NSArray *array) {
        [weakSelf hideHUD:view];
        [weakSelf createActionSheet:array alertController:alertController finish:finish];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [weakSelf showNetError];
        [weakSelf hideHUD:view];
    }];
}

+ (void)createActionSheet:(NSArray *)array alertController:(void(^)(UIAlertController *alertController))alertController finish:(void(^) (MPDecorationNeedModel *model))finish {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"just_string_Issue_over", nil) message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSInteger i = 0; i < array.count; i++) {
        MPDecorationNeedModel *model = array[i];
        if (![[model.is_beishu description] isEqualToString:@"0"] && ![model.wk_template_id isEqualToString:@"2"]) {
            UIAlertAction *action = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"%@ %@",model.community_name,model.house_type] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                if (finish) {
                    finish(model);
                }
            }];
            [alert addAction:action];
        }
    }
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel_Key", nil) style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancelAction];
    if (alertController) {
        alertController(alert);
    }
}

+ (void)showHUD:(UIView *)view {
    [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+ (void)hideHUD:(UIView *)view {
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

+ (void)showNetError {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle : NSLocalizedString(@"just_tip_tishi", nil)
                                message : NSLocalizedString(@"just_tip_net_error", nil)
                               delegate : nil
                      cancelButtonTitle : NSLocalizedString(@"OK_Key", nil)
                      otherButtonTitles : nil];
    [alert show];
}

@end
