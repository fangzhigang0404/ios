//
//  MPChatCacheManager.m
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/3/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPChatCacheManager.h"
#import "MPChatDBManager.h"

@interface MPChatCacheManager()
{
    dispatch_queue_t _backgroundQueue;
}
@end

@implementation MPChatCacheManager

#pragma mark - SharedInstance

+ (instancetype)sharedInstance {
    
    static MPChatCacheManager *cacheManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        cacheManager = [[super allocWithZone:NULL]init];
        [cacheManager setupBackgroundQueueForDBUpdates];
    });
    
    return cacheManager;
}

///override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [MPChatCacheManager sharedInstance];
}

///override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return [MPChatCacheManager sharedInstance];
}


-(void) setupBackgroundQueueForDBUpdates
{
    _backgroundQueue = dispatch_queue_create("com.autodesk.chatdbmanager.bgqueue", NULL);
}


// this method will update or insert thread in cache
// tested OK

-(void) updateThread:(MPChatThread *)mpChatThread
             forUser:(NSString *)userId
      withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] addNewThread:mpChatThread
                                                               forUser:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           block(bSuccess);
                       });
    });
}


// tested OK
-(void) updateThreads:(NSArray *)mpChatThreads
              forUser:(NSString *)userId
       withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        __block BOOL bSuccess = [[MPChatDBManager sharedInstance] addNewThreads:mpChatThreads
                                                                        forUser:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });

    });
}


//tested ok
-(void) updateThread:(NSString *)threadId
             forUser:(NSString *)userId
       lastMessageId:(NSString *)messageId
      withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] updateThread:threadId
                                                               forUser:userId
                                                     withLastMessageId:messageId];
                dispatch_async(dispatch_get_main_queue(), ^
                       {
                           block(bSuccess);
                       });
    });

}


// tested OK
// this will remove thread along with its messages from cache
-(void) removeThread:(MPChatThread *)mpChatThread
             forUser:(NSString *)userId
      withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] removeThread:mpChatThread
                                                               forUser:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
    });
}


//tested ok
-(void) removeThreadWithId:(NSString *)thredId
             forUser:(NSString *)userId
      withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] removeThreadWithId:thredId
                                                                     forUser:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
    });
}




// tested OK
-(void) removeThreads:(NSArray *)mpChatThreads
              forUser:(NSString *)userId
       withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        __block BOOL bSuccess = NO;
        bSuccess = [[MPChatDBManager sharedInstance] removeThreads:mpChatThreads
                                                               forUser:userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
    });
}


//tested ok
// this method will update or insert message in cache
-(void) updateMessage:(MPChatMessage *)mpChatMessage
              forUser:(NSString *)userId
       withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] addNewMessage:mpChatMessage
                                                                forUser:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
    });
}


//tested ok
-(void) updateMessages:(NSArray *)mpChatMessages
               forUser:(NSString *)userId
        withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        __block BOOL bSuccess = NO;
        
        bSuccess = [[MPChatDBManager sharedInstance] addNewMessages:mpChatMessages
                                                            forUser:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
        
    });

}


//tested ok
-(void) removeMessages:(NSArray *)mpChatMessages
        withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        __block BOOL bSuccess = NO;
        bSuccess = [[MPChatDBManager sharedInstance] removeMessages:mpChatMessages];

        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
        
    });
    
}


//tested ok
-(void) removeMessage:(MPChatMessage *)mpChatMessage
       withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] removeMessage:mpChatMessage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
    });
    
}


-(void) removeMessageWithId:(NSString *)messageId
             withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] removeMessageWithId:messageId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
    });
}


//tested ok
-(void) getTotalThreadsCountForUser:(NSString *)userId
                     withCompletion:(CountResultBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        NSInteger count  = [[MPChatDBManager sharedInstance] getTotalThreadsCountForUser:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(count);
        });
    });
}


//tested ok
-(void) getTotalMessagesCountForThread:(NSString *)threadId
                        withCompletion:(CountResultBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        NSInteger count  = [[MPChatDBManager sharedInstance] getTotalMessagesCountForThread:threadId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(count);
        });
    });
}


//Tested OK
-(void) removeAllThreadsForUser:(NSString *)userId
                 withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] removeAllthreads:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
    });
}


-(void) removeAllMessagesForThread:(NSString *)threadId
                    withCompletion:(CompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        BOOL bSuccess = [[MPChatDBManager sharedInstance] removeAllMessages:threadId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(bSuccess);
        });
    });
}


-(void) getThreadDetails:(NSString *)threadId
                 forUser:(NSString *)userId
          withCompletion:(GetChatThreadResultCompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        MPChatThread *mpChatThread = [[MPChatDBManager sharedInstance] getThreadDetails:threadId
                                                                   forUser:userId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(mpChatThread);
        });
    });
}


-(void) getMessageDetails:(NSString *)messageId
           withCompletion:(GetChatMessageResultCompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        MPChatMessage *mpChatMessage = [[MPChatDBManager sharedInstance] getMessageDetails:messageId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(mpChatMessage);
        });
    });
}


-(void) getPreviousMessages:(NSString *) threadId
              fromTimestamp:(double)timestamp
               withPagesize:(NSInteger) pageSize
                 completion:(ResultCompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        NSArray *records = [[MPChatDBManager sharedInstance] getPreviousMessages:threadId
                                                                   fromTimestamp:timestamp
                                                                    withPagesize:pageSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(records);
        });
    });
}


-(void) getNextMessages:(NSString *) threadId
          fromTimestamp:(double)timestamp
           withPagesize:(NSInteger) pageSize
             completion:(ResultCompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        NSArray *records = [[MPChatDBManager sharedInstance] getNextMessages:threadId
                                                               fromTimestamp:timestamp
                                                                withPagesize:pageSize];
        dispatch_async(dispatch_get_main_queue(), ^{
            block(records);
        });
    });
}


//tested ok
-(void) getPreviousChatThreadsForUser:(NSString *)userId
                        fromTimestamp:(double)timestamp
                         withPageSize:(NSInteger)pageSize
                           completion:(ResultCompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        NSArray *records = [[MPChatDBManager sharedInstance] getPreviousChatThreadsForUser:userId
                                                                             fromTimestamp:timestamp
                                                                              withPageSize:pageSize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(records);
        });
    });
}


//tested ok
-(void) getNextChatThreadsForUser:(NSString *)userId
                    fromTimestamp:(double)timestamp
                     withPageSize:(NSInteger)pageSize
                       completion:(ResultCompletionBlock)block
{
    dispatch_async(_backgroundQueue, ^{
        
        NSArray *records = [[MPChatDBManager sharedInstance] getNextChatThreadsForUser:userId
                                                                         fromTimestamp:timestamp
                                                                          withPageSize:pageSize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(records);
        });
    });
}


@end
