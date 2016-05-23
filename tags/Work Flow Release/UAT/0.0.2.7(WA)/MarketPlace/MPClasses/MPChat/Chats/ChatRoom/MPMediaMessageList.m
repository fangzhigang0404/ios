//
//  FirstViewController.m
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPMediaMessageList.h"
#import "MPChatHttpManager.h"
#import "MPChatMessages.h"
#import "MPChatRoomView.h"
#import "MPChatUtility.h"
#import "MPWebSocketManagerBroadcaster.h"
#import "MPPhotoPickerViewController.h"
#import "MPFileChatViewController.h"
#import "MPPhotoTakerViewController.h"

#define WS(weakSelf)  __weak __block __typeof(&*self)weakSelf = self;   //!< WS(weakSelf) self in block.

#define NAVBAR_HEIGHT 64
#define TABBAR_HEIGHT 49

@interface MPMediaMessageList ()
{
 
}

@end

@implementation MPMediaMessageList


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initializeLayoutConstraintForChatRoomView];
    [self setUpNavigationBar];

    _chatRoomView.isToolBarNeeded = NO;
    _chatRoomView.isChatEnable = NO;
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
    self.rightButton.hidden = YES;
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


- (void) messageGotFromNotification:(NSNotification*)msgNotification
{
    MPChatMessage* message = (MPChatMessage*)msgNotification.object;
    if (![message.thread_id isEqualToString:self.threadId])
        [self getThreadDetailForThreadId:message.thread_id];

    if (message.message_media_type == eIMAGE)
    {
        [super messageGotFromNotification:msgNotification];
    }
}


- (void) retrieveThreadMessagesWithOffset:(NSUInteger)offset limit:(NSUInteger)limit
{
    if (!self.threadId || offset >= self.totalNumMessages)
    {
        [self stopActivityIndicator];
        return;
    }
    
    [[MPChatHttpManager sharedInstance] retrieveMediaMessages:self.threadId forMember:self.loggedInUserId withOffset:offset andLimit:limit success:^(MPChatMessages* inMessages)
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

# pragma - ------MPChatViewCellDelegate------


- (void) onCellChildUIActionForIndex:(NSUInteger) index
{
    [super onCellChildUIActionForIndex:index];
}


#pragma mark - navigation methods hookup


- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
