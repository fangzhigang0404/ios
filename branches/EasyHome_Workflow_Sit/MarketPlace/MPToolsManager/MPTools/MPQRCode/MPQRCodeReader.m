//
//  MPQRCodeReader.m
//  QR Code
//
//  Created by niu on 16/1/11.
//  Copyright © 2016年 niu. All rights reserved.
//

#import "MPQRCodeReader.h"
#import <AVFoundation/AVFoundation.h>

@interface MPQRCodeReader ()<AVCaptureMetadataOutputObjectsDelegate>

@end

@implementation MPQRCodeReader
{
    UIView *_viewPreview;
    UILabel *_labellStatus;
    UIImageView *_boxImageView;
    UIImageView *_scanImageView;
    BOOL _isReading;
    AVCaptureSession *_captureSession;
    AVCaptureVideoPreviewLayer *_videoPreviewLayer;
    NSTimer *_timer;
}

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navgationImageview removeFromSuperview];
    
    [self readyReading];
    
    [self initNavigation];
    
    [self setNavigationControllerWithColor:[UIColor blackColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = NO;
    [_captureSession startRunning];
}

- (void)initNavigation {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:BUTTON_BACK] style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 64)];
    title.text = NSLocalizedString(@"just_QR_code", nil);
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationControllerWithColor:(UIColor *)color {
    [self.navigationController.navigationBar  setBackgroundImage:[self createImageWithColor:color] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar  setShadowImage:[self createImageWithColor:color]];
    [self.navigationController.navigationBar  setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar  setTranslucent:YES];
}

- (UIImage *)createImageWithColor: (UIColor *) color {
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)initTipMessage {
    _labellStatus = [[UILabel alloc] initWithFrame:CGRectMake(_viewPreview.frame.size.width/2 - 150, _boxImageView.frame.origin.y + CGRectGetWidth(_boxImageView.frame) + 5, 300, 50)];
    _labellStatus.textColor = [UIColor whiteColor];
    _labellStatus.textAlignment = NSTextAlignmentCenter;
    _labellStatus.adjustsFontSizeToFitWidth = YES;
    _labellStatus.text = NSLocalizedString(@"just_QR_code_message", nil);
    [_viewPreview addSubview:_labellStatus];
}

- (void)readyReading {
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    
    _captureSession = [[AVCaptureSession alloc] init];
    
    if ([_captureSession canAddInput:input]) {
        [_captureSession addInput:input];
    } else {
        return;
    }
    
    if ([_captureSession canAddOutput:captureMetadataOutput]) {
        [_captureSession addOutput:captureMetadataOutput];
    } else {
        return;
    }
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _viewPreview = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_viewPreview belowSubview:self.navgationImageview];
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    ///CGRectMake（y/sc.height，x/sc.width，height/sc.height，width/sc.width）
    captureMetadataOutput.rectOfInterest = CGRectMake(((_viewPreview.bounds.size.height * 0.2f + 20) * 1.0)/_viewPreview.frame.size.height, (50 * 1.0)/_viewPreview.frame.size.width, ((_viewPreview.bounds.size.width - 100) * 1.0)/_viewPreview.bounds.size.height, ((_viewPreview.bounds.size.width - 100) * 1.0)/_viewPreview.bounds.size.width);
    
    _boxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, _viewPreview.bounds.size.height * 0.2f + 20, _viewPreview.bounds.size.width - 100, _viewPreview.bounds.size.width - 100)];
    _boxImageView.image = [UIImage imageNamed:QR_LINE_READER];
    
    [_viewPreview addSubview:_boxImageView];
    
    [self initTipMessage];
    
    _scanImageView = [[UIImageView alloc] init];
    _scanImageView.frame = CGRectMake(0, 0, _boxImageView.bounds.size.width, 1);
    _scanImageView.image = [UIImage imageNamed:QR_LINE];
    [_boxImageView addSubview:_scanImageView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(moveScanLayer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
}

- (void)moveScanLayer:(NSTimer *)timer {
    CGRect frame = _scanImageView.frame;
    if (_boxImageView.frame.size.height < _scanImageView.frame.origin.y) {
        frame.origin.y = 0;
        _scanImageView.frame = frame;
    }else{
        
        frame.origin.y += 1;
        
        [UIView animateWithDuration:0.01 animations:^{
            _scanImageView.frame = frame;
        }];
    }
}



-(void)stopReading {
    [_captureSession stopRunning];
    //    _captureSession = nil;
    //    [_scanImageView removeFromSuperview];
    //    [_videoPreviewLayer removeFromSuperlayer];
    //    [_viewPreview removeFromSuperview];
    if (_timer != nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    [self stopReading];
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        if (self.dict) {
            NSData *jsonData = [metadataObj.stringValue dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
            self.dict(dic);
        }
    }
}

@end
