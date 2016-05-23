//
//  MPFileChatViewController.m
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/10/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPFileChatViewController.h"
#import "MPFileChatImageView.h"
#import "MPImageChatRoomViewController.h"
#import "MPChatHttpManager.h"
#import "MPChatEntities.h"
#import "MPChatEntity.h"
#import "MPChatConversation.h"
#import "MPChatConversations.h"
#import "MPChatHttpManager.h"
#import "MPChatTestUser.h"
#import "MPFileUtility.h"
#import "MPChatProjectInfo.h"

#define TOTAL_ALLOWED_POINTS 10


@interface MPFileChatViewController ()<MPImageChatRoomViewControllerDelegate>
{
    MPFileChatImageView *                   _mpFileChatImageView;
    __strong NSURLSessionDownloadTask*      _downloadTask;
    __weak IBOutlet UIView *_busyWheelBackgroundView;
    __weak IBOutlet UIView *_onBoardingView1;
    __weak IBOutlet UIImageView *_onBoardingView2;
    __weak IBOutlet UIImageView *_onBoardingView3;
    __weak IBOutlet NSLayoutConstraint *_viewTopConstraint;
    __weak IBOutlet NSLayoutConstraint *_viewLeadingConstraint;
    __weak IBOutlet UIButton *_overLayButton;
    NSInteger _tapCount;
}

@property (nonatomic, assign) BOOL bEnableAddingLocation;
@property (nonatomic,strong) UIImage *mainImage;
@property (weak, nonatomic) IBOutlet UIButton *addLocationButton;

@property (nonatomic,strong) NSString *fileId;
@property (nonatomic,strong) NSString *serverFileURL;

@property (nonatomic,strong) NSString *parentThreadId;
@property (nonatomic,strong) NSString *receiverUserId;
@property (nonatomic,strong) NSString *receiverUserName;
@property (nonatomic,strong) NSString *loggedInUserId;

@property (nonatomic,strong) MPChatProjectInfo *projInfo;

@property (nonatomic,strong) NSURL *imageURL;
@property (nonatomic,strong) MPChatConversations *chatConversations;
@property (nonatomic,assign) NSInteger totalAddedpoints;

@end

@implementation MPFileChatViewController


- (instancetype)initWithFileId:(NSString *)fileId
                 serverFileURL:(NSString*) serverFileURL
                withReceiverId:(NSString *)receiverUserId
              withReceiverName:(NSString *)receiverUserName
                loggedInUserId:(NSString*)loggedInUserId
                   projectInfo:(MPChatProjectInfo*) projInfo
{
    self = [super initWithNibName:@"MPFileChatViewController"
                           bundle:nil];
    
    if (self)
    {
        self.fileId = fileId;
        self.serverFileURL = serverFileURL;
        self.receiverUserId = receiverUserId;
        self.receiverUserName = receiverUserName;
        self.loggedInUserId =  loggedInUserId;
        self.projInfo = projInfo;
    }
    
    return self;
    
}


- (instancetype)initWithImageURL:(NSURL *)imageURL  //currently this should be local
                  withReceiverId:(NSString *)receiverUserId
                withReceiverName:(NSString *)receiverUserName
                  loggedInUserId:(NSString*)loggedInUserId
                  parentThreadId:(NSString*)parentThreadId
                     projectInfo:(MPChatProjectInfo*) projInfo

{
    self = [super initWithNibName:@"MPFileChatViewController"
                           bundle:nil];
    
    if (self)
    {
        self.imageURL = imageURL;
        self.receiverUserId = receiverUserId;
        self.receiverUserName = receiverUserName;
        self.loggedInUserId = loggedInUserId;
        self.parentThreadId =  parentThreadId;
        self.projInfo = projInfo;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tapCount = 0;
    //self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.rightButton setImage:nil
                      forState:UIControlStateNormal];
    
    [self.rightButton setTitle:NSLocalizedString(@"Send_key", @"Send")
                      forState:UIControlStateNormal];
    self.titleLabel.text = NSLocalizedString(@"Filechat_key", @"Content based chat");

    if (![self shouldShowOnboarding])
        [self removeAllOnboardingViews];
    
    //else show onboarding after loading image ONLY
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    if (self.fileId) //download image and then create main view
    {

        [_addLocationButton setEnabled:NO];
        self.totalAddedpoints = 0;
        [self downloadImageFromServer];
    }
    else if (self.imageURL)
    {
        [_addLocationButton setEnabled:YES];
        //load local image
        self.mainImage = [UIImage imageWithContentsOfFile:self.imageURL.path];
        [self createFileChatView];
    }
    [self registerHandler];
}


