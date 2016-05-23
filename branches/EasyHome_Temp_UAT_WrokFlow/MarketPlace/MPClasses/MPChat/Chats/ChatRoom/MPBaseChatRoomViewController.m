//
//  FirstViewController.m
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPBaseChatRoomViewController.h"
#import "MPChatHttpManager.h"
#import "MPChatMessages.h"
#import "MPChatCommandInfo.h"
#import "MPFileChatImageView.h"
#import "MPPhotoPickerViewController.h"
#import "MPWebSocketManagerBroadcaster.h"
#import "MPFileChatViewController.h"
#import "MPChatTextViewCell.h"
#import "MPChatCommandViewCell.h"
#import "MPChatThread.h"
#import "MPFileUtility.h"
#import "MPDateUtility.h"
#import "MPChatUtility.h"

#import "MPStatusMachine.h"

#define NAVBAR_HEIGHT 64
#define TABBAR_HEIGHT 49


#define MessagePageSize 20

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#define LeftMargin              105
#define RightMargin             15
#define BottomMargin             5
#define TopMargin               37

#define TextLabelLeftMargin             10
#define TextLabelRightMargin            10
#define TextLabelBottomMargin           31
#define TextLabelTopMargin              10

#define CommandTextLabelBottomMargin    75
#define CommandTextLabelTopMargin       15

#define CommandMessageBottomMargin       5
#define CommandMessageTopMargin         35


#define TextMessageFont                 [UIFont systemFontOfSize:18]


#define TextLabelWidth                  (SCREEN_WIDTH - LeftMargin - RightMargin - TextLabelLeftMargin - TextLabelRightMargin)
#define CommandTextLabelWidth           (SCREEN_WIDTH - LeftMargin - RightMargin - 2 * TextLabelLeftMargin - TextLabelRightMargin)


#define AudioCellHeight         60
#define MPAPPLICATIONBECOMEFRONT @"MPApplicationBecomeFront"


@interface MPBaseChatRoomViewController () <UINavigationControllerDelegate>
{
    NSDate*         _audioStartTime;
    NSString*       _currentRecordingURL;
    
    MPChatMessage*                          _currentPlayingMessage;
    NSDictionary<NSString*, NSNumber*>*     _progressStatusForAudioDownload;
    NSDictionary<NSString*, NSNumber*>*     _durationForAudioFile;


    UIActivityIndicatorView*                _activityIndicator;
    BOOL                                    _newThreadCreating;
    
}


@end


@implementation MPBaseChatRoomViewController

@dynamic messages;
@synthesize threadId;
@synthesize recieverUserId;
@synthesize receiverhs_uid;
@synthesize recieverUserName;
@synthesize totalNumMessages;



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray* arr = [[NSBundle mainBundle] loadNibNamed:@"MPChatRoomView" owner:self options:nil];
    _chatRoomView = [arr firstObject];
    [self.view addSubview:_chatRoomView];
    

    self.totalNumMessages = -1;
    _chatRoomView.delegate = self;
    _chatRoomView.toolChatdelegate = self;
    _chatRoomView.chatViewCellDelegate = self;
    _chatRoomView.recordingActiveViewDelegate = self;
    self.titleLabel.text = [MPChatUtility getUserDisplayNameFromUser:self.recieverUserName];
    [self initialiseActivityIndicator];
    [self startActivityIndicator];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.delegate = self;
    self.tabBarController.tabBar.hidden = YES;
    [_chatRoomView hideToolView];
    [self registerHandler];
    [self getMediaMessageUnreadCount];
    [self markThreadAsRead];
    [self retrieveThreadMessagesWithOffset:0 limit:MessagePageSize];
}


- (void) viewWillDisappear:(BOOL)animated
{
    self.navigationController.delegate = nil;
    [[MPAudioManager sharedInstance] stopPlayback];
    [self unRegisterHandler];
}


- (void) initialiseActivityIndicator
{
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:_activityIndicator];
    _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

- (void) startActivityIndicator
{
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    [self.view bringSubviewToFront:_activityIndicator];
}


- (void) stopActivityIndicator
{
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
}


- (NSArray*) messages
{
    return [NSArray arrayWithArray:_messages];
}


