/**
 * @file    MPChatDBManager.m
 * @brief   the chat manager of DataBase.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-22
 *
 */

#import "MPChatDBManager.h"
#import <Foundation/Foundation.h>
#import <FMDB.h>
#import "MPFileUtility.h"
#import "MPChatThread.h"
#import "MPChatMessage.h"

// TO DO : NEEDS TO MOVE SOME OF NON-HTTP RELATED FUNCTIONS
// FROM THIS FILE TO OTHER LOCATION
#import "MPChatHttpManager.h"

#define DBNAME @"mpchat.sqlite"
#define DBFOLDERNAME @"mpchatdb"
#define DB_VERSION 1.0

@interface MPChatDBManager()
{
    FMDatabaseQueue *_dbQueue;
}
@end

@implementation MPChatDBManager

#pragma mark -SharedInstance


+ (instancetype)sharedInstance
{
    
    static MPChatDBManager *s_dbmanger = nil;
    static dispatch_once_t s_predicate;
    dispatch_once(&s_predicate, ^{
        s_dbmanger = [[super allocWithZone:NULL]init];
        [s_dbmanger setFMDBConnection];
    });
    
    return s_dbmanger;
}

///override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [MPChatDBManager sharedInstance];
}

///override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    
    return [MPChatDBManager sharedInstance];
}


// Create a single instance of FMDatabaseQueue Object
// This object will be shared across threads as per client usage
// It is not necessary to have multiple queue objects
-(void) setFMDBConnection
{
    // 1. Get Document directory
    NSString *documentsPath = [MPFileUtility getDocumentDirectory];
    
    // 2. check and create folder in Document directory
    NSString *dbFolderPath = [documentsPath stringByAppendingPathComponent:DBFOLDERNAME];
    
    if (dbFolderPath)
    {
        if (![MPFileUtility isDirectoryExist:dbFolderPath])
        {
            NSString *path = [MPFileUtility createFolderInDocDir:DBFOLDERNAME];
            NSAssert(path, @"problem in creating database folder");
        }

        NSString *dbPath = [dbFolderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",DBNAME]];
        NSLog(@"*******DB Message-- Database Path = %@", dbPath);
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        [self loadChatTables];
    }
    
    //[self loadMessageDummyData];
    //[self loadThreadDummyData];
}

#pragma mark- test methods
/*
-(void) loadThreadDummyData
{
    MPChatThread *mpChatThread = [[MPChatThread alloc] init];
    
    for (NSInteger i = 0; i < 20; ++i)
    {
        mpChatThread.thread_id = [NSString stringWithFormat:@"%ld",i];
        mpChatThread.threadData = @"acbdsed";
        mpChatThread.timeStamp = 2.0 * i;
        [self addNewThread:mpChatThread forUser:@"nilesh"];
    }
}


-(void) loadMessageDummyData
{
    MPChatMessage *mpChatMessage = [[MPChatMessage alloc] init];
    
    for (NSInteger i = 0; i < 10; ++i)
    {
        mpChatMessage.messageId = [NSString stringWithFormat:@"%ld",i];
        mpChatMessage.threadId = [NSString stringWithFormat:@"%ld",i / 100];
        mpChatMessage.messageData = @"acbdsed";
        mpChatMessage.timeStamp = 2.0 * i;;
        [self addNewMessage:mpChatMessage
                    forUser:@"nilesh"];
    }
}
*/

#pragma mark- public interface methods

//This function will create required tables for chat data

// Tested OK
-(void) loadChatTables
{
    __block BOOL bSuccess = NO;
    
    // 1. Create if necessary Thread Table
    NSString *sqlStatements = @"CREATE TABLE IF NOT EXISTS threads (id INTEGER PRIMARY KEY AUTOINCREMENT, userid TEXT NOT NULL, threadid TEXT NOT NULL, threaddata TEXT, lastmessageid TEXT, timestamp NUMERIC NOT NULL);"
    "CREATE TABLE IF NOT EXISTS messages (id INTEGER PRIMARY KEY AUTOINCREMENT, threadid TEXT NOT NULL, messageid TEXT NOT NULL, messagedata TEXT, timestamp NUMERIC NOT NULL);";
    [_dbQueue inDatabase:^(FMDatabase *db) {
        bSuccess = [db executeStatements:sqlStatements];
        NSLog(@"*******DB Message-- Using SQLLite Lib Version = %@ FMDB Lib version = %@", [FMDatabase sqliteLibVersion], [FMDatabase FMDBUserVersion]);
    }];
    
    NSAssert(bSuccess, @"*********Unable to create tables in DB");
    NSLog(@"*******DB Message-- threads and messages tables created/loaded");
}


#pragma mark- public interface methods

//this function should not be used it can pull many records and can create memmory issues
// so just added for testing and not exposing it
-(NSArray *) getAllMessagesFromThread:(NSString *)threadId
{
    NSMutableArray *records = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT * from messages WHERE threadid = ?", threadId];
        [self logQuery:rs.query];
        
        while ([rs next])
        {
            NSString *messageData = [rs stringForColumn:@"messagedata"];
            MPChatMessage *mpChatMessage = [MPChatMessage fromJSONString:messageData];
            [records addObject:mpChatMessage];
            mpChatMessage = nil;
        }
        
        [rs close];
    }];
    
    return records;
}