- (void) viewWillDisappear:(BOOL)animated
{
    if (_downloadTask)
        [_downloadTask cancel];
    _downloadTask = nil;
    [super viewWillDisappear:animated];
    [self unRegisterHandler];
}

- (void) registerHandler {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageGotFromNotification:) name:@"MPChatReceiveNewMessaage" object:nil];
}

- (void) unRegisterHandler {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// update the badge for pt.
- (void) messageGotFromNotification:(NSNotification*)msgNotification {
    if (_fileId) {
        [self retrieveThreadsAndUpdateView:self.fileId];
    }
}

- (void) downloadImageFromServer
{
    self.rightButton.hidden = YES;
    if (self.serverFileURL) //download image and then create main view
        [self downloadImageFromServerWithFileURL];
    else
        [self downloadImageFromServerWithFileId];
    
}

- (void) downloadImageFromServerWithFileURL
{
    [self showLoadingIndicator];
    //check if file is present in cache or not
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.fileId];
    NSString *filePath = [MPFileUtility getFilePath:fileName];
    
    if (filePath)
    {
        self.imageURL = [NSURL URLWithString:filePath];
        self.mainImage = [UIImage imageWithContentsOfFile:filePath];
        [self retrieveThreadsAndUpdateView:self.fileId];
    }
    else
    {
        NSURL *fileURL = [MPFileUtility generateCacheFileURL:fileName];
      
        _downloadTask = [[MPChatHttpManager sharedInstance] downloadFileFromURL:[NSString stringWithFormat:@"%@Original.jpg", self.serverFileURL]
                                                                   atTargetPath:fileURL
                                                                       progress:^(NSProgress *downloadProgress)
                         {
                             NSLog(@"InProgress");
                         }
                                                                        success:^(NSURL* filePath, id responseObject)
                         {
                             NSLog(@"Success");
                             _downloadTask = nil;
                             self.imageURL = filePath;
                             self.mainImage = [UIImage imageWithContentsOfFile:self.imageURL.path];
                             [self retrieveThreadsAndUpdateView:self.fileId];
                         }
                                                                        failure:^(NSError* error)
                         {
                             [self hideLoadingIndicator];
                             NSLog(@"failure");
                             _downloadTask = nil;
                         }];
    }
}


- (void) downloadImageFromServerWithFileId
{
    [self showLoadingIndicator];
    //check if file is present in cache or not
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.fileId];
    NSString *filePath = [MPFileUtility getFilePath:fileName];
    
    if (filePath)
    {
        self.imageURL = [NSURL URLWithString:filePath];
        self.mainImage = [UIImage imageWithContentsOfFile:filePath];
        [self retrieveThreadsAndUpdateView:self.fileId];
    }
    else
    {
        NSURL *fileURL = [MPFileUtility generateCacheFileURL:fileName];
        [[MPChatHttpManager sharedInstance] getDownloadServer:^(NSString * server)
         {
             NSString *urlString = [NSString stringWithFormat:@"http://%@/api/v2/files/download?file_ids=%@", server, self.fileId];
             _downloadTask = [[MPChatHttpManager sharedInstance] downloadFileFromURL:urlString
                                                                        atTargetPath:fileURL
                                                                            progress:^(NSProgress *downloadProgress)
                              {
                                  NSLog(@"downloadFileFromURL InProgress");
                              }
                                                                             success:^(NSURL* filePath, id responseObject)
                              {
                                  NSLog(@"downloadFileFromURL Success");
                                  self.imageURL = filePath;
                                  self.mainImage = [UIImage imageWithContentsOfFile:self.imageURL.path];
                                  _downloadTask = nil;
                                  [self retrieveThreadsAndUpdateView:self.fileId];
                              }
                                                                             failure:^(NSError* error)
                              {
                                  _downloadTask = nil;
                                  [self hideLoadingIndicator];
                                  NSLog(@"downloadFileFromURL failure");
                              }];
         }
                                                      failure:^(NSError *error)
         {
             [self hideLoadingIndicator];
             NSLog(@"getDownloadServer failure");
         }];
    }
}


