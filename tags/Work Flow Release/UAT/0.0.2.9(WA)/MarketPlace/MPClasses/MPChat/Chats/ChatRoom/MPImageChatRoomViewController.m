//
//  FirstViewController.m
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPImageChatRoomViewController.h"
#import "MPChatRoomView.h"
#import "MPChatHttpManager.h"
#import "MPChatMessages.h"
#import "MPFileChatImageView.h"
#import "MPFileUtility.h"
#import "MPChatProjectInfo.h"
#import "MPChatUtility.h"


#define NAVBAR_HEIGHT 64
#define TABBAR_HEIGHT 49

#define MessagePageSize 10


@interface MPImageChatRoomViewController ()
{
    BOOL                        _isKeyBoardVisible;
    __weak IBOutlet UIView*     _imageViewParent;
    IBOutlet UIBarButtonItem*   _sendBarButtonItem;

    UIImage*                    _mpFileImage;
    MPFileChatImageView *       _mpFileChatImageView;
    
    __weak IBOutlet UIActivityIndicatorView*        _activityIndicator;
    __weak IBOutlet UIActivityIndicatorView*        _threadActivityIndicator;
    __weak IBOutlet NSLayoutConstraint*             _imageViewTopConstraint;
    __strong NSURLSessionDownloadTask*              _downloadTask;
}

@property (nonatomic,strong) MPChatProjectInfo *projInfo;

@end


@implementation MPImageChatRoomViewController

- (instancetype) init
{
    self = [super initWithNibName:@"MPImageChatRoomViewController"
                           bundle:nil];
    
    return self;
}

- (instancetype)initWithThread:(NSString *)threadId
                     cloudFile:(NSString *)fileId
                 serverFileURL:(NSString*)serverFileURL
                         point:(CGPoint) pt
                loggedInUserId:(NSString*)loggedInUserId
                   projectInfo:(MPChatProjectInfo*) projInfo
{
    self = [self init];
    if (self)
    {
        self.threadId = threadId;
        self.fileId = fileId;
        self.serverFileURL = serverFileURL;
        self.point = pt;
        self.loggedInUserId = loggedInUserId;
        self.projInfo = projInfo;
    }
    return self;
}


- (instancetype)initWithCloudFile:(NSString *)fileId
                    serverFileURL:(NSString*)serverFileURL
                            point:(CGPoint) pt
                   withReceiverId:(NSString *)receiverUserId
                   loggedInUserId:(NSString*)loggedInUserId
                      projectInfo:(MPChatProjectInfo*) projInfo
{
    self = [self init];
    if (self)
    {
        self.fileId = fileId;
        self.serverFileURL = serverFileURL;
        self.point = pt;
        self.recieverUserId = receiverUserId;
        self.loggedInUserId = loggedInUserId;
        self.projInfo = projInfo;
    }
    return self;
}


- (instancetype)initWithLocalFile:(NSURL *)imageURL  //currently this should be local
                            point:(CGPoint) pt
                   withReceiverId:(NSString *)receiverUserId
                   parentThreadId:(NSString*)parentThreadId
                   loggedInUserId:(NSString*)loggedInUserId
                      projectInfo:(MPChatProjectInfo*) projInfo
{
    self = [self init];
    if (self)
    {
        self.imageURL = imageURL;
        self.point = pt;
        self.recieverUserId = receiverUserId;
        self.parentThreadId = parentThreadId;
        self.loggedInUserId = loggedInUserId;
        self.projInfo = projInfo;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.rightButton.hidden = YES;
    _chatRoomView.isToolBarNeeded = NO;
    
    [self initializeLayoutConstraintForChatRoomView];
    [self registerForKeyboardNotifications];

    self.titleLabel.text = [MPChatUtility getUserDisplayNameFromUser:self.recieverUserName];
    
    assert((self.threadId != nil  && self.loggedInUserId != nil )|| // You are chatting on existing file conversation thread
    (self.fileId != nil  && self.loggedInUserId != nil && self.recieverUserId != nil) || // Just recieved a media message but no thread created yet
    (self.loggedInUserId != nil && self.recieverUserId != nil)); // Just wanted to send a fresh new file with new or existing parent thread
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void) viewWillDisappear:(BOOL)animated
{
    if (_downloadTask)
        [_downloadTask cancel];
    _downloadTask = nil;
    [super viewWillDisappear:animated];
}


- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.fileId)
        [self downloadFile];
    else if (self.imageURL)
        [self loadImage];
}