- (void) dealloc
{
//    NSLog(@"MPBaseChatRoomViewController Dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - ---------------API Calls-------

- (void) markThreadAsRead
{
    if (!self.threadId)
        return;

    [[MPChatHttpManager sharedInstance] markThreadAsRead:self.threadId
                                                byMember:self.loggedInUserId
                                                 success:^(NSString * success) {
//                                                     NSLog(@"Marked thread as read");
                                                 }
                                                 failure:^(NSError *error) {
//                                                     NSLog(@"Could not mark thread as read");
                                                 }];

}


- (void) retrieveThreadMessagesWithOffset:(NSUInteger)offset limit:(NSUInteger)limit
{
    if (!self.threadId || offset >= self.totalNumMessages)
    {
        [self stopActivityIndicator];
        return;
    }
    [[MPChatHttpManager sharedInstance] retrieveThreadMessages:self.threadId forMember:self.loggedInUserId withOffset:offset andLimit:limit success:^(MPChatMessages* inMessages)
     {
         [self stopActivityIndicator];
         self.totalNumMessages = [inMessages.numMessages integerValue];
         _offset = [inMessages.offset integerValue];
         NSEnumerator<MPChatMessage*> *chats = [inMessages.messages reverseObjectEnumerator];
         NSMutableArray* messages = [NSMutableArray arrayWithArray:[chats allObjects]];
         if (offset > 0)
         {
             [self insertMessagesAtStart:messages];
         }
         else
         {
             [self clearMessagesAndReloadTable:messages];
         }
         
     }failure:^(NSError* err)
     {
         [self stopActivityIndicator];
     }];
}


- (void) sendTextMessage:(NSString*) message
{
    if (self.threadId)
    {
        [[MPChatHttpManager sharedInstance] replyToThread:self.threadId byMember:self.loggedInUserId withText:message success:^(NSString *str) {
            
        } failure:^(NSError *error)
         {
             
         }];
    }
    else
    {
        if (_newThreadCreating) return;
        
        _newThreadCreating = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[MPChatHttpManager sharedInstance] sendNewThreadMessage:self.loggedInUserId toRecipient:self.recieverUserId messageText:message subject:@"New Message" success:^(NSString *inThreadId)
         {
             _newThreadCreating = NO;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [self stopActivityIndicator];
             self.threadId = inThreadId;
             [self markThreadAsRead];
             [self retrieveThreadMessagesWithOffset:0 limit:MessagePageSize];
         }
        failure:^(NSError *error)
         {
             _newThreadCreating = NO;
             [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             self.view.userInteractionEnabled = YES;
         }];
    }
    
}

- (void) sendMediaMessageWithURL:(NSURL*)url ofType:(NSString*)type
{
    self.view.userInteractionEnabled = NO;
    [[MPChatHttpManager sharedInstance]
     sendMediaMessage:self.loggedInUserId
     toRecipient:self.recieverUserId
     subject:@"New"
     orInExistingThread:self.threadId
     withFile:url
     mediaFileType:type
     success:^(NSString *inThreadId, NSString* fileId)
     {
         [self stopActivityIndicator];
         if (!self.threadId)
         {
             self.threadId = inThreadId;
             [self markThreadAsRead];
             [self retrieveThreadMessagesWithOffset:0 limit:MessagePageSize];
         }
         [MPFileUtility removeFile:url.path];
         _uniqueUrl = nil;
         self.view.userInteractionEnabled = YES;
         [_chatRoomView mediaMessageSendingSuccess];
         NSLog(@"sendMediaMessageWithURL Success");
         
     }
     failure:^(NSError *error)
     {
         [self stopActivityIndicator];
         [_chatRoomView mediaMessageSendingFail];
         self.view.userInteractionEnabled = YES;
         NSLog(@"sendMediaMessageWithURL Failure");
     }];
}



- (void) getMediaMessageUnreadCount
{
    if (!self.threadId) {
        return;
    }
    
    [[MPChatHttpManager sharedInstance] retrieveAllHotspotUnreadmessageCount:self.loggedInUserId forThreadId:self.threadId success:^(NSInteger count)
    {
        [self updateBubbleWithUnreadCount:count];
    }
    failure:^(NSError *error)
    {
        [self updateBubbleWithUnreadCount:0];
    }];
}


- (void) updateUnreadMessageCountForThread:(MPChatThread*)thread
{
    NSString* fileId = [MPChatUtility getFileEntityIdForThread:thread];
    if (fileId)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"media_file_id = %d", [fileId integerValue]];
        NSArray* filteredArray = [_messages filteredArrayUsingPredicate:predicate];
        if (filteredArray.count > 0)
            [self updateMessages:filteredArray];
    }
}