- (void) createFileChatView
{
    if (!_mpFileChatImageView)
    {
        CGRect frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
        
        _mpFileChatImageView = [[MPFileChatImageView alloc] initWithFrame:frame
                                                                withImage:self.mainImage
                                                                 delegate:self];
        [self.view addSubview:_mpFileChatImageView];
        [self constraintFileImageView:_mpFileChatImageView];
        [self.view bringSubviewToFront:self.addLocationButton];

        if ([self shouldShowOnboarding])
            [self showOnboardingFirstPage];
    }
    else
    {
        self.totalAddedpoints = 0;
        [_mpFileChatImageView clearLocationPoints];
    }
}


-(void)constraintFileImageView:(MPFileChatImageView*)imageView
{
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:NAVBAR_HEIGHT]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
}


- (IBAction)tapOnAddLocation:(id)sender
{
    self.bEnableAddingLocation = YES;
}


- (void) attachImageCompleted
{
    [self hideLoadingIndicator];
    self.view.userInteractionEnabled = YES;
    [self.delegate fileUploadingFinishedWithThreadId:self.parentThreadId];
}


- (void) attachedImageToAsset
{
    if (self.projInfo && self.projInfo.asset_id)
    {
        if (self.projInfo.is_beishu)
        {
            [[MPChatHttpManager sharedInstance] addFileToAsset:self.fileId onAssetId:[self.projInfo.asset_id stringValue] success:^(NSString *desc)
            {
                [self attachImageCompleted];
            } failure:^(NSError *error)
            {
                NSLog(@"addFileToAsset Fail");
                [self attachImageCompleted];
            }];
        }
        else
        {
            [[MPChatHttpManager sharedInstance] addFileToWorkflowStep:self.fileId onAssetId:[self.projInfo.asset_id stringValue] workflowId:self.projInfo.workflow_id workflowStepId:self.projInfo.current_step success:^(NSString *desc)
             {
                 [self attachImageCompleted];

             } failure:^(NSError *error)
             {
                 [self attachImageCompleted];
                 NSLog(@"addFileToWorkflowStep Fail");
             }];
        }
    }
    else{
        [self attachImageCompleted];
    }

}


- (void) uploadImage:(id)sender
{
    self.rightButton.enabled = NO;
    [_addLocationButton setEnabled:NO];
    [self showLoadingIndicator];
    self.view.userInteractionEnabled = NO;

    [[MPChatHttpManager sharedInstance]
     sendMediaMessage:self.loggedInUserId
     toRecipient:self.receiverUserId
     subject:@"New"
     orInExistingThread:self.parentThreadId
     withFile:self.imageURL
     mediaFileType:@"IMAGE"
     success:^(NSString *threadId, NSString* fileId)
     {
         self.fileId = fileId;
         if (!self.parentThreadId)
             self.parentThreadId = threadId;
         
         [self attachedImageToAsset];
         [MPFileUtility removeFile:self.imageURL.path];

         NSLog(@"Media Message success");
     }
     failure:^(NSError *error)
     {
         NSLog(@"Media Message fail");
         self.rightButton.enabled = YES;
         [_addLocationButton setEnabled:YES];
         [self hideLoadingIndicator];
         self.view.userInteractionEnabled = YES;
     }];
}