-(MPChatThread *) getThreadDetails:(NSString *)threadId
                         forUser:(NSString *)userId
{
    __block MPChatThread *mpChatThread = nil;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT * from threads WHERE threadid = ? AND userid = ?", threadId, userId];
        [self logQuery:rs.query];
        
        while ([rs next])
        {
            mpChatThread = [MPChatThread fromJSONString:[rs stringForColumn:@"threaddata"]];
            break;
        }
        
        [rs close];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- Received thread with ID = %@", mpChatThread.thread_id);
    }];
    
    return mpChatThread;
}

-(MPChatMessage *) getMessageDetails:(NSString *)messageId
{
    __block MPChatMessage *mpChatMessage = nil;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM messages WHERE messageid = ?", messageId];
        [self logQuery:rs.query];
        
        while ([rs next])
        {
            mpChatMessage = [MPChatMessage fromJSONString:[rs stringForColumn:@"messagedata"]];
            break;
        }
        
        [rs close];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- Received message with ID = %@", mpChatMessage.message_id);
    }];
    
    return mpChatMessage;
}



-(BOOL) checkAndInsertChatThread:(NSString *)userId
                     chatDetails:(MPChatThread *)mpThread
                            inDB:(FMDatabase *)db
{
    BOOL bSuccess = NO;
    
    if (mpThread)
    {
        
        //First check whether this thread is present or not
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) FROM threads WHERE threadid = ? AND userid = ?", mpThread.thread_id, userId];
        
        int totalCount = 0;
        
        if ([rs next])
            totalCount = [rs intForColumnIndex:0];
        
        [rs close];
        
        if (totalCount > 0)
        {
            bSuccess = [db executeUpdate:@"UPDATE threads SET threaddata = ?, lastmessageid = ?, timestamp = ? WHERE threadid = ? AND userid = ?", [MPChatThread toJSONString:mpThread], mpThread.lastMessage.message_id ?: [NSNull null], [NSNumber numberWithDouble:[self getTimestampFromDateString:mpThread.created_date]], mpThread.thread_id, userId];
            
            if ([db hadError])
                [self logDBErrors:db];
            else
                NSLog(@"*******DB Message-- Updated thread with id = %@", mpThread.thread_id);
        }
        else
        {
            //insert new row
            bSuccess = [db executeUpdate:@"INSERT INTO threads (userid, threadid, threaddata, lastmessageid, timestamp) VALUES (?, ?, ?, ?, ?)", userId, mpThread.thread_id, [MPChatThread toJSONString:mpThread], mpThread.lastMessage.message_id ?: [NSNull null], [NSNumber numberWithDouble:[self getTimestampFromDateString:mpThread.created_date]]];
            
            if ([db hadError])
                [self logDBErrors:db];
            else
                NSLog(@"*******DB Message-- Inserted thread with id = %@", mpThread.thread_id);
        }
    }
    return bSuccess;
}



-(BOOL) addNewThread:(MPChatThread *)mpThread
             forUser:(NSString *)userId
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        bSuccess = [self checkAndInsertChatThread:userId
                                      chatDetails:mpThread inDB:db];
    }];
    
    return bSuccess;
}