- (void) getThreadDetailForThreadId:(NSString*) inThreadId
{
    [[MPChatHttpManager sharedInstance] retrieveThreadDetails:inThreadId forMember:self.loggedInUserId success:^(MPChatThread *thread)
    {
        [self updateUnreadMessageCountForThread:thread];
    }
    failure:^(NSError *error)
    {
        NSLog(@"Error:::getThreadDetailForThreadId");
    }];
}


#pragma mark - TableEditing messages

- (void) clearMessagesAndReloadTable:(NSArray*)inMessages
{
    _messages = [NSMutableArray arrayWithArray:inMessages];
    [_chatRoomView clearMessagesAndReloadTable];
}


- (void) insertMessagesAtStart:(NSArray*)inMessages
{
//    NSLog(@"Start addMessages Start");
    
    if (_messages.count <= 0)
    {
        [self clearMessagesAndReloadTable:inMessages];
        return;
    }
    
    NSMutableArray* indexPathsArray = [NSMutableArray array];
    for (int i = 0; i < inMessages.count; ++i)
    {
        [indexPathsArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [_messages insertObjects:inMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, inMessages.count)]];
    
    [_chatRoomView insertMessagesInStartWithIndexPaths:indexPathsArray];
//    NSLog(@"End addMessages End");
}


- (void) appendMessagesAtEnd:(NSArray*)inMessages
{
//    NSLog(@"Start insertMessages Start");
    
    if (_messages.count <= 0)
    {
        [self clearMessagesAndReloadTable:inMessages];
        return;
    }
    
    NSUInteger count = _messages.count;
    NSMutableArray* indexPathsArray = [NSMutableArray array];
    for (int i = 0; i < inMessages.count; ++i)
    {
        [indexPathsArray addObject:[NSIndexPath indexPathForRow:(count + i) inSection:0]];
    }
    
    [_messages insertObjects:inMessages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_messages.count, inMessages.count)]];
    
    [_chatRoomView appendMessagesAtEndWithIndexPaths:indexPathsArray];
    
//    NSLog(@"End insertMessages End");
}


- (void) updateMessages:(NSArray*)inMessages
{
    NSLog(@"update Messages Start");
    
    if (_messages.count <= 0 || inMessages.count <= 0)
    {
        return;
    }
    
    NSMutableArray* indexPathsArray = [NSMutableArray array];
    for (int i = 0; i < inMessages.count; ++i)
    {
        [indexPathsArray addObject:[NSIndexPath indexPathForRow:[_messages indexOfObject:[inMessages objectAtIndex:i]] inSection:0]];
    }
    
    [_chatRoomView updateMessageCellWithIndexPaths:indexPathsArray];
    
}


#pragma - ------NavigationControllerDelegate---------


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPop)
    {
        if (fromVC == self)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:MP_ON_USER_LEFT_CHATROOM object:nil];
        }
    }
    return nil;
}


#pragma mark - navigation methods hookup


-(void)tapOnLeftButton:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMeasureSuccess object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}


# pragma mark - ------Register Functions------


- (void) registerHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketConnectionNotification:) name:MPCHATDISCONNECTNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(socketConnectionNotification:) name:MPCHATCONNECTNOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageGotFromNotification:) name:MPCHATNEWMESSAGENOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryMessage) name:MPAPPLICATIONBECOMEFRONT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(measureSuccess:) name:MPMeasureSuccess object:nil];
}

- (void) unRegisterHandler
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPCHATDISCONNECTNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPCHATCONNECTNOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPCHATNEWMESSAGENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPAPPLICATIONBECOMEFRONT object:nil];
}

