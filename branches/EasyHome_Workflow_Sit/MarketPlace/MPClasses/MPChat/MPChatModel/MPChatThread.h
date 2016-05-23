#import <Foundation/Foundation.h>

@class MPChatUser;
@class MPChatEntityInfos;
@class MPChatRecipients;
@class MPChatMessage;

@interface MPChatThread : NSObject

/// subject.
@property (strong, nonatomic) NSString *subject;
/// thread_id The thread_id is thread id.
@property (strong, nonatomic) NSString *thread_id;
/// recipients The recipients is array of MPChatRecipient.
@property (strong, nonatomic) MPChatRecipients *recipients;
/// total_message_count The total_message_count is total message count.
@property (strong, nonatomic) NSNumber *total_message_count;
/// unread_message_count The unread_message_count is unread message count.
@property (strong, nonatomic) NSNumber *unread_message_count;
/// sender.
@property (strong, nonatomic) MPChatUser *sender;
/// created_date The created_date is creat date .
@property (strong, nonatomic) NSString *created_date; //see [MPChatHttpManager acsDateToNSDate]
/// entity The entity is array of MPChatEntityInfos.
@property (strong, nonatomic) MPChatEntityInfos *entity;
/// lastMessage.
@property (strong, nonatomic) MPChatMessage *lastMessage;
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param user.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatThread*)user;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPChatThread.
 */
+ (MPChatThread*) fromFoundationObj:(NSDictionary*)dict;
/**
 *  @brief json  setvalue from model .
 *
 *  @param thread.
 *
 *  @return id.
 */
+ (id) toJSON:(MPChatThread*) thread;
/**
 *  @brief model setvalue from json.
 *
 *  @param json.
 *
 *  @return MPChatThread.
 */
+ (MPChatThread*) fromJSON:(id) json;
/**
 *  @brief model setvalue from json.
 *
 *  @param jsonString.
 *
 *  @return MPChatThread.
 */
+ (MPChatThread*) fromJSONString:(NSString*) jsonString;
/**
 *  @brief json  setvalue from model .
 *
 *  @param thread.
 *
 *  @return NSString.
 */
+ (NSString*) toJSONString:(MPChatThread*) thread;

/// NSString or void ?
/**
 *  @brief update thread with last message.
 *
 *  @param thread.
 *  @param unReadCount.
 *
 *  @return NSString.
 */
- (NSString*) updateThreadWithLastMessage:(MPChatMessage*)thread increaseUnreadCountBy:(NSUInteger)unReadCount;

@end
