
#import <Foundation/Foundation.h>
@class MPChatConversations;
@class MPChatEntityData;

@interface MPChatEntity : NSObject

///entity_type The entity_type is entity type.
@property (strong, nonatomic) NSString *entity_type;
///entity_id The entity_id is entity id.
@property (strong, nonatomic) NSString *entity_id;
///conversations The conversations is array of conversation.
@property (strong, nonatomic) MPChatConversations *conversations;
///entity_data The entity_data is entity data.
@property (strong, nonatomic) MPChatEntityData *entity_data;
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param user.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatEntity*)user;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPChatEntity .
 */
+ (MPChatEntity*) fromFoundationObj:(NSDictionary*)dict;

@end