- (void)measureSuccess:(NSNotification *)noti {
    if ([self.threadId description].length == 0) {
        self.threadId = noti.object[@"thread_id"];
    }
    
    if ([self.assetId description].length == 0) {
        self.assetId = noti.object[@"needs_id"];
    }
}

- (void) socketConnectionNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:MPCHATCONNECTNOTIFICATION])
    {
        NSLog(@"Socket Connected : Reloading chat room");
        [self retrieveThreadMessagesWithOffset:0 limit:MessagePageSize];
    }
}



-(void)retryMessage
{
    if (self) {
         [self retrieveThreadMessagesWithOffset:0 limit:MessagePageSize];
    }
}

- (void) messageGotFromNotification:(NSNotification*)msgNotification
{
    MPChatMessage* message = (MPChatMessage*)msgNotification.object;
    if ([message.thread_id isEqualToString:self.threadId])
    {
        [self markThreadAsRead];
        if (_messages.count > 0)
            [self appendMessagesAtEnd:[NSArray arrayWithObject:message]];
        else
            [self clearMessagesAndReloadTable:[NSArray arrayWithObject:message]];
    }
}




- (void) markMessageAsRead:(NSString*)msgId
{
    [[MPChatHttpManager sharedInstance] markMessageAsRead:msgId
                                                 byMember:self.loggedInUserId
                                                  success:^(NSString * success) {
//                                                        NSLog(@"Message marked as read successfully");
                                                    }
                                                  failure:^(NSError *error) {
//                                                        NSLog(@"Could not mark message marked as read");
                                                    }];
}


# pragma mark - ------MPAudioManager Delegate------


- (void) audioDidStartRecording:(BOOL)successfully
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if (successfully)
        {
            [_chatRoomView recordingStarted];
            _audioStartTime = [NSDate date];
        }
        else
        {
            [_chatRoomView cancelRecordView];
            _audioStartTime = nil;
        }
    });
}


- (void) audioDidEndRecording:(BOOL)successfully
{
    [[MPAudioManager sharedInstance] setDelegate:nil];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSLog(@"%@", _uniqueUrl.path);
        if (successfully)
        {
            if ([[NSDate date] timeIntervalSinceDate:_audioStartTime] > 1)
            {
                [self startActivityIndicator];
                [_chatRoomView recordingEnded];
                [[MPAudioManager sharedInstance] setDelegate:nil];
                [self sendMediaMessageWithURL:_uniqueUrl ofType:@"AUDIO"];
            }
            else
            {
                [_chatRoomView cancelRecordView];
                NSLog(@"::::::::Audio Message too short to send::::::::");
            }
        }
        else
        {
            [_chatRoomView cancelRecordView];
        }
        _audioStartTime = nil;
    });
}


- (void) audioDidStartPlaying:(BOOL)successfully
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
        if (successfully)
            [self updateMessageWithMessage:_currentPlayingMessage];
    });
}


- (void) audioDidEndPlaying:(BOOL)successfully
{
   dispatch_async(dispatch_get_main_queue(), ^
   {
       [[MPAudioManager sharedInstance] setDelegate:nil];
       [self updateMessageWithMessage:_currentPlayingMessage];
       
       _uniqueUrl = nil;
       _currentPlayingMessage = nil;
   });
}


- (void) userDeniedMicrophoneAccess
{
    [[MPAudioManager sharedInstance] setDelegate:nil];
    dispatch_async(dispatch_get_main_queue(), ^
    {
        NSLog(@"userDeniedMicrophoneAccess :: %@.", _uniqueUrl.path);
        [_chatRoomView cancelRecordView];
    });
}


- (void)durationObtainedForFile:(NSURL *)fileURL withDuration:(float)duration
{
    
}


# pragma mark - ------ToolChatViewDelegate------


- (void) textViewDidSendText:(NSString*) message
{
    [self sendTextMessage:message];
}


- (void) startRecording
{
    NSString* uniqueFilename = [MPFileUtility getUniqueFileNameWithExtension:@"m4a"];
    _uniqueUrl = [MPFileUtility generateCacheFileURL:uniqueFilename];
    NSLog(@"%@", _uniqueUrl.path);
    [[MPAudioManager sharedInstance] setDelegate:self];
    [[MPAudioManager sharedInstance] startRecordingWithMaxDuration:60 atLocalURL:_uniqueUrl];
}


