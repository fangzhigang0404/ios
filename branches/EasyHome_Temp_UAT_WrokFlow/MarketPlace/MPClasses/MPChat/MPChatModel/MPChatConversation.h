/**
 * @file    MPChatConversation.h
 * @brief   conversation model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <Foundation/Foundation.h>

@class MPChatMessage;

@interface MPChatConversation : NSObject

///thread_id The thread_id is thead id.
@property (strong, nonatomic) NSString *thread_id;
///total_message_count The total_message_count is total message count.
@property (strong, nonatomic) NSNumber *total_message_count;
///unread_message_count The unread_message_count is unread message count.
@property (strong, nonatomic) NSNumber *unread_message_count;
///date_submitted The date_submitted is submit date.
@property (strong, nonatomic) NSString *date_submitted;
///latest_message The latest_message is latest message.
@property (strong, nonatomic) MPChatMessage *latest_message;

//These are optional fields, muddy...
///x_coordinate.
@property (strong, nonatomic) NSNumber *x_coordinate;
///y_coordinate.
@property (strong, nonatomic) NSNumber *y_coordinate;
///z_coordinate.
@property (strong, nonatomic) NSNumber *z_coordinate;
/**
 *  @brief dictionary setvalue from conversation model .
 *
 *  @param user .
 *
 *  @return NSDictionary dic.
 */
+ (NSDictionary*) toFoundationObj:(MPChatConversation*)user;
/**
 *  @brief conversation model setvalue from dictionary .
 *
 *  @param dict .
 *
 *  @return MPChatConversation user.
 */
+ (MPChatConversation*) fromFoundationObj:(NSDictionary*)dict;

@end