-(BOOL) addNewThreads:(NSArray *)mpThreads
              forUser:(NSString *)userId
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        [mpThreads enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            bSuccess = [self checkAndInsertChatThread:userId
                                          chatDetails:obj inDB:db];
            
        }];
        
    }];
    
    return bSuccess;
}


-(BOOL) updateThread:(NSString *)threadId
             forUser:(NSString *)userId
   withLastMessageId:(NSString *)messageId
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        bSuccess = [db executeUpdate:@"UPDATE threads SET lastmessageid = ? WHERE threadid = ? AND userid = ?", messageId ?: [NSNull null], threadId,userId];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- Updated thread with id = %@", threadId);
        
    }];
    
    return bSuccess;
}

-(BOOL) checkAndInsertChatMessage:(NSString *)userId
                   messageDetails:(MPChatMessage *)mpChatMessage
                             inDB:(FMDatabase *)db
{
    BOOL bSuccess = NO;
    
    if (mpChatMessage)
    {
        
        //First check whether this thread is present or not
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) FROM messages WHERE messageid = ?", mpChatMessage.message_id];
        
        int totalCount = 0;
        
        if ([rs next])
            totalCount = [rs intForColumnIndex:0];
        
        [rs close];
        
        if (totalCount > 0)
        {
            bSuccess = [db executeUpdate:@"UPDATE messages SET threadid = ?, messagedata = ?, timestamp = ? WHERE messageid = ?", mpChatMessage.thread_id, [MPChatMessage toJSONString:mpChatMessage], [NSNumber numberWithDouble:[self getTimestampFromDateString:mpChatMessage.sent_time]], mpChatMessage.message_id];
            
            if ([db hadError])
                [self logDBErrors:db];
            else
                NSLog(@"*******DB Message-- Updated Message with id = %@", mpChatMessage.message_id);
            
        }
        else
        {
            bSuccess = [db executeUpdate:@"INSERT INTO messages (threadid, messageid, messagedata, timestamp) VALUES (?, ?, ?, ?)",mpChatMessage.thread_id, mpChatMessage.message_id, [MPChatMessage toJSONString:mpChatMessage], [NSNumber numberWithDouble:[self getTimestampFromDateString:mpChatMessage.sent_time]]];
            
            if ([db hadError])
                [self logDBErrors:db];
            else
                NSLog(@"*******DB Message-- Inserted Message with id = %@", mpChatMessage.message_id);
        }
        
        if (bSuccess)
        {
            //update thread with last message id info
            bSuccess = [db executeUpdate:@"UPDATE threads SET lastmessageid = ? WHERE threadid = ? AND userid = ?", mpChatMessage.message_id, mpChatMessage.thread_id, userId];
            
            if ([db hadError])
                [self logDBErrors:db];
            else
                NSLog(@"*******DB Message-- Updated thread with id = %@", mpChatMessage.thread_id);
        }
    }
    
    return bSuccess;
}


-(BOOL) addNewMessage:(MPChatMessage *)mpChatMessage
              forUser:(NSString *)userId
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        bSuccess = [self checkAndInsertChatMessage:userId
                                    messageDetails:mpChatMessage
                                              inDB:db];
    }];
    
    return bSuccess;
}

-(BOOL) addNewMessages:(NSArray *)mpChatMessages
               forUser:(NSString *)userId
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        [mpChatMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            bSuccess = [self checkAndInsertChatMessage:userId
                                        messageDetails:obj
                                                  inDB:db];
            
        }];
    }];
    
    return bSuccess;
}


-(NSInteger) getTotalThreadsCountForUser:(NSString *)userId
{
    __block NSInteger count = 0;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        //First check whether this thread is present or not
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) FROM threads WHERE userid = ?", userId];
        
        [self logQuery:rs.query];
        
        if ([rs next])
            count = [rs intForColumnIndex:0];
        
        [rs close];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- Received total threads count = %ld for user = %@", (long)count, userId);
        
    }];
    
    return count;
    
}


-(NSInteger) getTotalMessagesCountForThread:(NSString *)threadId
{
    __block NSInteger count = 0;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        //First check whether this thread is present or not
        FMResultSet *rs = [db executeQuery:@"SELECT COUNT(*) FROM messages WHERE threadid = ?", threadId];
        
        [self logQuery:rs.query];
        
        if ([rs next])
            count = [rs intForColumnIndex:0];
        
        [rs close];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- Received total Messages count = %ld for thread = %@", (long)count, threadId);
        
    }];
    
    return count;
    
}