- (void) stopRecording
{
    NSLog(@"%@", _uniqueUrl.path);
    [[MPAudioManager sharedInstance] stopRecording];
}


- (void) cancelRecording
{
    NSLog(@"%@", _uniqueUrl.path);
    [[MPAudioManager sharedInstance] cancelRecording];
}


- (void) toolViewPlusButtonClicked
{
    
}


# pragma mark - ------MPChatViewCellDelegate------

- (NSInteger) getMessageDurationForIndex:(NSUInteger) index
{
    MPChatMessage* message = [_messages objectAtIndex:index];
    NSNumber* duration = [_durationForAudioFile valueForKey:[message.media_file_id stringValue]];
    if (duration)
    {
        return [duration integerValue];
    }
    else
    {
        NSString* fileId = [message.media_file_id stringValue];
        NSString *fileName = [[NSString stringWithFormat:@"%@", fileId] stringByAppendingPathExtension:@"m4a"];
        NSString *filePath = [MPFileUtility getFilePath:fileName];
        if (filePath)
        {
            [[MPAudioManager sharedInstance] queryDurationOfAudioFile:[NSURL fileURLWithPath:[self localAudioPathForMessage:message]]
                                          withCompletionBlock:^(NSURL *fileURL, float audioDurationInSeconds)
                                        {
                                            [self setDurationForFile:[message.media_file_id stringValue] duration:audioDurationInSeconds];
                                            [self updateMessageWithMessage:message];
                                        }];
        }
        return 0;
    }
}


- (void) fileUploadingFinishedWithThreadId:(NSString*) threadId
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) onCellChildUIActionForIndex:(NSUInteger) index
{
    MPChatMessage* message = [_messages objectAtIndex:index];
    if (message.message_media_type == eCOMMAND)
    {
        MPChatCommandInfo* commandInfo = [MPChatMessage getCommandInfoFromMessage:message];
        [MPStatusMachine mpPerformCurrentEventWithController:self withNeedsID:commandInfo.need_id withDesignerID:commandInfo.designer_id withDesignerhs_uid:nil andCurSubNodeID:commandInfo.sub_node_id];
    }
    else if (message.message_media_type == eAUDIO)
    {
        NSString* fileId = [message.media_file_id stringValue];
        NSString *fileName = [[NSString stringWithFormat:@"%@", fileId] stringByAppendingPathExtension:@"m4a"];
        NSString *filePath = [MPFileUtility getFilePath:fileName];
        if (filePath)
        {
            [self setDownloadStatusForFile:fileId progress:100];
            [self playFileWithURL:[NSURL fileURLWithPath:filePath] ofMessage:message];
            [self updateMessageWithMessage:message];
        }
        else
        {
            NSString* serverURL = [NSString stringWithFormat:@"%@M4A.m4a", message.body];
            NSURL *fileURL = [MPFileUtility generateCacheFileURL:fileName];

            [self setDownloadStatusForFile:fileId progress:50];
            [self updateMessageWithMessage:message];
            [[MPChatHttpManager sharedInstance] downloadFileFromURL:serverURL
                                                       atTargetPath:fileURL
                                                           progress:^(NSProgress *downloadProgress)
             {
                 [self setDownloadStatusForFile:fileId progress:50];
                 NSLog(@"downloadFileFromURL InProgress");
             }
                                                            success:^(NSURL* filePath, id responseObject)
             {
                 [self setDownloadStatusForFile:fileId progress:100];
                 [self playFileWithURL:fileURL ofMessage:message];
                 [self updateMessageWithMessage:message];
             }
                                                            failure:^(NSError* error)
             {
                 NSLog(@"downloadFileFromURL failure");
                 [MPFileUtility removeFile:filePath];
                 [self setDownloadStatusForFile:fileId progress:0];
                 [self updateMessageWithMessage:message];
             }];
        }
    }
    else if (message.message_media_type == eIMAGE)
    {
        MPFileChatViewController* ctrl = [[MPFileChatViewController alloc] initWithFileId:[message.media_file_id stringValue] serverFileURL:message.body withReceiverId:self.recieverUserId withReceiverName:self.recieverUserName loggedInUserId:self.loggedInUserId projectInfo:nil];
        ctrl.delegate = self;
        [self.navigationController pushViewController:ctrl animated:YES];
    }

}


