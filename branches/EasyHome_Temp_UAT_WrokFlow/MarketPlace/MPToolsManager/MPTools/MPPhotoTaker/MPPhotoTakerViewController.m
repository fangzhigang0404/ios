//
//  MPPhotoTakerViewController.m
//  MarketPlace
//
//  Created by Arnav Jain on 16/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

@import AVFoundation;
@import Photos;
#import "MPPhotoTakerViewController.h"
#import "MPFileUtility.h"
#import "MPUIUtility.h"
#import "MPPhotoAlbumUtility.h"
#import "MPAlertView.h"

@interface MPPhotoTakerViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *cameraUI;

- (void)checkForAuthorizationAndProceed;
- (void)presentImagePickerController;
- (void)stopImageCaptureWithURL:(NSURL *)imageURL;

@end

@implementation MPPhotoTakerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.cameraUI)
        [self performSelector:@selector(checkForAuthorizationAndProceed) withObject:nil afterDelay:0.1f];
}

- (void)checkForAuthorizationAndProceed
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];

    if (status == AVAuthorizationStatusAuthorized)
        [self presentImagePickerController];
    else
    {
        __weak MPPhotoTakerViewController *weakSelf = self;
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted)
         {
             MPPhotoTakerViewController *strongInnerSelf = weakSelf;

             dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                    if (granted)
                        [strongInnerSelf presentImagePickerController];
                    else
                    {
                        [MPAlertView showAlertWithTitle:NSLocalizedString(@"photo_picker_camera", nil)
                                                message:NSLocalizedString(@"photo_picker_camera_setting", nil)
                                         cancelKeyTitle:NSLocalizedString(@"cancel_Key", nil)
                                          rightKeyTitle:NSLocalizedString(@"go_setting", nil)
                                               rightKey:^{
                                                   [AppController openSettingPrivacy];
                                                   [strongInnerSelf performSelector:@selector(popToChatRoom) withObject:nil afterDelay:0.5];
                                               } cancelKey:^{
                                                   [strongInnerSelf.delegate userDeniedCameraAccess];
                                                   
                                               }];
//                         MPAlertHandler actionHandler = ^(UIAlertAction *action)
//                         {
//                             // Inform the delegate that the user has made the unlikely choice
//                             // of denying us camera access
//                              [strongInnerSelf.delegate userDeniedCameraAccess];
//                         };
//
//                         [strongInnerSelf createPermissionDeniedAlertWithHandler:actionHandler];
                    }
                });
         }];
    }
}

- (void)popToChatRoom {
    [self.delegate userDeniedCameraAccess];
}