-(BOOL) removeThreadWithId:(NSString *)mpThreadId
                   forUser:(NSString *)userId
{
    __block BOOL bSuccess = NO;
    
    // First Delete Messages attached with this thread
    // Delete thread
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE threadid = ?", mpThreadId];
        
        if ([db hadError])
            [self logDBErrors:db];
        
        bSuccess = [db executeUpdate:@"DELETE FROM threads WHERE threadid = ? AND userid = ?", mpThreadId, userId];
        
        if ([db hadError])
            [self logDBErrors:db];
        else if([db changes])
            NSLog(@"*******DB Message-- Deleted thread = %@", mpThreadId);
        else
            NSLog(@"*******DB Message-- thread %@ not found", mpThreadId);
    }];
    
    return bSuccess;
}


-(BOOL) removeThreads:(NSArray *)mpThreads
              forUser:(NSString *)userId
{
    __block BOOL bSuccess = NO;
    
    // First Delete Messages attached with this thread
    // Delete thread
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        [mpThreads enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            MPChatThread *mpThread = (MPChatThread *)obj;
            
            if (mpThread)
            {
                
                bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE threadid = ?", mpThread.thread_id];
                
                if ([db hadError])
                    [self logDBErrors:db];
                
                bSuccess = [db executeUpdate:@"DELETE FROM threads WHERE threadid = ? AND userid = ?", mpThread.thread_id, userId];
                
                if ([db hadError])
                {
                    [self logDBErrors:db];
                    *stop = YES;
                }
                else if([db changes])
                    NSLog(@"*******DB Message-- Deleted thread = %@", mpThread.thread_id);
                else
                    NSLog(@"*******DB Message-- thread %@ not found", mpThread.thread_id);
            }
            
        }];
    }];
    
    return bSuccess;
}



-(BOOL) removeThread:(MPChatThread *)mpThread
             forUser:(NSString *)userId
{
    __block BOOL bSuccess = NO;
    
    // First Delete Messages attached with this thread
    // Delete thread
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE threadid = ?", mpThread.thread_id];
        
        if ([db hadError])
            [self logDBErrors:db];
        
        bSuccess = [db executeUpdate:@"DELETE FROM threads WHERE threadid = ? AND userid = ?", mpThread.thread_id, userId];
        
        if ([db hadError])
            [self logDBErrors:db];
        else if([db changes])
            NSLog(@"*******DB Message-- Deleted thread = %@", mpThread.thread_id);
        else
            NSLog(@"*******DB Message-- thread %@ not found", mpThread.thread_id);
    }];
    
    return bSuccess;
}


-(BOOL) removeMessageWithId:(NSString*)messageId
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE messageid = ?", messageId];
        
        if ([db hadError])
            [self logDBErrors:db];
        else if([db changes])
            NSLog(@"*******DB Message-- Deleted message = %@", messageId);
        else
            NSLog(@"*******DB Message-- message %@ not found", messageId);
    }];
    
    return bSuccess;
}


-(BOOL) removeMessage:(MPChatMessage *)mpChatMessage
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE messageid = ?", mpChatMessage.message_id];
        
        if ([db hadError])
            [self logDBErrors:db];
        else if([db changes])
            NSLog(@"*******DB Message-- Deleted message = %@", mpChatMessage.message_id );
        else
            NSLog(@"*******DB Message-- message %@ not found", mpChatMessage.message_id);
    }];
    
    return bSuccess;
}

-(BOOL) removeMessages:(NSArray *)mpChatMessages
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        [mpChatMessages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
         {
             MPChatMessage *mpChatMessage = (MPChatMessage *)obj;
             
             if (mpChatMessage)
             {
                 
                 bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE messageid = ?", mpChatMessage.message_id];
                 
                 if ([db hadError])
                 {
                     [self logDBErrors:db];
                     *stop = YES;
                 }
                 else if([db changes])
                     NSLog(@"*******DB Message-- Deleted message = %@", mpChatMessage.message_id);
                 else
                     NSLog(@"*******DB Message-- message %@ not found", mpChatMessage.message_id);
             }
             
         }];
    }];
    
    return bSuccess;
}

