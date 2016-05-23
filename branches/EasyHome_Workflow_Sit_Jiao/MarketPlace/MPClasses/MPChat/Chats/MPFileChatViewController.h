/**
 * @file    MPFileChatViewController.h
 * @brief   file chat.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-01-16
 *
 */

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"


@class MPChatProjectInfo;

@protocol MPFileChatViewControllerDelegate <NSObject>
/**
 *  @brief file up loading finished .
 *
 *  @param threadId.
 *
 *  @return void nil.
 */
- (void) fileUploadingFinishedWithThreadId:(NSString*) threadId;

@end


@interface MPFileChatViewController : MPBaseViewController

/// delegate The delegate object observe MPFileChatViewControllerDelegate protocol.
@property (nonatomic, weak) id<MPFileChatViewControllerDelegate>  delegate;

/**
 *  @brief init file chat view controller.
 *
 *  @param fileId The fileId is the id of file.
 *  @param serverFileURL The severFileURL is the url of the file.
 *  @param receiverUserId.
 *  @param receiverUserName.
 *  @param loggedInUserId.
 *
 *  @return void nil.
 */
- (instancetype)initWithFileId:(NSString *)fileId
                 serverFileURL:(NSString*) serverFileURL
                withReceiverId:(NSString *)receiverUserId
                withReceiverName:(NSString *)receiverUserName
                loggedInUserId:(NSString*)loggedInUserId
                   projectInfo:(MPChatProjectInfo*) projInfo;
/**
 *  @brief init file chat view controller.
 *
 *  @param imageURL The imageURL is the url of the file.
 *  @param receiverUserId.
 *  @param receiverUserName.
 *  @param loggedInUserId.
 *  @param parentThreadId.
 *
 *  @return void nil.
 */
- (instancetype)initWithImageURL:(NSURL *)imageURL  //currently this should be local
               withReceiverId:(NSString *)receiverUserId
                withReceiverName:(NSString *)receiverUserName
                  loggedInUserId:(NSString*)loggedInUserId
                  parentThreadId:(NSString*)parentThreadId
                     projectInfo:(MPChatProjectInfo*) projInfo;

@end
