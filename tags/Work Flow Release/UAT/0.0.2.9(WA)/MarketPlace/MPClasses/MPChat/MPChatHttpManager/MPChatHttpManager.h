/**
 * @file    MPChatHttpManager.h
 * @brief   http request manager.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-03-16
 *
 */

#import <Foundation/Foundation.h>

@class MPChatThreads;
@class MPChatThread;
@class MPChatMessages;
@class MPChatEntities;
/**
 *  @brief the block of HTTPrequest success.
 *
 *  @param requestData the data of returning successfully.
 */
typedef void(^MPHttpRequestSuccess)(NSData *requestData);

/**
 *  @brief the block of HTTPrequest failure.
 *
 *  @param requestData the data of returning unsuccessfully.
 */
typedef void(^MPHttpRequestFailed)(NSData *requestData);

/// the chat manager of HTTP request.
@interface MPChatHttpManager : NSObject

/**
 *  @brief Singleton of MPHttpRequestManager.
 *
 *  @return instancetype MPHttpRequestManager.
 */
+ (instancetype)sharedInstance;
#pragma mark - chatroom
/**
 *  @brief transform NSString type date into NSDate type.
 *
 *  @param acsDate The acsDate is string date.
 *
 *  @return NSDate date.
 */
+ (NSDate*) acsDateToNSDate:(NSString*)acsDate;
/**
 *  @brief transform NSData type date into NString type.
 *
 *  @param acsDate The acsDate is NSDate date.
 *
 *  @return NSString date.
 */
+ (NSString*) nsDateToAcsDate:(NSDate*)acsDate;

