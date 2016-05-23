//
//  MPChatRoomView.h
//  tests
//
//  Created by Avinash Mishra on 05/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPToolChatView.h"
#import "MPChatViewCell.h"


@protocol RecordingActiveViewDelegate <NSObject>
/**
 *  @brief retry button clicked.
 *
 *  @return void nil.
 */
- (void) retryButtonClicked;
/**
 *  @brief cancel button clicked.
 *
 *  @return void nil.
 */
- (void) cancelButtonClicked;

@end


@interface RecordingActiveView : UIView

/// delegate The delegate object observe RecordingActiveViewDelegate.
@property (weak, nonatomic) id <RecordingActiveViewDelegate> delegate;
/// audioRecordImage The audioRecordImage is audio record image.
@property (weak, nonatomic) IBOutlet UIImageView*   audioRecordImage;
/// activityIndicatorImageView The activityIndicatorImageView is activityIndicator image view.
@property (weak, nonatomic) IBOutlet UIImageView*   activityIndicatorImageView;
/// recordingLabel The recordingLabel is recording label.
@property (weak, nonatomic) IBOutlet UILabel*       recordingLabel;
/// backgroundView The backgroundView is background view.
@property (weak, nonatomic) IBOutlet UIView*        backgroundView;

/**
 *  @brief initialize view.
 *
 *  @return void nil.
 */
- (void) initializeView;
/**
 *  @brief recording completed.
 *
 *  @return void nil.
 */
- (void) recordingCompleted;
/**
 *  @brief recording fail to send.
 *
 *  @return void nil.
 */
- (void) recordingFailedToSend;

@end


@protocol MPChatRoomViewDelegate <NSObject>
/**
 *  @brief get number of messages.
 *
 *  @param nil.
 *
 *  @return NSUInteger.
 */
- (NSUInteger) numberOfMessages;
/**
 *  @brief get style of cell.
 *
 *  @param tableView The tabview is currently used .
 *  @param index The index is number of the row on tab.
 *
 *  @return MPChatViewCell.
 */
- (MPChatViewCell*) getCellFromTable:(UITableView*)tableView withIndex:(NSUInteger)index;
/**
 *  @brief get total number of messages.
 *
 *  @param nil.
 *
 *  @return NSUInteger.
 */
- (NSUInteger) totalNumberOfmessages;
/**
 *  @brief retrieve next page of thread messages.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) retrieveNextPageOfThreadMessages;
/**
 *  @brief get height for cell.
 *
 *  @param index The index is number of the row on tab.
 *
 *  @return CGFloat.
 */
- (CGFloat) heightForCellForIndex:(NSUInteger)index;

@optional
/**
 *  @brief did select cell .
 *
 *  @param index The index is number of the row on tab.
 *
 *  @return void nil.
 */
- (void) didSelectRowAtIndex:(NSUInteger)index;
/**
 *  @brief open chatroom with active thread.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) openChatRoomWithActiveThread;

@end


@interface MPChatRoomView : UIView

@property (nonatomic) BOOL  isToolBarNeeded;
@property (nonatomic) BOOL  isChatEnable;
@property (nonatomic) BOOL  isToolButtonNeeded;
@property (nonatomic, weak) id <MPChatRoomViewDelegate> delegate;
@property (nonatomic, weak) id<MPToolChatViewDelegate>  toolChatdelegate;
@property (nonatomic, weak) id <MPChatViewCellDelegate> chatViewCellDelegate;
@property (nonatomic, weak) id <RecordingActiveViewDelegate> recordingActiveViewDelegate;
@property (strong, nonatomic)  UIActivityIndicatorView*   activityIndicator_audio;

/**
 *  @brief clear messages and reload table.
 *
 *  @return void nil.
 */
- (void) clearMessagesAndReloadTable;
/**
 *  @brief insert messages in start row of tab.
 *
 *  @param indexPaths The indexPaths is the location of cell on tab.
 *
 *  @return void nil.
 */
- (void) insertMessagesInStartWithIndexPaths:(NSArray*) indexPaths;
/**
 *  @brief append messages at end row of tab.
 *
 *  @param indexPaths The indexPaths is the location of cell on tab.
 *
 *  @return void nil.
 */
- (void) appendMessagesAtEndWithIndexPaths:(NSArray*) indexPaths;
/**
 *  @brief update message cell of tab.
 *
 *  @param indexPaths The indexPaths is the location of cell on tab.
 *
 *  @return void nil.
 */
- (void) updateMessageCellWithIndexPaths:(NSArray*) indexPaths;

/**
 *  @brief recording start.
 *
 *  @return void nil.
 */
- (void) recordingStarted;
/**
 *  @brief recording end.
 *
 *  @return void nil.
 */
- (void) recordingEnded;
/**
 *  @brief cancell show recording view.
 *
 *  @return void nil.
 */
- (void) cancelRecordView;
/**
 *  @brief media message fail to send.
 *
 *  @return void nil.
 */
- (void) mediaMessageSendingFail;
/**
 *  @brief media message succeed to send.
 *
 *  @return void nil.
 */
- (void) mediaMessageSendingSuccess;
/**
 *  @brief hide tool view.
 *
 *  @return void nil.
 */
- (void) hideToolView;
/**
 *  @brief reload table.
 *
 *  @return void nil.
 */
- (void) reloadTable;
/**
 *  @brief show chat closed button.
 *
 *  @param isShow The BOOL isShow is show or not.
 *
 *  @return void nil.
 */
- (void) showChatClosedButton:(BOOL) isShow;
/**
 *  @brief change custom button icon with image.
 *
 *  @param image The image show on custom button.
 *
 *  @return void nil.
 */
- (void) changeCustomButtonIconWithImage:(NSString*)image;

@end

