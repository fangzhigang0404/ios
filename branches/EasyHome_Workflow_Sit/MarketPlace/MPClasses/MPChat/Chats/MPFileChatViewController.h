//
//  MPFileChatViewController.h
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/10/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

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