- (void)presentImagePickerController
{
    if ([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
    {
        __weak MPPhotoTakerViewController *weakSelf = self;
        [self createNoCameraAlertWithHandler:^(UIAlertAction *action)
        {
            // Inform the delegate that the user is attempting to
            // take a photo on a device sans camera
            [weakSelf.delegate userDoesNotHaveUsableCamera];
        }];

        return;
    }

    self.cameraUI = [[UIImagePickerController alloc] init];
    self.cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;

    // Check if the image picker controller's camera supports the image type
    if ([[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera] containsObject:(NSString *)kUTTypeImage])
    {
        self.cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
    }
    else
    {
        __weak MPPhotoTakerViewController *weakSelf = self;
        [self createNoCameraAlertWithHandler:^(UIAlertAction *action)
         {
             // Inform the delegate that the user is attempting to
             // take a photo on a device which has a camera but does
             // not support any kind of media capture
             [weakSelf.delegate userDoesNotHaveUsableCamera];
         }];

        return;
    }

    // Do not allow editing
    self.cameraUI.allowsEditing = NO;

    self.cameraUI.delegate = self;

    [self presentViewController:self.cameraUI animated:NO completion:nil];
}

- (void)stopImageCaptureWithURL:(NSURL *)imageURL
{
    __weak MPPhotoTakerViewController *weakSelf = self;
    [self.cameraUI dismissViewControllerAnimated:YES completion:^(void)
     {
         MPPhotoTakerViewController *strongInnerSelf = weakSelf;

         strongInnerSelf.cameraUI = nil;

         // Give the image URL to our delegate
         [strongInnerSelf.delegate userDidTakePhotoWithURL:imageURL];
     }];
}

#pragma mark - UIImagePickerController delegate methods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    __weak MPPhotoTakerViewController *weakSelf = self;
    [self.cameraUI dismissViewControllerAnimated:YES completion:^(void)
     {
         MPPhotoTakerViewController *strongInnerSelf = weakSelf;

         strongInnerSelf.cameraUI = nil;

         // Inform the delegate that the user has, regretfully, cancelled photo taking
         [strongInnerSelf.delegate userDidCancelPhotoTaking];
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage;

    // Make sure that the mediaType is of image type
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo)
    {
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];

        UIImage *rotatedImage = [self normalizedImageForImage:originalImage];

        // Save the image
        NSString *path = [MPFileUtility writeImage:rotatedImage
                                          withName:nil
                               isPNGRepresentation:NO];

        NSURL *imageURL = [[NSURL alloc] initFileURLWithPath:path];
        NSLog(@"Path of saved image: %@", imageURL);

        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

        switch (status)
        {
            case PHAuthorizationStatusAuthorized:
                NSLog(@"Saving image to user's camera roll");
                UIImageWriteToSavedPhotosAlbum(rotatedImage, self, nil, NULL);

                [self stopImageCaptureWithURL:imageURL];
                break;
            case PHAuthorizationStatusNotDetermined:
            {
                // Ask the user to grant permission to access their photos
                __weak MPPhotoTakerViewController *weakSelf = self;
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
                 {
                     if (status == PHAuthorizationStatusAuthorized)
                     {
                         // We are authorized, UIImagePicker would save the
                         // image on our behalf to the camera roll
                         NSLog(@"Saving image to user's camera roll");
                         UIImageWriteToSavedPhotosAlbum(rotatedImage, self, nil, NULL);
                     }

                     [weakSelf stopImageCaptureWithURL:imageURL];
                 }];
                break;
            }

            case PHAuthorizationStatusDenied:
            case PHAuthorizationStatusRestricted:
                [self stopImageCaptureWithURL:imageURL];
                break;
                
            default:
                break;
        }
    }
    else
        [self createGenericAlert];
}

#pragma mark - Utility methods
- (void)createGenericAlert
{
    NSString *localizedTitle = NSLocalizedString(@"photo_taker_alert_view_title", nil);
    NSString *localizedMessage = NSLocalizedString(@"photo_taker_alert_view_message", nil);

    UIAlertController *alert = [MPUIUtility createSimpleAlertWithTitle:localizedTitle withMessage:localizedMessage withActionTitle:nil];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createPermissionDeniedAlertWithHandler:(MPAlertHandler)actionHandler
{
    NSString *localizedTitle = NSLocalizedString(@"photo_taker_permission_alert_title", nil);
    NSString *localizedMessage = NSLocalizedString(@"photo_taker_permission_alert_message", nil);

    UIAlertController *alert = [MPUIUtility createSimpleAlertWithTitle:localizedTitle withMessage:localizedMessage withActionTitle:nil withActionHandler:actionHandler];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createNoCameraAlertWithHandler:(MPAlertHandler)actionHandler
{
    NSString *localizedTitle = NSLocalizedString(@"photo_taker_nocamera_alert_title", nil);
    NSString *localizedMessage = NSLocalizedString(@"photo_taker_nocamera_alert_message", nil);

    UIAlertController *alert = [MPUIUtility createSimpleAlertWithTitle:localizedTitle withMessage:localizedMessage withActionTitle:nil withActionHandler:actionHandler];

    [self presentViewController:alert animated:YES completion:nil];
}

- (UIImage *)normalizedImageForImage:(UIImage *)sourceImage
{
    if (sourceImage.imageOrientation == UIImageOrientationUp) return sourceImage;

    UIGraphicsBeginImageContextWithOptions(sourceImage.size, NO, sourceImage.scale);
    [sourceImage drawInRect:(CGRect){0, 0, sourceImage.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