- (BOOL) isPlayingForIndex:(NSUInteger) index
{
    MPChatMessage* curMessage =  [self.messages objectAtIndex:index];
    NSString* path = [self localAudioPathForMessage:curMessage];
    if (path)
        return [[MPAudioManager sharedInstance] isCurrentlyPlayingFile:[NSURL fileURLWithPath:path]];
    
    return NO;
}


- (NSInteger) getProgressForIndex:(NSUInteger) index;
{
    MPChatMessage* message = [_messages objectAtIndex:index];
    if ([self localAudioPathForMessage:message])
        return 100;

    return [[_progressStatusForAudioDownload valueForKey:[message.media_file_id stringValue]] integerValue];
}


- (MPChatMessage*) getCellModelForIndex:(NSUInteger) index
{
    if (self.messages.count > index)
        return [self.messages objectAtIndex:index];
    
    return nil;
}


- (BOOL) isCellIsNotForCurrentLoggedInUser:(NSUInteger)index
{
    MPChatMessage* curMessage =  [self.messages objectAtIndex:index];
    return (![self.loggedInUserId isEqualToString:[curMessage.sender_member_id stringValue]]);
}


- (BOOL) isDateChageForIndex:(NSUInteger) index
{
    if (index > 0)
    {
        MPChatMessage* prevMessage = [self.messages objectAtIndex:index - 1];
        MPChatMessage* curMessage =  [self.messages objectAtIndex:index];
        return [MPDateUtility checkIfDateChangeIn:[MPChatHttpManager acsDateToNSDate:prevMessage.sent_time]
                                           toDate:[MPChatHttpManager acsDateToNSDate:curMessage.sent_time]];
    }
    
    return YES;
}


- (NSString*) getLoggedInMemberId
{
    return self.loggedInUserId;
}


- (BOOL) isLoggedInUserIsDesigner
{
    return [[MPMember shareMember] MemberIsDesignerMode];
}

# pragma mark - ------ChatRoomViewDelegate------


- (void) didSelectRowAtIndex:(NSUInteger)index
{
    
}


- (NSUInteger) numberOfMessages
{
    return self.messages.count;
}


/// do something you want in this method.
- (CGFloat) heightForCellForIndex:(NSUInteger)index
{
    MPChatMessage* message = [self.messages objectAtIndex:index];

    CGFloat height;
    switch (message.message_media_type)
    {
        case eCOMMAND:
        {
            CGSize size = CGSizeZero;
            MPChatCommandInfo* commandInfo = [MPChatMessage getCommandInfoFromMessage:message];
            if ([self isLoggedInUserIsDesigner])
                size = [self preferredMaxLayoutSizeForText:commandInfo.for_designer forWidth:CommandTextLabelWidth];
            else
                size = [self preferredMaxLayoutSizeForText:commandInfo.for_consumer forWidth:CommandTextLabelWidth];
            
            height = size.height + CommandMessageBottomMargin + CommandMessageTopMargin + CommandTextLabelBottomMargin + CommandTextLabelTopMargin;
            break;
        }
            
        case eIMAGE:
            height = (((SCREEN_WIDTH * 0.750  * 3) / 4) + BottomMargin + TopMargin - 10);
            break;

        case eAUDIO:
            height = (AudioCellHeight + BottomMargin + TopMargin);
            break;
            
        default:
        {
            CGSize size = [self preferredMaxLayoutSizeForText:message.body forWidth:TextLabelWidth];
            height = size.height + BottomMargin + TopMargin + TextLabelBottomMargin + TextLabelTopMargin;
            break;
        }
    }
    
    return height + 5;
}


