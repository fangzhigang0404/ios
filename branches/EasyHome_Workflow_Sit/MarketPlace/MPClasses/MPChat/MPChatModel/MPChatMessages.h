#import <Foundation/Foundation.h>

@interface MPChatMessages : NSObject

/// offset.
@property (strong, nonatomic) NSNumber* offset;
/// numMessages.
@property (strong, nonatomic) NSNumber* numMessages;
/// messages.
@property (strong, nonatomic) NSMutableArray *messages; // array of MPChatMessage
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param msgs.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatMessages*)msgs;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPChatMessages.
 */
+ (MPChatMessages*) fromFoundationObj:(NSDictionary*)dict;

@end