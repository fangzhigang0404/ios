//
//  FirstViewController.m
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatRoomViewController.h"
#import "MPChatRoomView.h"
#import "MPChatHttpManager.h"
#import "MPChatMessages.h"
#import "MPWebSocketManagerBroadcaster.h"
#import "MPPhotoPickerViewController.h"
#import "MPFileChatViewController.h"
#import "MPPhotoTakerViewController.h"
#import "MPMediaMessageList.h"
#import "MPProjectMaterialListViewController.h"
#import "MPChatThread.h"
#import "MPChatUtility.h"
#import "MPModel.h"
#import "MPChatUtility.h"
#import "MPStatusMachine.h"
#import "MPChatUser.h"
#import "MPMyProjectInfoViewController.h"
#import "MPMeasureTool.h"

#define WS(weakSelf)  __weak __block __typeof(&*self)weakSelf = self;   //!< WS(weakSelf) self in block.

#define NAVBAR_HEIGHT 64
#define TABBAR_HEIGHT 49

@interface MPChatRoomViewController () <MPPhotoPickerDelegate, MPPhotoTakerDelegate>
{

}

@property (nonatomic, strong) MPChatProjectInfo*    projectInfo;

@end

@implementation MPChatRoomViewController


- (instancetype) init
{
    self = [self initWithNibName:@"MPChatRoomViewController" bundle:nil];
    
    return self;
}


- (instancetype)initWithThread:(NSString *)threadId
                withReceiverId:(NSString *)receiverUserId
              withReceiverName:(NSString *)receiverUserName
                   withAssetId:(NSString*) assetId
                loggedInUserId:(NSString*)loggedInUserId
{
    self = [self init];
    if (self)
    {
        self.threadId = threadId;
        self.assetId = assetId;
        self.loggedInUserId = loggedInUserId;
        self.recieverUserId = receiverUserId;
        self.recieverUserName = receiverUserName;
    }
    return self;
}


- (instancetype)initWithReceiverId:(NSString *)receiverUserId
                  withHomeStylerId:(NSString*) receiverhs_uid
                  withReceiverName:(NSString *)receiverUserName
                       withAssetId:(NSString*) assetId
                loggedInUserId:(NSString*)loggedInUserId
{
    self = [self init];
    if (self)
    {
        self.threadId = nil;
        self.assetId = assetId;
        self.loggedInUserId = loggedInUserId;
        self.recieverUserId = receiverUserId;
        self.receiverhs_uid = receiverhs_uid;
        self.recieverUserName = receiverUserName;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    _chatRoomView.isToolBarNeeded = YES;
    _chatRoomView.isChatEnable = YES;
    [_chatRoomView showChatClosedButton:NO];
    [self isToolButtonHidden];
    [self initializeLayoutConstraintForChatRoomView];

    [self setUpNavigationBar];

    if (self.assetId)
        [self getProjectInfo];

}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCustomButton];
//    if (!self.assetId)
//        [_chatRoomView changeCustomButtonIconWithImage:@"im_measure"];
}

- (void)measureSuccess:(NSNotification *)noti {
    [super measureSuccess:noti];
    [self getProjectInfo];
}

-(void)isToolButtonHidden
{
    if ([MPChatUtility isSystemThread:self.threadId])
        _chatRoomView.isToolButtonNeeded = YES;
    else
        _chatRoomView.isToolButtonNeeded = NO;
}


- (void) initializeLayoutConstraintForChatRoomView
{
    _chatRoomView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_chatRoomView attribute:NSLayoutAttributeTop multiplier:1 constant:-NAVBAR_HEIGHT]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_chatRoomView attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_chatRoomView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_chatRoomView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
}


- (void) setUpNavigationBar
{
    self.navigationController.navigationBar.hidden = YES;
    self.titleLabel.text = [MPChatUtility getUserDisplayNameFromUser:self.recieverUserName];
    [self.rightButton setImage:[UIImage imageNamed:@"fileChat"] forState:UIControlStateNormal];
    
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark -----Private Method--------


- (void) updateCustomButton
{
    NSString *temp_subNode = nil;
    if (!self.assetId) {
        temp_subNode = @"0";
    }

    if (self.projectInfo && !self.projectInfo.is_beishu) {
         temp_subNode = self.projectInfo.current_subNode ? self.projectInfo.current_subNode : @"0";
    }
    
    [MPStatusMachine getCurrentIconWithCurSubNodeId:temp_subNode withSuccess:^(NSString *iconName, NSString *iconTitle)
     {
         [_chatRoomView changeCustomButtonIconWithImage:iconName];
     }];
}

- (void) fileUploadingFinishedWithThreadId:(NSString*) threadId
{
    if (!self.threadId)
        self.threadId = threadId;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) getProjectInfo
{
    NSAssert(self.assetId, @"Need to have assetId before this call");
    NSString* designerId;
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    if ([member MemberIsDesignerMode])
        designerId = member.acs_member_id;
    else
        designerId = self.recieverUserId;
    
    
    [MPAPI getProjectInfoForNeedId:self.assetId forDesigner:designerId header:[MPModel getHeaderAuthorization] success:^(MPChatProjectInfo *info)
    {
        self.projectInfo = info;
        if (self.assetId && !self.projectInfo.is_beishu)
            self.supplementaryButton.hidden = NO;
        [self updateCustomButton];
//        [self setUpNavigationBar];
        NSLog(@"self.currentStepId=%@",self.currentStepId);
        NSLog(@"getProjectInfoForNeedId success");
    }
    failure:^(NSError *error)
    {
        NSLog(@"getProjectInfoForNeedId failure");
    }];
}


#pragma mark - MPPhotoPickerDelegate methods



- (void) getMediaMessageUnreadCount
{
    if (!self.threadId)
    {
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
         /// To update the unread message count on media message
        [self updateUnreadMessageCountForThread:thread];

         /// To update ProjectInfo related UI
         NSString* assetId = [MPChatUtility getAssetIdFromThread:thread];
         if (assetId && [assetId isEqualToString:self.assetId])
         {
             [self getProjectInfo];
         }
     }
     failure:^(NSError *error)
     {
         NSLog(@"Error:::getThreadDetailForThreadId");
     }];
}