- (MPChatViewCell*) getCellFromTable:(UITableView*)tableView withIndex:(NSUInteger)index
{
    NSString* cellIdentifier = nil;
    MPChatMessage* message = [self.messages objectAtIndex:index];
    MPChatViewCell* cell = nil;
    
    
    
    NSString* cellType = [self isCellIsNotForCurrentLoggedInUser:index] ? @"left" : @"right";
    switch (message.message_media_type)
    {

        case eCOMMAND:
            cellIdentifier = [NSString stringWithFormat:@"MPChatCommandViewCell"];
            cell = (MPChatCommandViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            break;
            


        case eIMAGE:
            cellIdentifier = [NSString stringWithFormat:@"MPChatMediaViewCell_%@", cellType];
            cell = (MPChatTextViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            break;
            
        case eAUDIO:
            cellIdentifier = [NSString stringWithFormat:@"MPChatAudioViewCell_%@", cellType];
            cell = (MPChatTextViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            break;
            
        default:
            cellIdentifier = [NSString stringWithFormat:@"MPChatTextViewCell_%@", cellType];
            cell = (MPChatTextViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            break;
    }
    
    
    return cell;
}


- (NSUInteger) totalNumberOfmessages
{
    return self.totalNumMessages;
}


- (void) retrieveNextPageOfThreadMessages
{
    [self retrieveThreadMessagesWithOffset:_messages.count limit:MessagePageSize];
}


#pragma mark ------Private Methods--


- (CGSize)preferredMaxLayoutSizeForText:(NSString *)text forWidth:(CGFloat)width
{
    CGFloat preferredMaxLayoutWidth = width - 10;
    
    NSMutableParagraphStyle *mutableParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    mutableParagraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName: TextMessageFont,
                                 NSParagraphStyleAttributeName: [mutableParagraphStyle copy]};
    CGRect boundingRect = [text boundingRectWithSize:CGSizeMake(preferredMaxLayoutWidth, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];

    return boundingRect.size;
}


//- (CGSize)preferredMaxLayoutSizeForText:(NSString *)text forWidth:(CGFloat)width
//{
//    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 21)];
//    label.font = [UIFont systemFontOfSize:18];
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    
//    label.text = text;
//    [label sizeToFit];
//
//    return label.bounds.size;
//}
//
//

- (void) updateMessageWithMessage:(MPChatMessage*) message
{
    dispatch_async(dispatch_get_main_queue(), ^
    {
       if (message)
           [self updateMessages:[NSArray arrayWithObject:message]];
    });
}



- (void) playFileWithURL:(NSURL*)url ofMessage:(MPChatMessage*)message
{
    BOOL isSameFilePlaying = [[MPAudioManager sharedInstance] isCurrentlyPlayingFile:url];
    if (_currentPlayingMessage)
    {
        [[MPAudioManager sharedInstance] stopPlayback];
        [self updateMessageWithMessage:_currentPlayingMessage];
    }
    
    [[MPAudioManager sharedInstance] setDelegate:self];
    if (!isSameFilePlaying)
    {
        _currentPlayingMessage = message;
        [[MPAudioManager sharedInstance] startPlayingFileWithLocalURL:url];
        [self updateMessageWithMessage:_currentPlayingMessage];
    }
    else
    {
        [[MPAudioManager sharedInstance] stopPlayback];
    }
}


- (void) setDownloadStatusForFile:(NSString*)fileId progress:(NSInteger) progress
{
    if (!_progressStatusForAudioDownload)
        _progressStatusForAudioDownload = [NSMutableDictionary dictionary];
    [_progressStatusForAudioDownload setValue:[NSNumber numberWithUnsignedLong:progress] forKey:fileId];
}


- (void) setDurationForFile:(NSString*)fileId duration:(NSInteger)duration
{
    if (!_durationForAudioFile)
        _durationForAudioFile = [NSMutableDictionary dictionary];
    [_durationForAudioFile setValue:[NSNumber numberWithUnsignedLong:duration] forKey:fileId];
}



- (NSString*) localAudioPathForMessage:(MPChatMessage*) message
{
    NSString* fileId = [message.media_file_id stringValue];
    NSString *fileName = [[NSString stringWithFormat:@"%@", fileId] stringByAppendingPathExtension:@"m4a"];
    NSString *filePath = [MPFileUtility getFilePath:fileName];
    
    return filePath;
}


- (void) retryButtonClicked
{
    [_chatRoomView recordingEnded];
    [self sendMediaMessageWithURL:_uniqueUrl ofType:@"AUDIO"];
}


- (void) cancelButtonClicked
{
    [_chatRoomView cancelRecordView];
}


@end
