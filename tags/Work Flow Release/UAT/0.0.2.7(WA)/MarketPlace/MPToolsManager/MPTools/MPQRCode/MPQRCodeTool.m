//
//  MPQRCodeTool.m
//  MarketPlace
//
//  Created by WP on 16/4/8.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPQRCodeTool.h"
#import "MPAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import "MPMemberModel.h"
#import "MPCenterTool.h"

@implementation MPQRCodeTool

+ (void)checkQRWithViewController:(UIViewController *)vc
                             dict:(NSDictionary *)dict {
    
    if ([dict allKeys].count == 6) {
        
        [AppController chatWithVC:vc
                       ReceiverID:dict[@"member_id"]
              ReceiverHomeStyleID:dict[@"hs_uid"]
                     receiverName:dict[@"name"]
                          assetID:nil
                         isQRScan:YES];
        
    } else {
        [MPAlertView showAlertWithMessage:@"二维码格式错误,无法创建聊天" sureKey:^{
            [vc.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
}

+ (BOOL)checkCameraEnable {
    if (![self IsCaptureAvalible]) {
        [MPAlertView showAlertWithTitle:NSLocalizedString(@"photo_taker_permission_alert_message", nil)
                                message:NSLocalizedString(@"photo_picker_camera_setting", nil)
                         cancelKeyTitle:NSLocalizedString(@"cancel_Key", nil)
                          rightKeyTitle:NSLocalizedString(@"go_setting", nil)
                               rightKey:^{
                                   [AppController openSettingPrivacy];
                               } cancelKey:nil];
        return NO;
    }
    return YES;
}

+ (void)checkQRBtn:(UIButton *)btn {

    btn.hidden = YES;
    if ([[MPCenterTool getIsLoho] isEqualToString:@"2"]) {
        btn.hidden = NO;
    }
}

+ (BOOL)IsCaptureAvalible{
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!captureDevice) return NO;
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if (!input) return NO;
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    if (!captureMetadataOutput) return NO;
    return YES;
}

@end