- (void) initializeLayoutConstraintForChatRoomView
{
    _chatRoomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_imageViewParent attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_chatRoomView attribute:NSLayoutAttributeTop multiplier:1 constant:5]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_chatRoomView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_chatRoomView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_chatRoomView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) startActivityIndicatorOnImage
{
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    [self.view bringSubviewToFront:_activityIndicator];
}


- (void) stopActivityIndicatorOnImage
{
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
}


- (void) startActivityIndicatorForThread
{
    _threadActivityIndicator.hidden = NO;
    self.view.userInteractionEnabled = NO;
    [_threadActivityIndicator startAnimating];
    [self.view bringSubviewToFront:_threadActivityIndicator];
}


- (void) stopActivityIndicatorForThread
{
    _threadActivityIndicator.hidden = YES;
    self.view.userInteractionEnabled = YES;
    [_threadActivityIndicator stopAnimating];
}


- (void) downloadFile
{
    if (self.serverFileURL)
        [self downloadFileWithFileUrl];
    else
        [self downloadFileWithFileId];
}


- (void) downloadFileWithFileId
{
    //check if file is present in cache or not
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.fileId];
    NSString *filePath = [MPFileUtility getFilePath:fileName];
    
    if (filePath)
    {
        self.imageURL = [NSURL URLWithString:filePath];
        [self loadImage];
    }
    else
    {
        [self startActivityIndicatorOnImage];
        NSURL *fileURL = [MPFileUtility generateCacheFileURL:fileName];
        [[MPChatHttpManager sharedInstance] getDownloadServer:^(NSString * server)
        {
             NSString *urlString = [NSString stringWithFormat:@"http://%@/api/v2/files/download?file_ids=%@", server, self.fileId];
            _downloadTask = [[MPChatHttpManager sharedInstance] downloadFileFromURL:urlString
                                                                       atTargetPath:fileURL
                     progress:^(NSProgress *downloadProgress)
                     {
                         NSLog(@"InProgress");
                     }
                     success:^(NSURL* filePath, id responseObject)
                     {
                         NSLog(@"Success");
                         self.imageURL = filePath;
                         [self loadImage];
                         _downloadTask = nil;
                         [self stopActivityIndicatorOnImage];
                     }
                     failure:^(NSError* error)
                     {
                         NSLog(@"failure");
                         _downloadTask = nil;
                         [self stopActivityIndicatorOnImage];
                     }];
        }
        failure:^(NSError *error)
        {
            [self stopActivityIndicatorOnImage];
            NSLog(@"FAILED: MPChatHttpManager downloadFile");
        }];
    }
}

- (void) downloadFileWithFileUrl
{
    //check if file is present in cache or not
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",self.fileId];
    NSString *filePath = [MPFileUtility getFilePath:fileName];
    
    if (filePath)
    {
        self.imageURL = [NSURL URLWithString:filePath];
        [self loadImage];
    }
    else
    {
        [self startActivityIndicatorOnImage];
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
                             self.imageURL = filePath;
                             [self loadImage];
                             _downloadTask = nil;
                             [self stopActivityIndicatorOnImage];
                        }
                        failure:^(NSError* error)
                        {
                             NSLog(@"failure");
                             _downloadTask = nil;
                             [self stopActivityIndicatorOnImage];
                        }];
    }
}


- (void) loadImage
{
    if (!_mpFileChatImageView)
    {
        CGRect frame = CGRectZero;
        frame.size = _imageViewParent.bounds.size;
        
        _mpFileImage = [UIImage imageWithContentsOfFile:self.imageURL.path];
        _mpFileChatImageView = [[MPFileChatImageView alloc] initWithFrame:frame
                                                                withImage:_mpFileImage];
        [_imageViewParent addSubview:_mpFileChatImageView];
        [_mpFileChatImageView showLocationAtPoint:self.point
                                        withIndex:0
                              unreadMessagesCount:0
                                         zoomToPt:YES];
    }
}