// this will be quite exhaustive task :-)
-(BOOL) removeAllthreads:(NSString *)userId
{
    // success status should be checked on each other queries also
    // but right now not doing this
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        // 1. Get all Threads
        FMResultSet *rs = [db executeQuery:@"SELECT * from threads WHERE userid = ?", userId];
        
        [self logQuery:rs.query];
        
        // 2. Iterate and delete related messages for that thread
        while ([rs next])
        {
            NSString *threadId = [rs stringForColumn:@"threadid"];
            [db executeUpdate:@"DELETE FROM messages WHERE threadid = ?", threadId];
        }
        
        [rs close];
        // 3. Delete all threads finally
        bSuccess = [db executeUpdate:@"DELETE FROM threads WHERE userid = ?", userId];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- Deleted all threads for user = %@", userId);
    }];
    
    return bSuccess;
}


-(BOOL) removeAllMessages:(NSString *)threadId
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE threadid = ?", threadId];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- Deleted all messages for thread = %@", threadId);
    }];
    
    return bSuccess;
}


-(BOOL) removeMessagesBefore:(NSInteger)days
                   fromToday:(BOOL)bFromToday
{
    __block BOOL bSuccess = NO;
    __block NSTimeInterval timestamp = 0;
    
    if (bFromToday)
    {
        // 1. Get the date before 15 days from today
        
        NSDate *pastDay = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay
                                                                   value:-15
                                                                  toDate:[NSDate date]
                                                                 options:0];
        // 2. get timestamp for pastday
        timestamp = [pastDay timeIntervalSince1970];
    }
    else
    {
        [_dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select * from messages order by timestamp DESC LIMIT 1"];
            
            int count = 0;
            while ([rs next])
            {
                timestamp = [rs doubleForColumn:@"timestamp"];
                ++count;
            }
            
            [rs close];
            
            if (count > 1)
                bSuccess = NO; //this should not occur
            
            
            if ([db hadError])
                [self logDBErrors:db];
        }];
    }
    
    if (bSuccess && timestamp > 0)
    {
        [_dbQueue inDatabase:^(FMDatabase *db) {
            bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE timestamp < ?", timestamp];
            
            if ([db hadError])
                [self logDBErrors:db];
            else
                NSLog(@"*******DB Message-- Deleted all messages before %ld days", (long)days);
        }];
    }
    
    return bSuccess;
}


-(BOOL) reduceCacheWithLimit:(NSInteger)limit
{
    __block BOOL bSuccess = NO;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        BOOL bSuccess = [db executeUpdate:@"DELETE FROM messages WHERE messageid NOT IN (SELECT messageid FROM (SELECT messageid FROM messages ORDER BY timestamp DESC LIMIT ?) T2)",limit];
        
        if ([db hadError] && !bSuccess)
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- Deleted all messages by keeping most recent %ld messages",(long)limit);
    }];
    
    return bSuccess;
}


-(NSArray *) getPreviousMessages:(NSString *)threadId
                   fromTimestamp:(double)timestamp
                    withPagesize:(NSInteger) pageSize
{
    NSMutableArray *records = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = nil;
        
        if (timestamp > 0)
        {
            rs = [db executeQuery:@"SELECT * FROM (SELECT * from messages WHERE threadid = ? AND timestamp < ? ORDER BY timestamp DESC LIMIT ?)T1 ORDER BY timestamp", threadId,[NSNumber numberWithDouble:timestamp],[NSNumber numberWithInteger:pageSize]];
        }
        else
        {
            rs = [db executeQuery:@"SELECT * FROM ( SELECT * from messages WHERE threadid = ? ORDER BY timestamp DESC LIMIT ?)T1 ORDER BY timestamp", threadId, [NSNumber numberWithInteger:pageSize]];
            
        }
        
        [self logQuery:rs.query];
        
        while ([rs next])
        {
            MPChatMessage *mpChatMessage = [MPChatMessage fromJSONString:[rs stringForColumn:@"messagedata"]];
            [records addObject:mpChatMessage];
        }
        
        [rs close];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- received messages = %ld for thread = %@", (unsigned long)[records count], threadId);
    }];
    
    return records;
}