- (void) messageGotFromNotification:(NSNotification*)msgNotification
{
    [super messageGotFromNotification:msgNotification];

    MPChatMessage* message = (MPChatMessage*)msgNotification.object;
    if (![message.thread_id isEqualToString:self.threadId])
    {
        [self getMediaMessageUnreadCount];
        [self getThreadDetailForThreadId:message.thread_id];
    }
    else if (self.assetId)
    {
        [self getProjectInfo];
    }
}


#pragma mark - MPPhotoPickerDelegate methods


- (void)userDidSelectPhotoWithURL:(NSURL *)photoURL
{
    [self.navigationController popViewControllerAnimated:NO];
    MPFileChatViewController* ctrl = [[MPFileChatViewController alloc] initWithImageURL:photoURL withReceiverId:self.recieverUserId withReceiverName:self.recieverUserName loggedInUserId:self.loggedInUserId parentThreadId:self.threadId projectInfo:self.projectInfo];
    ctrl.delegate = self;
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)userDeniedPhotoLibraryAccess
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - MPPhotoTakerDelegate methods


- (void)userDidCancelPhotoTaking
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)userDidTakePhotoWithURL:(NSURL *)localURL
{
    [self userDidSelectPhotoWithURL:localURL];
}



# pragma - ------MPChatViewCellDelegate------

- (void) onCellChildUIActionForIndex:(NSUInteger) index
{
    [super onCellChildUIActionForIndex:index];
}


# pragma mark ------ChatRoomViewDelegate--------


- (void) openChatRoomWithActiveThread
{
    if (self.projectInfo.current_step_thread)
    {
        MPChatRoomViewController* chatRoomController = [[MPChatRoomViewController alloc] initWithThread:self.projectInfo.current_step_thread withReceiverId:self.recieverUserId withReceiverName:self.recieverUserName withAssetId:self.assetId loggedInUserId:self.loggedInUserId];
        
        chatRoomController.currentStepId = self.projectInfo.current_step;
        UINavigationController* controller = self.navigationController;
        chatRoomController.hidesBottomBarWhenPushed = YES;
        [controller popViewControllerAnimated:NO];
        [controller pushViewController:chatRoomController animated:NO];
    }
}


# pragma mark ------ToolChatViewDelegate------

- (void) openCameraButtonClicked
{
    MPPhotoTakerViewController *photoTakerController = [[MPPhotoTakerViewController alloc] init];
    photoTakerController.delegate = self;
    [self.navigationController pushViewController:photoTakerController animated:NO];
}


- (void) selectImageButtonClicked
{
    MPPhotoPickerViewController* controller = [[MPPhotoPickerViewController alloc] initWithDefaultAlbumType:MPPhotoAlbumTypeUserLibrary withAssetID:self.assetId];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void) customActionButtonClicked
{
    NSString* designerId;
    MPMember* member = [AppController AppGlobal_GetMemberInfoObj];
    NSString* hs_uid = self.receiverhs_uid;
    
    if ([member MemberIsDesignerMode])
        designerId = member.acs_member_id;
    else
    {
        designerId = self.recieverUserId;

        NSString *hs_uid_name = [MPChatUtility getUserHs_Uid:self.recieverUserName];
        hs_uid = [hs_uid_name isEqualToString:@""]?hs_uid:hs_uid_name;
    }
    
    [MPStatusMachine mpPerformCurrentEventWithController:self withNeedsID:self.assetId withDesignerID:designerId withDesignerhs_uid:hs_uid andCurSubNodeID:self.projectInfo.current_subNode];
}


- (void)userDeniedCameraAccess
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)userDoesNotHaveUsableCamera
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - navigation methods hookup

- (void)tapOnLeftButton:(id)sender
{
    if (self.fromQRCode) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else {
        if ([MPMeasureTool measureStatusSuccessOrNot]) {
            if (self.success) self.success();
        }
        [MPMeasureTool clearMeasureInfo];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)tapOnRightButton:(id)sender
{
    MPMediaMessageList* ctrl = [[MPMediaMessageList alloc] initWithNibName:@"MPMediaMessageList" bundle:nil];
    ctrl.loggedInUserId = self.loggedInUserId;
    ctrl.threadId = self.threadId;
    ctrl.recieverUserId = self.recieverUserId;
    ctrl.recieverUserName = self.recieverUserName;

    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}


- (void)tapOnSupplementaryButton:(id)sender
{
    NSLog(@"supplementary click");
    //MPProjectMaterialListViewController *vc = [[MPProjectMaterialListViewController alloc] initWithAssetId:@"1540261"];
//    MPProjectMaterialListViewController *vc = [[MPProjectMaterialListViewController alloc] initWithAssetId:self.assetId];
//    [self.navigationController pushViewController:vc animated:YES];
    
    NSString* designerId;
    MPMember* member=[AppController AppGlobal_GetMemberInfoObj];
    
    if ([member MemberIsDesignerMode])
        designerId = member.acs_member_id;
    else
    {
        designerId = self.recieverUserId;
    }
    
    MPMyProjectInfoViewController *vc = [[MPMyProjectInfoViewController alloc] init];
    vc.statusModel = [[MPStatusModel alloc] init];
    vc.statusModel.needs_id = self.assetId;
    vc.statusModel.designer_id = designerId;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
