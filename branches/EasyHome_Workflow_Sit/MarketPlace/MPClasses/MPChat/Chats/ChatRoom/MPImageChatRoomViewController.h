//
//  FirstViewController.h
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseChatRoomViewController.h"

@class MPChatProjectInfo;

@protocol MPImageChatRoomViewControllerDelegate <NSObject>
/**
 *  @brief decide file id and thread id.
 *
 *  @param threadId.
 *  @param fileId.
 *
 *  @return void nil.
 */
-(void) didFinishWithFileId:(NSString *)fileId threadId:(NSString*)threadid;

@end


@interface MPImageChatRoomViewController : MPBaseChatRoomViewController

/// point.
@property (nonatomic) CGPoint point;
/// fileId The fileId is file id.
@property (nonatomic, strong) NSString* fileId;
/// serverFileURL The serverFileURL is file url get from sever.
@property (nonatomic, strong) NSString* serverFileURL;
/// imageURL The imageURL is local image url.
@property (nonatomic, strong) NSURL* imageURL; //local
/// parentThreadId The parentThreadId is parent thread id.
@property (nonatomic, strong) NSString* parentThreadId;
/// delegate The delegate object observe MPImageChatRoomViewControllerDelegate protocol.
@property (nonatomic, weak) id<MPImageChatRoomViewControllerDelegate> delegate;

/**
 *  @brief init chatroom .
 *
 *  @param threadId.
 *  @param fileId.
 *  @param serverFileURL.
 *  @param pt.
 *  @param loggedInUserId.
 *
 *  @return void nil.
 */
- (instancetype)initWithThread:(NSString *)threadId
                     cloudFile:(NSString *)fileId
                serverFileURL:(NSString*)serverFileURL
                         point:(CGPoint) pt
                loggedInUserId:(NSString*)loggedInUserId
                   projectInfo:(MPChatProjectInfo*) projInfo;

/**
 *  @brief init Image chatroom .
 *
 *  @param fileId.
 *  @param serverFileURL.
 *  @param pt.
 *  @param receiverUserId.
 *  @param loggedInUserId.
 *
 *  @return void nil.
 */
- (instancetype)initWithCloudFile:(NSString *)fileId
                   serverFileURL:(NSString*)serverFileURL
                            point:(CGPoint) pt
                withReceiverId:(NSString *)receiverUserId
                loggedInUserId:(NSString*)loggedInUserId
                      projectInfo:(MPChatProjectInfo*) projInfo;

/**
 *  @brief init chatroom .
 *
 *  @param imageURL.
 *  @param pt.
 *  @param receiverUserId.
 *  @param parentThreadId.
 *  @param loggedInUserId.
 *
 *  @return void nil.
 */
- (instancetype)initWithLocalFile:(NSURL *)imageURL  //currently this should be local
                            point:(CGPoint) pt
                  withReceiverId:(NSString *)receiverUserId
                  parentThreadId:(NSString*)parentThreadId
                   loggedInUserId:(NSString*)loggedInUserId
                      projectInfo:(MPChatProjectInfo*) projInfo;

@end