-(void) showChatViewWithThreadId:(NSString *)threadId
                         atPoint:(CGPoint)pt
{
    MPImageChatRoomViewController *vc = nil;
    
    if (threadId)
        vc = [[MPImageChatRoomViewController alloc] initWithThread:threadId cloudFile:self.fileId serverFileURL:self.serverFileURL point:pt loggedInUserId:self.loggedInUserId projectInfo:nil];
    else if (self.fileId)
        vc = [[MPImageChatRoomViewController alloc] initWithCloudFile:self.fileId serverFileURL:self.serverFileURL point:pt withReceiverId:self.receiverUserId loggedInUserId:self.loggedInUserId projectInfo:nil];
    else
        vc = [[MPImageChatRoomViewController alloc] initWithLocalFile:self.imageURL point:pt withReceiverId:self.receiverUserId parentThreadId:self.parentThreadId loggedInUserId:self.loggedInUserId projectInfo:self.projInfo];
    
    vc.recieverUserName = self.receiverUserName;
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc
                                         animated:YES];
}


-(void) retrieveThreadsAndUpdateView:(NSString *) fileId
{
    [[MPChatHttpManager sharedInstance] retrieveFileConversations:fileId success:^(MPChatEntities * mpChatEntities)
     {
         self.totalAddedpoints = 0;
         
         if (mpChatEntities && [[mpChatEntities entities] count])
         {
             MPChatEntity * mpChatEntity = [[mpChatEntities entities] objectAtIndex:0];
             
             if (mpChatEntity)
             {
                 [self hideLoadingIndicator];
                 self.chatConversations = mpChatEntity.conversations;
                 [self createFileChatView];
                 
                 [self.chatConversations.conversations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     
                     MPChatConversation *chatConversation = obj;
                     CGPoint pt = CGPointZero;
                     pt.x = [chatConversation.x_coordinate doubleValue];
                     pt.y = [chatConversation.y_coordinate doubleValue];
                     [_mpFileChatImageView showLocationAtPoint:pt
                                                     withIndex:idx
                                           unreadMessagesCount:chatConversation.unread_message_count.integerValue
                                                      zoomToPt:NO];
                     ++self.totalAddedpoints;
                     
                 }];
                 
                 if (self.totalAddedpoints >= TOTAL_ALLOWED_POINTS)
                     [_addLocationButton setEnabled:NO];
                 else
                     [_addLocationButton setEnabled:YES];
             }
         }
         else
         {
             [self hideLoadingIndicator];
             [self createFileChatView];
             [_addLocationButton setEnabled:YES];
         }
     } failure:^(NSError *error) {
         
         [self hideLoadingIndicator];
     }];
}


#pragma mark - onboarding methods

-(void) saveOnboardingSettings
{
    NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"MP_HOTSPOT_ONBOARDING_SHOWN"];
    NSDictionary *record = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                                       forKey:currentAppVersion];
    [userDefaults setObject:record forKey:@"MP_HOTSPOT_ONBOARDING_SHOWN"];
    [userDefaults synchronize];
}


-(BOOL) shouldShowOnboarding
{
    BOOL bShow = YES;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *record = [userDefaults objectForKey:@"MP_HOTSPOT_ONBOARDING_SHOWN"];
    
    if (record)
    {
        //get current bundle version
        NSString *currentAppVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
        NSArray *keys = [record allKeys];
        
        if ([keys count])
        {
            NSString *savedAppVersion = [keys objectAtIndex:0];
            BOOL bOnBoardingShown = [[record objectForKey:savedAppVersion] boolValue];
            
            if ([savedAppVersion compare:currentAppVersion] == NSOrderedSame && bOnBoardingShown)
                bShow = NO;
        }
    }

    return bShow;
}

-(void)showOnboardingFirstPage
{
    [self.view bringSubviewToFront:_overLayButton];
    [self.view bringSubviewToFront:_onBoardingView2];
    [self.view bringSubviewToFront:_onBoardingView3];
    
    [UIView animateWithDuration:0.5 animations:^{
        _onBoardingView2.hidden = NO;
        _onBoardingView3.hidden = NO;
        _overLayButton.hidden = NO;
    }];
}


