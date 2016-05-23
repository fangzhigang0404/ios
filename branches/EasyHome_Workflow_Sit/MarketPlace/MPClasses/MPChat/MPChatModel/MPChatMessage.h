#import <Foundation/Foundation.h>


@class MPChatCommandInfo;

typedef enum eMPChatMessageType : NSUInteger
{
    eTEXT = 0,
    eIMAGE,
    eAUDIO,
    eCOMMAND,
    eNONE
} eMPChatMessageType;

@interface MPChatMessage : NSObject

/// subject.
@property (strong, nonatomic) NSString *subject;
/// body.
@property (strong, nonatomic) NSString *body;
/// thread_id The thread_id is thread id.
@property (strong, nonatomic) NSString *thread_id;
/// sent_time The sent_time is send time.
@property (strong, nonatomic) NSString *sent_time; //see [MPChatHttpManager acsDateToNSDate]
/// sender_member_id The sender_member_id is sender member id.
@property (strong, nonatomic) NSNumber *sender_member_id;
/// sender_screen_name The sender_screen_name is sender screen name.
@property (strong, nonatomic) NSString *sender_screen_name;
/// recipient_member_id The recipient_member_id is recipient member id.
@property (strong, nonatomic) NSNumber *recipient_member_id;
/// recipient_screen_name The recipient_screen_name is recipient screen name.
@property (strong, nonatomic) NSString *recipient_screen_name;
/// message_id The message_id is message id.
@property (strong, nonatomic) NSString *message_id;
/// read_time The read_time is read time.
@property (strong, nonatomic) NSString *read_time; //see [MPChatHttpManager acsDateToNSDate]
/// message_media_type The message_media_type is message media type.
@property (assign, nonatomic) enum eMPChatMessageType message_media_type;
/// sender_profile_image The sender_profile_image is sender avatar.
@property (strong, nonatomic) NSString *sender_profile_image;
/// recipient_profile_image The recipient_profile_image isrecipient avatar.
@property (strong, nonatomic) NSString *recipient_profile_image;
/// command.
@property (strong, nonatomic) NSString *command;
/// media_file_id The media_file_id is media file id.
@property (strong, nonatomic) NSNumber *media_file_id;
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param msg.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatMessage*)msg;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPChatMessage.
 */
+ (MPChatMessage*) fromFoundationObj:(NSDictionary*)dict;
/**
 *  @brief json data setvalue from model .
 *
 *  @param msg.
 *
 *  @return id.
 */
+ (id) toJSON:(MPChatMessage*) msg;
/**
 *  @brief model setvalue from json data .
 *
 *  @param json.
 *
 *  @return MPChatMessage.
 */
+ (MPChatMessage*) fromJSON:(id) json;
/**
 *  @brief model setvalue from json.
 *
 *  @param jsonString.
 *
 *  @return MPChatMessage.
 */
+ (MPChatMessage*) fromJSONString:(NSString*) jsonString;
/**
 *  @brief json  setvalue from model .
 *
 *  @param msg.
 *
 *  @return NSString.
 */
+ (NSString*) toJSONString:(MPChatMessage*) msg;
/**
 *  @brief model setvalue from array.
 *
 *  @param msg.
 *
 *  @return MPChatMessage.
 */
+ (MPChatMessage*) fromRawNotificationData:(NSArray*)msg;
/**
 *  @brief get command infomation from model.
 *
 *  @param msg.
 *
 *  @return MPChatCommandInfo.
 */
+ (MPChatCommandInfo*) getCommandInfoFromMessage:(MPChatMessage*)msg;

@end
