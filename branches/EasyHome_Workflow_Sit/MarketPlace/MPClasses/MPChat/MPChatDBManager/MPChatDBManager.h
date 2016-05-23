/**
 * @file    MPChatDBManager.h
 * @brief   the chat manager of DataBase.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-22
 *
 */

@class MPChatThread;
@class MPChatMessage;

@interface MPChatDBManager : NSObject
/**
 *  @brief Singleton of MPChatDBManager.
 *
 *  @return instancetype MPChatDBManager.
 */
+ (instancetype)sharedInstance;

// All BELOW APIS ideally should be called from MPChatCacheManager instance
// This approach will separate logic of writing data in DB in background thread ONLY
// Our background queue is serial and only ONE block/task will be executed at any time
// this is how we are protecting data and making thread safe

/**
 *  @brief add new thread.
 *
 *  @param mpThread.
 *  @param userId.
 *
 *  @return void nil.
 */
-(BOOL) addNewThread:(MPChatThread *)mpThread
             forUser:(NSString *)userId;
/**
 *  @brief add new threads.
 *
 *  @param mpThreads.
 *  @param userId.
 *
 *  @return BOOL.
 */
-(BOOL) addNewThreads:(NSArray *)mpThreads
             forUser:(NSString *)userId;

/**
 *  @brief update thread.
 *
 *  @param threadId.
 *  @param userId.
 *  @param messageId.
 *
 *  @return BOOL.
 */
-(BOOL) updateThread:(NSString *)threadId
             forUser:(NSString *)userId
   withLastMessageId:(NSString *)messageId;

// we want to update  thread details also with last message id
// so we require user id also
/**
 *  @brief add new message.
 *
 *  @param mpChatMessage.
 *  @param userId.
 *
 *  @return BOOL.
 */
-(BOOL) addNewMessage:(MPChatMessage *)mpChatMessage
              forUser:(NSString *)userId;
/**
 *  @brief add new messages.
 *
 *  @param mpChatMessages.
 *  @param userId.
 *
 *  @return BOOL.
 */
-(BOOL) addNewMessages:(NSArray *)mpChatMessages
              forUser:(NSString *)userId;

/**
 *  @brief remove thread.
 *
 *  @param mpThread.
 *  @param userId.
 *
 *  @return BOOL.
 */
-(BOOL) removeThread:(MPChatThread *)mpThread
             forUser:(NSString *)userId;
/**
 *  @brief remove threads.
 *
 *  @param mpThreads.
 *  @param userId.
 *
 *  @return BOOL.
 */
-(BOOL) removeThreads:(NSArray *)mpThreads
             forUser:(NSString *)userId;
/**
 *  @brief remove thread.
 *
 *  @param mpThreadId.
 *  @param userId.
 *
 *  @return BOOL.
 */
-(BOOL) removeThreadWithId:(NSString *)mpThreadId
                   forUser:(NSString *)userId;

/**
 *  @brief remove message.
 *
 *  @param messageId.
 *
 *  @return BOOL.
 */
-(BOOL) removeMessageWithId:(NSString*)messageId;
/**
 *  @brief remove message.
 *
 *  @param mpChatMessage.
 *
 *  @return BOOL.
 */
-(BOOL) removeMessage:(MPChatMessage *)mpChatMessage;
/**
 *  @brief remove messages.
 *
 *  @param mpChatMessages.
 *
 *  @return BOOL.
 */
-(BOOL) removeMessages:(NSArray *)mpChatMessages;
/**
 *  @brief get total threads count for user.
 *
 *  @param userId.
 *
 *  @return NSInteger.
 */
-(NSInteger) getTotalThreadsCountForUser:(NSString *)userId;
/**
 *  @brief get total message count for user.
 *
 *  @param threadId.
 *
 *  @return NSInteger.
 */
-(NSInteger) getTotalMessagesCountForThread:(NSString *)threadId;
/**
 *  @brief remove all threads.
 *
 *  @param userId.
 *
 *  @return BOOL.
 */
-(BOOL) removeAllthreads:(NSString *)userId;
/**
 *  @brief remove all messages.
 *
 *  @param threadId.
 *
 *  @return BOOL.
 */
-(BOOL) removeAllMessages:(NSString *)threadId;

/**
 *  @brief get thread details.
 *
 *  @param threadId.
 *  @param userId.
 *
 *  @return MPChatThread.
 */
-(MPChatThread *) getThreadDetails:(NSString *)threadId
                         forUser:(NSString *)userId;

/**
 *  @brief get message details.
 *
 *  @param messageId.
 *
 *  @return MPChatThread.
 */
-(MPChatMessage *) getMessageDetails:(NSString *)messageId;

// This is important API with pagination support
// currently page size is 30
// For implementing Pagination support with DB we need to do some changes on DB
// side as well calling client must give some information required for paging
// following link demonstrates apporach in detail
// http://www.sqlite.org/cvstrac/wiki?p=ScrollingCursor
// we are using same apporach

// if timestamp provided is 0, it will return most recent messages
/**
 *  @brief get previous messages.
 *
 *  @param threadId.
 *  @param timestamp.
 *  @param pageSize.
 *
 *  @return NSArray.
 */
-(NSArray *) getPreviousMessages:(NSString *)threadId
                  fromTimestamp:(double)timestamp
                   withPagesize:(NSInteger) pageSize;
/**
 *  @brief get next messages.
 *
 *  @param threadId.
 *  @param timestamp.
 *  @param pageSize.
 *
 *  @return NSArray.
 */
-(NSArray *) getNextMessages:(NSString *)threadId
                  fromTimestamp:(double)timestamp
                withPagesize:(NSInteger) pageSize;


// if timestamp provided is 0, it will return most recent messages
/**
 *  @brief get previous chat thread.
 *
 *  @param userId.
 *  @param timestamp.
 *  @param pageSize.
 *
 *  @return NSArray.
 */
-(NSArray *) getPreviousChatThreadsForUser:(NSString *)userId
                             fromTimestamp:(double)timestamp
                              withPageSize:(NSInteger)pageSize;
/**
 *  @brief get next chat threads.
 *
 *  @param userId.
 *  @param timestamp.
 *  @param pageSize.
 *
 *  @return NSArray.
 */
-(NSArray *) getNextChatThreadsForUser:(NSString *)userId
                         fromTimestamp:(double)timestamp
                          withPageSize:(NSInteger)pageSize;

@end