-(void)showOnboardingSecondPage
{
    CGRect frame = [_mpFileChatImageView getImageViewFrame];
    
    [self.view bringSubviewToFront:_onBoardingView1];
    [self.view layoutIfNeeded];
    
    _viewTopConstraint.constant = frame.origin.y + 110;
    _viewLeadingConstraint.constant = frame.origin.x + 32;
    [_onBoardingView1 setNeedsUpdateConstraints];
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.5 animations:^{
        _onBoardingView2.hidden = YES;
        _onBoardingView3.hidden = YES;
        _onBoardingView1.hidden = NO;
    } completion:^(BOOL finished) {
        [_onBoardingView2 removeFromSuperview];
        [_onBoardingView3 removeFromSuperview];
    }];
}


-(void)removeOnboardingSecondPage
{
    [UIView animateWithDuration:0.5 animations:^{
        
        _onBoardingView1.hidden = YES;
        _overLayButton.hidden = YES;
        
    }completion:^(BOOL finished)
     {
         [self removeAllOnboardingViews];
     }];
}


-(void)removeAllOnboardingViews
{
    if (_overLayButton)
    {
        [_overLayButton removeFromSuperview];
        _overLayButton = nil;
    }

    if (_onBoardingView1)
    {
        [_onBoardingView1 removeFromSuperview];
        _onBoardingView1 = nil;
    }
    
    if (_onBoardingView2)
    {
        [_onBoardingView2 removeFromSuperview];
        _onBoardingView2 = nil;
    }
    
    if (_onBoardingView3)
    {
        [_onBoardingView3 removeFromSuperview];
        _onBoardingView3 = nil;
    }
}


- (IBAction)tapOnOverLay:(id)sender
{
    ++_tapCount;
    
    if (_tapCount == 1)
        //show second onboarding
        [self showOnboardingSecondPage];
    else
    {
        //remove custom view also
        [self removeOnboardingSecondPage];
        [self saveOnboardingSettings];
    }
}


#pragma mark - activity indicator

/// show HUD
- (void)showLoadingIndicator
{
    _busyWheelBackgroundView.hidden = NO;
    [self.view bringSubviewToFront:_busyWheelBackgroundView];
    [MBProgressHUD showHUDAddedTo:_busyWheelBackgroundView animated:YES];
}


/// hide HUD
- (void)hideLoadingIndicator
{
    _busyWheelBackgroundView.hidden = YES;
    [MBProgressHUD hideAllHUDsForView:_busyWheelBackgroundView animated:YES];
}



#pragma mark - MPFileChatImageViewDelegate methods

-(void) tapOnImage:(UIImage *)image
        atLocation:(CGPoint)pt
          forIndex:(NSUInteger)index
{
    //open new controller
    NSString *threadId = nil;
    
    if (self.chatConversations && self.chatConversations.conversations.count > index)
    {
        MPChatConversation *conversation = [self.chatConversations.conversations objectAtIndex:index];
        threadId = conversation.thread_id;
    }
    
    [self showChatViewWithThreadId:threadId
                           atPoint:pt];
}


-(BOOL) shouldInsertNewLocation
{
    //although adding location is enable we do not want to add
    // points if both conditions are not meeting
    return (self.bEnableAddingLocation && self.totalAddedpoints < TOTAL_ALLOWED_POINTS);
}


-(void) didFinishwithAddingLocation:(CGPoint)pt
                            onImage:(UIImage *)image
                           forIndex:(NSInteger)index
{
    ++self.totalAddedpoints;
    self.bEnableAddingLocation = NO;
    
    [self showChatViewWithThreadId:nil
                           atPoint:pt];
}


#pragma mark - navigation methods hookup

- (void)tapOnRightButton:(id)sender
{
    [self uploadImage:sender];
}


- (void)tapOnLeftButton:(id)sender
{
    [self.delegate fileUploadingFinishedWithThreadId:self.parentThreadId];
}


#pragma mark -

-(void) didFinishWithFileId:(NSString *)fileId threadId:(NSString*)threadId
{
    self.fileId = fileId;
    self.parentThreadId = threadId;
}

@end