-(NSArray *) getNextMessages:(NSString *)threadId
               fromTimestamp:(double)timestamp
                withPagesize:(NSInteger) pageSize
{
    NSMutableArray *records = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = nil;
        
        if (timestamp > 0)
        {
            rs = [db executeQuery:@"SELECT * from messages WHERE threadid = ? AND timestamp > ? ORDER BY timestamp LIMIT ?", threadId,[NSNumber numberWithDouble:timestamp],[NSNumber numberWithInteger:pageSize]];
        }
        else
        {
            rs = [db executeQuery:@"SELECT * FROM ( SELECT * from messages WHERE threadid = ? ORDER BY timestamp DESC LIMIT ?)T1 ORDER BY timestamp", threadId, [NSNumber numberWithInteger:pageSize]];
        }
        
        [self logQuery:rs.query];
        
        while ([rs next])
        {
            MPChatMessage *mpChatMessage = [MPChatMessage fromJSONString:[rs stringForColumn:@"messagedata"]];
            [records addObject:mpChatMessage];
        }
        
        [rs close];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- received messages = %ld for thread = %@", (unsigned long)[records count], threadId);
        
    }];
    
    return records;
}


-(NSArray *) getPreviousChatThreadsForUser:(NSString *)userId
                             fromTimestamp:(double)timestamp
                              withPageSize:(NSInteger)pageSize
{
    NSMutableArray *records = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = nil;
        
        if (timestamp > 0)
        {
            rs = [db executeQuery:@"SELECT * FROM (SELECT * from threads WHERE userid = ? AND timestamp < ? ORDER BY timestamp DESC LIMIT ?)T1 ORDER BY timestamp DESC", userId,[NSNumber numberWithDouble:timestamp],[NSNumber numberWithInteger:pageSize]];
            
        }
        else
        {
            rs = [db executeQuery:@"SELECT * FROM ( SELECT * from threads WHERE userid = ? ORDER BY timestamp DESC LIMIT ?)T1 ORDER BY timestamp DESC", userId, [NSNumber numberWithInteger:pageSize]];
            
        }
        
        
        [self logQuery:rs.query];
        
        while ([rs next])
        {
            MPChatThread *mpChatThread = [MPChatThread fromJSONString:[rs stringForColumn:@"threaddata"]];
            [records addObject:mpChatThread];
        }
        
        [rs close];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- received threads = %ld for user = %@", (unsigned long)[records count], userId);
        
    }];
    
    return records;
}


-(NSArray *) getNextChatThreadsForUser:(NSString *)userId
                         fromTimestamp:(double)timestamp
                          withPageSize:(NSInteger)pageSize
{
    NSMutableArray *records = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = nil;
        
        if (timestamp > 0)
        {
            rs = [db executeQuery:@"SELECT * from threads WHERE userid = ? AND timestamp > ? ORDER BY timestamp LIMIT ?", userId,[NSNumber numberWithDouble:timestamp],[NSNumber numberWithInteger:pageSize]];
        }
        else
        {
            rs = [db executeQuery:@"SELECT * FROM ( SELECT * from threads WHERE userid = ? ORDER BY timestamp DESC LIMIT ?)T1 ORDER BY timestamp DESC", userId, [NSNumber numberWithInteger:pageSize]];
        }
        
        [self logQuery:rs.query];
        
        while ([rs next])
        {
            MPChatThread *mpChatThread = [MPChatThread fromJSONString:[rs stringForColumn:@"threaddata"]];
            [records addObject:mpChatThread];
        }
        
        [rs close];
        
        if ([db hadError])
            [self logDBErrors:db];
        else
            NSLog(@"*******DB Message-- received threads = %ld for user = %@", (unsigned long)[records count], userId);
    }];
    
    return records;
}

#pragma mark - logging db errors and queries

-(void) logQuery:(NSString *)query
{
    NSLog(@"*******DB Message-- executing query = %@", query);
}


-(void) logDBErrors:(FMDatabase *)db
{
    NSLog(@"*******DB Message-- error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
}


#pragma mark - utility function
-(double) getTimestampFromDateString:(NSString *)dateString
{
    NSDate *date = [MPChatHttpManager acsDateToNSDate:dateString];
    return [date timeIntervalSince1970];
}


@end
