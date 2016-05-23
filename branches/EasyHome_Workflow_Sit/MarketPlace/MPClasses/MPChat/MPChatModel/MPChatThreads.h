#import <Foundation/Foundation.h>

@interface MPChatThreads : NSObject

///numThreads The numThreads is array of MPChatThread.
@property (strong, nonatomic) NSNumber* numThreads; // array of MPChatThread
///threads The threads is array of MPChatThread.
@property (strong, nonatomic) NSMutableArray *threads; // array of MPChatThread
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param threads.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatThreads*)threads;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPChatThreads.
 */
+ (MPChatThreads*) fromFoundationObj:(NSDictionary*)dict;

@end