#pragma - ------ChathandlerDelegate---------


- (void) addConversationTofile
{
    [[MPChatHttpManager sharedInstance] addConversationToFile:self.fileId
                                                   withThread:self.threadId
                                              withXCoordinate:[NSNumber numberWithInt:(int)self.point.x]
                                              withYCoordinate:[NSNumber numberWithInt:(int)self.point.y]
                                                      success:^(NSString *success)
     {
         [self stopActivityIndicatorForThread];
         NSLog(@"addConversationToFile Success");
     }
                                                      failure:^(NSError *error)
     {
         NSLog(@"addConversationToFile Failure");
         [self stopActivityIndicatorForThread];
     }];
}


- (void) initiateNewThreadSequenceWithMessage:(NSString*)message
{
    [[MPChatHttpManager sharedInstance] sendNewThreadMessage:self.loggedInUserId
                                                 toRecipient:self.recieverUserId
                                                 messageText:message subject:@"New Message"
                                                     success:^(NSString *threadId)
     {
         NSLog(@"Send New Thread success");
         self.threadId = threadId;
         [self markThreadAsRead];
         [self retrieveThreadMessagesWithOffset:0 limit:MessagePageSize];
         [self addConversationTofile];
         [self stopActivityIndicator];
         self.view.userInteractionEnabled = YES;

     }
    failure:^(NSError *error)
    {
        NSLog(@"Send New Thread Failure");
         self.view.userInteractionEnabled = YES;
         [self stopActivityIndicator];
        [self stopActivityIndicatorForThread];
    }];
}


- (void) initiateNewThreadSequence:(BOOL)isNewThread WithMediaMessageURL:(NSURL*)url ofType:(NSString*)type
{
    [[MPChatHttpManager sharedInstance]
     sendMediaMessage:self.loggedInUserId
     toRecipient:self.recieverUserId
     subject:@"New"
     orInExistingThread:self.threadId
     withFile:url
     mediaFileType:type
     success:^(NSString *inThreadId, NSString* fileId)
     {
         NSAssert(inThreadId != nil, @"Thread id can not be nil");
         NSLog(@"Send New Thread success");
         if (isNewThread)
         {
             self.threadId = inThreadId;
             [self markThreadAsRead];
             [self retrieveThreadMessagesWithOffset:0 limit:MessagePageSize];
             [self addConversationTofile];
         }
         self.view.userInteractionEnabled = YES;
         [MPFileUtility removeFile:url.path];
         _uniqueUrl = nil;
         [_chatRoomView mediaMessageSendingSuccess];
         [self stopActivityIndicator];
         NSLog(@"sendMediaMessageWithURL Success");
         
     }
     failure:^(NSError *error)
     {
         [self stopActivityIndicatorForThread];
         [self stopActivityIndicator];
          self.view.userInteractionEnabled = YES;
         [_chatRoomView mediaMessageSendingFail];
         NSLog(@"sendMediaMessageWithURL Failure");
     }];
}


- (void) attachedImageToAsset
{
    if (self.projInfo && self.projInfo.asset_id)
    {
        if (self.projInfo.is_beishu)
        {
                [[MPChatHttpManager sharedInstance] addFileToAsset:self.fileId onAssetId:[self.projInfo.asset_id stringValue] success:^(NSString *desc)
                 {

                 } failure:^(NSError *error)
                 {
                     NSLog(@"addFileToAsset Fail");
                 }];
        }
        else
        {
            [[MPChatHttpManager sharedInstance] addFileToWorkflowStep:self.fileId onAssetId:[self.projInfo.asset_id stringValue] workflowId:self.projInfo.workflow_id workflowStepId:self.projInfo.current_step success:^(NSString *desc)
             {

             } failure:^(NSError *error)
             {
                 NSLog(@"addFileToWorkflowStep Fail");
             }];
        }
    }
}


