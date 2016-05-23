//
//  FirstViewController.h
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseChatRoomViewController.h"


@interface MPChatRoomViewController : MPBaseChatRoomViewController

/// fromQRCode .
@property (nonatomic, assign) BOOL fromQRCode;
/// currentStepId The currentStepId is current step id.
@property (nonatomic, copy) NSString* currentStepId;
/// success The success is a block.
@property (nonatomic, copy) void (^success)();
/**
 *  @brief init chatroom view controller.
 *
 *  @param threadId The threadId is chatroom thread id.
 *  @param receiverUserId.
 *  @param receiverUserName.
 *  @param assetId.
 *  @param loggedInUserId.
 *
 *  @return void nil.
 */
- (instancetype)initWithThread:(NSString *)threadId
                withReceiverId:(NSString *)receiverUserId
                withReceiverName:(NSString *)receiverUserName
                   withAssetId:(NSString*) assetId
                loggedInUserId:(NSString*)loggedInUserId;
/**
 *  @brief init chatroom view controller.
 *
 *  @param receiverUserId.
 *  @param receiverhs_uid.
 *  @param receiverUserName.
 *  @param assetId.
 *  @param loggedInUserId.
 *
 *  @return void nil.
 */
- (instancetype)initWithReceiverId:(NSString *)receiverUserId
                  withHomeStylerId:(NSString*) receiverhs_uid
                  withReceiverName:(NSString *)receiverUserName
                       withAssetId:(NSString*) assetId
                    loggedInUserId:(NSString*)loggedInUserId;
@end

