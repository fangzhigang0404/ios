#import <Foundation/Foundation.h>

@interface MPChatConversations : NSObject

///conversations the conversations is array of MPChatConversation.
@property (strong, nonatomic) NSMutableArray *conversations; // array of MPChatConversation
/**
 *  @brief dictionary setvalue from conversations model .
 *
 *  @param conversations .
 *
 *  @return NSArray array.
 */
+ (NSArray*) toFoundationObj:(MPChatConversations*)conversations;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param obj .
 *
 *  @return MPChatConversation user.
 */
+ (MPChatConversations*) fromFoundationObj:(NSArray*)obj;


@end