- (void) doTest;
/**
 *  @brief retrieve member threads.
 *
 *  @param memberId .
 *  @param fileOnly .
 *  @param offset.
 *  @param limit.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) retrieveMemberThreads:(NSString*)memberId
            onlyAttachedToFile:(BOOL)fileOnly
                    withOffset:(NSInteger)offset
                      andLimit:(NSInteger)limit
                       success:(void(^)(MPChatThreads*))success
                       failure:(void(^)(NSError* error))failure;

/**
 *  @brief retrieve thread messages.
 *
 *  @param memberId.
 *  @param threadId.
 *  @param offset.
 *  @param limit.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) retrieveThreadMessages:(NSString*)threadId
                      forMember:(NSString*)memberId
                     withOffset:(NSInteger)offset
                       andLimit:(NSInteger)limit
                        success:(void(^)(MPChatMessages*))success
                        failure:(void(^)(NSError* error))failure;
/**
 *  @brief retrieve multiple member threads.
 *
 *  @param recipient_ids.
 *  @param offset.
 *  @param limit.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) retrieveMultipleMemberThreads:(NSArray*)recipient_ids
                              withOffset:(NSInteger)offset
                              andLimit:(NSInteger)limit
                               success:(void(^)(MPChatThreads* threads))success
                               failure:(void(^)(NSError *error))failure;
/**
 *  @brief retrieve member unread message count.
 *
 *  @param memberId.
 *  @param needAll.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) retrieveMemberUnreadMessageCount:(NSString*)memberId
                          needAllMessages:(BOOL)needAll //if false will send only file based
                                  success:(void(^)(NSInteger))success
                                  failure:(void(^)(NSError* error))failure;
/**
 *  @brief retrieve file unread message count.
 *
 *  @param memberId.
 *  @param fileId.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void)  retrieveFileUnreadMessageCount:(NSString*)fileId
                               forMember:(NSString*)memberId
                                 success:(void(^)(NSInteger, NSString* fileId))success
                                 failure:(void(^)(NSError* error))failure;
/**
 *  @brief retrieve all hotspot unread message count.
 *
 *  @param memberId.
 *  @param threadId.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) retrieveAllHotspotUnreadmessageCount:(NSString*)memberId
                                  forThreadId:(NSString*)threadId
                                      success:(void(^)(NSInteger))success
                                      failure:(void(^)(NSError* error))failure;
/**
 *  @brief retrieve media messages.
 *
 *  @param memberId.
 *  @param threadId.
 *  @param offset.
 *  @param limit.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void)  retrieveMediaMessages:(NSString*)threadId
                      forMember:(NSString*)memberId
                     withOffset:(NSInteger)offset
                       andLimit:(NSInteger)limit
                        success:(void(^)(MPChatMessages*))success
                        failure:(void(^)(NSError* error))failure;
/**
 *  @brief retrieve thread details.
 *
 *  @param memberId.
 *  @param threadId.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) retrieveThreadDetails:(NSString*)threadId
                     forMember:(NSString*)memberId
                       success:(void(^)(MPChatThread*))success
                       failure:(void(^)(NSError* error))failure;

// new thread will be created
/**
 *  @brief send new thread message.
 *
 *  @param byMemberId.
 *  @param recipient.
 *  @param text.
 *  @param subject.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) sendNewThreadMessage:(NSString*)byMemberId
                  toRecipient:(NSString*)recipient
                  messageText:(NSString*)text
                      subject:(NSString*)subject
                      success:(void (^)(NSString *threadId))success
                      failure:(void (^)(NSError* error))failure;

//pass either recipient or threadid as nil
/**
 *  @brief send media message.
 *
 *  @param byMemberId.
 *  @param recipient.
 *  @param subject.
 *  @param threadId.
 *  @param filePath.
 *  @param type.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) sendMediaMessage:(NSString*)byMemberId
              toRecipient:(NSString*)recipient
                  subject:(NSString*)subject //required for thread = nil
       orInExistingThread:(NSString*)threadId
                 withFile:(NSURL*)filePath
            mediaFileType:(NSString*)type //AUDIO or IMAGE
                  success:(void (^)(NSString *threadId, NSString *fileId))success
                  failure:(void (^)(NSError* error))failure;
/**
 *  @brief reply message to thread.
 *
 *  @param threadId.
 *  @param memberId.
 *  @param msgText.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) replyToThread:(NSString*)threadId
              byMember:(NSString*)memberId
              withText:(NSString*)msgText
               success:(void(^)(NSString*))success
               failure:(void(^)(NSError* error))failure;
/**
 *  @brief mark thread as read.
 *
 *  @param threadId.
 *  @param memberId.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) markThreadAsRead:(NSString*)threadId
                 byMember:(NSString*)memberId
                  success:(void(^)(NSString*))success
                  failure:(void(^)(NSError* error))failure;
/**
 *  @brief mark message as read.
 *
 *  @param msgId.
 *  @param memberId.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) markMessageAsRead:(NSString*)msgId
                  byMember:(NSString*)memberId
                   success:(void(^)(NSString*))success
                   failure:(void(^)(NSError* error))failure;
/**
 *  @brief retrieve file conversations.
 *
 *  @param fileId.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) retrieveFileConversations:(NSString*)fileId
                           success:(void(^)(MPChatEntities*))success
                           failure:(void(^)(NSError* error))failure;
/**
 *  @brief add conversation to file.
 *
 *  @param fileId.
 *  @param threadId.
 *  @param xValue.
 *  @param yValue.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) addConversationToFile:(NSString*)fileId
                    withThread:(NSString*)threadId
               withXCoordinate:(NSNumber*)xValue
               withYCoordinate:(NSNumber*)yValue
                       success:(void(^)(NSString*))success
                       failure:(void(^)(NSError* error))failure;

- (void) addFileToWorkflowStep:(NSString*)fileId
                     onAssetId:(NSString*)assetId
                    workflowId:(NSString*)workflowId
                workflowStepId:(NSString*)workflowStepId
                       success:(void(^)(NSString*))success
                       failure:(void(^)(NSError* error))failure;

- (void) addFileToAsset:(NSString*)fileId
              onAssetId:(NSString*)assetId
                success:(void(^)(NSString*))success
                failure:(void(^)(NSError* error))failure;
/**
 *  @brief get down load server url.
 *
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) getDownloadServer:(void(^)(NSString*))success
                   failure:(void(^)(NSError* error))failure;

/**
 *  @brief download file.
 *
 *  @param fileId.
 *  @param path.
 *  @param downloadProgressBlock.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) downloadFile:(NSString *)fileId
         atTargetPath:(NSURL *)path
             progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
              success:(void (^)(NSURL* file, id responseObject))success
              failure:(void (^)(NSError* error))failure;

/**
 *  @brief download file.
 *
 *  @param urlString.
 *  @param path.
 *  @param downloadProgressBlock.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (NSURLSessionDownloadTask*) downloadFileFromURL:(NSString *)urlString
                                     atTargetPath:(NSURL *)path
                                         progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                          success:(void (^)(NSURL* file, id responseObject))success
                                          failure:(void (^)(NSError* error))failure;
/**
 *  @brief upload file.
 *
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) uploadFile:(NSURL*)filePath
         andSuccess:(void (^)(NSString* fileId))success
         andFailure:(void (^)(NSError* error))failure;
/**
 *  @brief register device for push notifications.
 *
 *  @param deviceToken.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) registerDeviceForPushNotifications:(NSString *)deviceToken
                                    success:(void(^)(BOOL))success
                                    failure:(void(^)(NSError* error))failure;
/**
 *  @brief unregister device for push notifications.
 *
 *  @param deviceToken.
 *  @param success The success is a block of HTTPrequest success.
 *  @param failure The failure is a block of HTTPrequest failure.
 *
 *  @return void nil.
 */
- (void) unRegisterDeviceForPushNotifications:(NSString *)deviceToken
                                      success:(void(^)(BOOL))success
                                      failure:(void(^)(NSError* error))failure;

@end