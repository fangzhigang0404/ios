/**
 * @file    MPBaseChatRoomViewController.h
 * @brief   base chat room.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-01-16
 *
 */


#import <UIKit/UIKit.h>
#import "MPFileChatViewController.h"
#import "MPBaseViewController.h"
#import "MPChatRoomView.h"
#import "MPAudioManager.h"

#define MP_ON_USER_LEFT_CHATROOM @"MPuserLeftChatRoom"

@interface MPBaseChatRoomViewController : MPBaseViewController <MPChatRoomViewDelegate, MPChatViewCellDelegate, MPToolChatViewDelegate, MPAudioManagerDelegate, RecordingActiveViewDelegate, MPFileChatViewControllerDelegate>
{
    NSURL*                      _uniqueUrl;    //!< _uniqueUrl The _uniqueUrl is unique url.
    __weak MPChatRoomView*      _chatRoomView; //!<_chatRoomView The _chatRoomView is chatroom view.
    NSMutableArray*             _messages;     //!<_messages The _messages is messages array.
    NSUInteger                  _offset;       //!<_offset The _offset is offset of page.
}

///totalNumMessages The totalNumMessages is total number of messages.
@property (nonatomic) NSUInteger totalNumMessages;
///threadId The threadId is thread id.
@property (nonatomic, strong) NSString* threadId;
///assetId The assetId is asset id.
@property (nonatomic, strong) NSString* assetId;
///recieverUserId The recieverUserId is reciever user id.
@property (nonatomic, strong) NSString* recieverUserId;
///receiverhs_uid The receiverhs_uid is reciever hs_uid.
@property (nonatomic, strong) NSString* receiverhs_uid;
///recieverUserName The recieverUserName is reciever name.
@property (nonatomic, strong) NSString* recieverUserName;
///loggedInUserId The loggedInUserId is logged in user id.
@property (nonatomic, strong) NSString* loggedInUserId;
///messages The messages is messages array.
@property (nonatomic, readonly) NSArray* messages;

/**
 *  @brief the method as UIActivityIndicator start.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) startActivityIndicator;
/**
 *  @brief the method as UIActivityIndicator stop.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) stopActivityIndicator;

/**
 *  @brief mark thread as read.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) markThreadAsRead;
/**
 *  @brief retrieve next page of thread messages.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) retrieveNextPageOfThreadMessages;
/**
 *  @brief send text message.
 *
 *  @param message The string message is the content to send.
 *
 *  @return void nil.
 */
- (void) sendTextMessage:(NSString*) message;
/**
 *  @brief send media message.
 *
 *  @param url The NSURL url is the path url of the media file.
 *  @param type The NSString type is the type of media file.
 *
 *  @return void nil.
 */
- (void) sendMediaMessageWithURL:(NSURL*)url ofType:(NSString*)type;
/**
 *  @brief clear tab and reload tab with array.
 *
 *  @param inMessages The inMessages array is messages storage array.
 *
 *  @return void nil.
 */
- (void) clearMessagesAndReloadTable:(NSArray*) inMessages;
/**
 *  @brief append messages at end of array.
 *
 *  @param inMessages The inMessages array is messages storage array.
 *
 *  @return void nil.
 */
- (void) appendMessagesAtEnd:(NSArray*) inMessages;
/**
 *  @brief insert inMessages at start of array.
 *
 *  @param inMessages The inMessages array is messages storage array.
 *
 *  @return void nil.
 */
- (void) insertMessagesAtStart:(NSArray*) inMessages;
/**
 *  @brief update message in message storage array.
 *
 *  @param inMessages The inMessages array is messages storage array.
 *
 *  @return void nil.
 */
- (void) updateMessages:(NSArray*)inMessages;
/**
 *  @brief retrieve thread messages.
 *
 *  @param offset The page offset.
 *  @param limit The number of messages to get.
 *
 *  @return void nil.
 */
- (void) retrieveThreadMessagesWithOffset:(NSUInteger)offset limit:(NSUInteger)limit;
/**
 *  @brief message got from notification.
 *
 *  @param msgNotification .
 *
 *  @return void nil.
 */
- (void) messageGotFromNotification:(NSNotification*)msgNotification;

/**
 *  @brief method for get information form measure success Noti.
 *
 *  @param noti the object for Noti .
 *
 *  @return void nil.
 */
- (void)measureSuccess:(NSNotification *)noti;

@end

