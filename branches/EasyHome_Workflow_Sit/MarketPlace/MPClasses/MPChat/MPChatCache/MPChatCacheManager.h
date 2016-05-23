//
//  MPChatCacheManager.h
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/3/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPChatThread;
@class MPChatMessage;

/**
 *  @brief the block of cache completion.
 *
 *  @param bSuccess the BOOL value of analyzing cache successfully.
 */
typedef void(^CompletionBlock)(BOOL bSuccess);
/**
 *  @brief the block of count result.
 *
 *  @param count the count of cache.
 */
typedef void(^CountResultBlock)(NSInteger count);
/**
 *  @brief the block of result completion.
 *
 *  @param records the array of records.
 */
typedef void(^ResultCompletionBlock)(NSArray *records);
/**
 *  @brief the block of get chat thread result completion.
 *
 *  @param MPChatThread object.
 */
typedef void(^GetChatThreadResultCompletionBlock)(MPChatThread *);
/**
 *  @brief get chat messages result completion.
 *
 *  @param MPChatMessage object.
 */
typedef void(^GetChatMessageResultCompletionBlock)(MPChatMessage *);

// ****All these APIs run in separate threads and dispatching results on main thread

@interface MPChatCacheManager : NSObject
/**
 *  @brief Singleton of MPChatCacheManager.
 *
 *  @return instancetype MPChatCacheManager.
 */
+ (instancetype) sharedInstance;

// this method will update or insert thread in cache
/**
 *  @brief this method will update or insert thread in cache.
 *
 *  @param mpChatThread.
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) updateThread:(MPChatThread *)mpChatThread
             forUser:(NSString *)userId
      withCompletion:(CompletionBlock)block;

//Array of MPChatThread objects
/**
 *  @brief this method will update or insert thread in cache.
 *
 *  @param mpChatThread.
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) updateThreads:(NSArray *)mpChatThreads
              forUser:(NSString *)userId
       withCompletion:(CompletionBlock)block;
/**
 *  @brief this method will update or insert thread in cache.
 *
 *  @param mpChatThread.
 *  @param userId.
 *  @param messageId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) updateThread:(NSString *)threadId
             forUser:(NSString *)userId
       lastMessageId:(NSString *)messageId
                    withCompletion:(CompletionBlock)block;


// this will remove thread along with its messages from cache
/**
 *  @brief this will remove thread along with its messages from cache.
 *
 *  @param mpChatThread.
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) removeThread:(MPChatThread *)mpChatThread
             forUser:(NSString *)userId
      withCompletion:(CompletionBlock)block;
/**
 *  @brief this will remove thread along with its messages from cache.
 *
 *  @param thredId.
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) removeThreadWithId:(NSString *)thredId
                   forUser:(NSString *)userId
            withCompletion:(CompletionBlock)block;

//Array of MPChatThread objects
/**
 *  @brief this will remove thread along with its messages from cache.
 *
 *  @param mpChatThreads.
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) removeThreads:(NSArray *)mpChatThreads
              forUser:(NSString *)userId
       withCompletion:(CompletionBlock)block;

// this method will update or insert message in cache

// we want to update  thread details also with last message id
// so we require user id also
/**
 *  @brief this method will update or insert message in cache.
 *
 *  @param mpChatMessage.
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) updateMessage:(MPChatMessage *)mpChatMessage
              forUser:(NSString *)userId
       withCompletion:(CompletionBlock)block;
/**
 *  @brief this method will update or insert message in cache.
 *
 *  @param mpChatMessages.
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) updateMessages:(NSArray *)mpChatMessages
               forUser:(NSString *)userId
       withCompletion:(CompletionBlock)block;
/**
 *  @brief this will remove thread along with its messages from cache.
 *
 *  @param mpChatMessage.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) removeMessage:(MPChatMessage *)mpChatMessage
       withCompletion:(CompletionBlock)block;
/**
 *  @brief this will remove thread along with its messages from cache.
 *
 *  @param messageId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) removeMessageWithId:(NSString *)messageId
       withCompletion:(CompletionBlock)block;
/**
 *  @brief this will remove thread along with its messages from cache.
 *
 *  @param mpChatMessages.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) removeMessages:(NSArray *)mpChatMessages
       withCompletion:(CompletionBlock)block;

/**
 *  @brief get total threads count for user.
 *
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) getTotalThreadsCountForUser:(NSString *)userId
                           withCompletion:(CountResultBlock)block;
/**
 *  @brief get total messages count for thread.
 *
 *  @param threadId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) getTotalMessagesCountForThread:(NSString *)threadId
                              withCompletion:(CountResultBlock)block;
/**
 *  @brief this will remove thread along with its messages from cache.
 *
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) removeAllThreadsForUser:(NSString *)userId
                 withCompletion:(CompletionBlock)block;
/**
 *  @brief this will remove thread along with its messages from cache.
 *
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) removeAllMessagesForThread:(NSString *)threadId
                    withCompletion:(CompletionBlock)block;
/**
 *  @brief get thread detail.
 *
 *  @param threadId.
 *  @param userId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) getThreadDetails:(NSString *)threadId
                 forUser:(NSString *)userId
          withCompletion:(GetChatThreadResultCompletionBlock)block;
/**
 *  @brief get message detail.
 *
 *  @param messageId.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) getMessageDetails:(NSString *)messageId
           withCompletion:(GetChatMessageResultCompletionBlock)block;

// if timestamp provided is 0, it will return most recent messages
/**
 *  @brief get previous message.
 *
 *  @param threadId.
 *  @param timestamp.
 *  @param pageSize.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) getPreviousMessages:(NSString *) threadId
                  fromTimestamp:(double)timestamp
              withPagesize:(NSInteger) pageSize
            completion:(ResultCompletionBlock)block;
/**
 *  @brief get next messages.
 *
 *  @param threadId.
 *  @param timestamp.
 *  @param pageSize.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) getNextMessages:(NSString *) threadId
                  fromTimestamp:(double)timestamp
           withPagesize:(NSInteger) pageSize
         completion:(ResultCompletionBlock)block;


// TESTED OK

// if timestamp provided is 0, it will return most recent messages
/**
 *  @brief get previous chat thread for user.
 *
 *  @param userId.
 *  @param timestamp.
 *  @param pageSize.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) getPreviousChatThreadsForUser:(NSString *)userId
                             fromTimestamp:(double)timestamp
                              withPageSize:(NSInteger)pageSize
                                completion:(ResultCompletionBlock)block;
/**
 *  @brief get next chat thread for user.
 *
 *  @param userId.
 *  @param timestamp.
 *  @param pageSize.
 *  @param block.
 *
 *  @return void nil.
 */
-(void) getNextChatThreadsForUser:(NSString *)userId
                         fromTimestamp:(double)timestamp
                          withPageSize:(NSInteger)pageSize
                            completion:(ResultCompletionBlock)block;

@end