- (void) sendTextMessage:(NSString*) message
{
    if (self.threadId)
    {
        [[MPChatHttpManager sharedInstance] replyToThread:self.threadId byMember:self.loggedInUserId withText:message success:^(NSString *str)
        {
            NSLog(@"replyToThread success");
            
        } failure:^(NSError *error)
        {
            NSLog(@"replyToThread Failure");
            
        }];
    }
    else if (self.fileId)
    {
        [self startActivityIndicatorForThread];
        [self initiateNewThreadSequenceWithMessage:message];
    }
    else
    {
        [self startActivityIndicatorForThread];
        [[MPChatHttpManager sharedInstance] sendMediaMessage:self.loggedInUserId
                                                 toRecipient:self.recieverUserId
                                                     subject:@"NEW"
                                          orInExistingThread:self.parentThreadId
                                                    withFile:self.imageURL
                                               mediaFileType:@"IMAGE"
                                                     success:^(NSString *threadId, NSString* fileId)
                                                    {
                                                        NSLog(@"sendMediaMessage Success");
                                                        if (!self.parentThreadId)
                                                            self.parentThreadId = threadId;

                                                        self.fileId = fileId;
                                                        [self attachedImageToAsset];
                                                        [self initiateNewThreadSequenceWithMessage:message];
                                                    }
                                                     failure:^(NSError *error)
                                                    {
                                                        [self stopActivityIndicatorForThread];
                                                        NSLog(@"sendMediaMessage Failure");
                                                    }];

    }
}


- (void) sendMediaMessageWithURL:(NSURL*)url ofType:(NSString*)type
{
    self.view.userInteractionEnabled = NO;
    if (self.threadId)
    {
        [self initiateNewThreadSequence:NO WithMediaMessageURL:url ofType:type];
    }
    else if (self.fileId)
    {
        [self startActivityIndicatorForThread];
        [self initiateNewThreadSequence:YES WithMediaMessageURL:url ofType:type];
    }
    else
    {
        [self startActivityIndicatorForThread];
        [[MPChatHttpManager sharedInstance] sendMediaMessage:self.loggedInUserId
                                                 toRecipient:self.recieverUserId
                                                     subject:@"New"
                                          orInExistingThread:self.parentThreadId
                                                    withFile:self.imageURL
                                               mediaFileType:@"IMAGE"
                                                     success:^(NSString *threadId, NSString* fileId)
         {
             NSLog(@"sendMediaMessage Success");
             if (!self.parentThreadId)
                 self.parentThreadId = threadId;

             self.fileId = fileId;
             [self attachedImageToAsset];
             [self initiateNewThreadSequence:YES WithMediaMessageURL:url ofType:type];
         }
                                                     failure:^(NSError *error)
         {
             [self stopActivityIndicatorForThread];
             [self stopActivityIndicator];
             NSLog(@"sendMediaMessage Failure");
         }];
    }
}



#pragma mark --- Keyboard notifications
// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

//NSDictionary* info = [aNotification userInfo];
//CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    _isKeyBoardVisible = YES;
    if (_messages.count > 0)
        _imageViewTopConstraint.constant = NAVBAR_HEIGHT - _imageViewParent.frame.size.height;
    
    [self.view bringSubviewToFront:self.navgationImageview];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    _isKeyBoardVisible = NO;;
    _imageViewTopConstraint.constant = NAVBAR_HEIGHT;
}


- (void) messageGotFromNotification:(NSNotification*)msgNotification
{
    [super messageGotFromNotification:msgNotification];
    if (_isKeyBoardVisible)
    {
        dispatch_async(dispatch_get_main_queue(), ^()
       {
           [self animateHeaderImageView];
       });
    }    
}

- (void) animateHeaderImageView
{
    _imageViewTopConstraint.constant = NAVBAR_HEIGHT - _imageViewParent.frame.size.height;
    [UIView animateWithDuration:1 animations:^
     {
         [self.view layoutIfNeeded];
     }];
}


#pragma mark - navigation methods hookup

- (void)tapOnLeftButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didFinishWithFileId: threadId:)])
        [self.delegate didFinishWithFileId:self.fileId threadId:self.parentThreadId];
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
