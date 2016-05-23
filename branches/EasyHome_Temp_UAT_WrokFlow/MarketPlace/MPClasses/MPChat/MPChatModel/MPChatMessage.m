#import "MPChatMessage.h"
#import "MPChatHttpManager.h"
#import "MPChatCommandInfo.h"

@implementation MPChatMessage

+ (eMPChatMessageType) toMPChatMessageType:(NSString*)mediaType
{
    if (![mediaType compare:@"TEXT" options:NSCaseInsensitiveSearch])
        return eTEXT;
    else if (![mediaType compare:@"IMAGE" options:NSCaseInsensitiveSearch])
        return eIMAGE;
    else if (![mediaType compare:@"AUDIO" options:NSCaseInsensitiveSearch])
        return eAUDIO;
    else if (![mediaType compare:@"COMMAND" options:NSCaseInsensitiveSearch])
        return eCOMMAND;
    else
        return eNONE;
}


+ (NSString*) fromMPChatMessageType:(eMPChatMessageType)mediaType
{
    switch (mediaType)
    {
        case eTEXT:
            return @"TEXT";
        case eIMAGE:
            return @"IMAGE";
        case eAUDIO:
            return @"AUDIO";
        case eCOMMAND:
            return @"COMMAND";
            break;
            
        default:
            break;
    }
    
    return @"";
}


- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict)
        {
            self.subject = [dict objectForKey:@"subject"];
           
            self.message_media_type = [MPChatMessage toMPChatMessageType:[dict objectForKey:@"message_media_type"]];
            
            if (self.message_media_type == eIMAGE || self.message_media_type == eAUDIO)
            {
                NSString *body = [dict objectForKey:@"body"];
                NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary* dict2 = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
                self.body = [dict2 objectForKey:@"file_url"];
                self.media_file_id = [dict2 objectForKey:@"media_file_id"];
            }
            else
            {
                self.body = [dict objectForKey:@"body"];
            }
           
            
            self.thread_id = [dict objectForKey:@"thread_id"];
            self.sent_time = [dict objectForKey:@"sent_time"];
            self.sender_member_id = [dict objectForKey:@"sender_member_id"];
            self.sender_screen_name = [dict objectForKey:@"sender_screen_name"];
            self.recipient_member_id = [dict objectForKey:@"recipient_member_id"];
            self.recipient_screen_name = [dict objectForKey:@"recipient_screen_name"];
            self.message_id = [dict objectForKey:@"message_id"];
            self.read_time = [dict objectForKey:@"read_time"];
            self.message_media_type = [MPChatMessage toMPChatMessageType:[dict objectForKey:@"message_media_type"]];
            self.sender_profile_image = [dict objectForKey:@"sender_profile_image"];
            self.recipient_profile_image = [dict objectForKey:@"recipient_profile_image"];
            self.command = [dict objectForKey:@"command"];
            
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatMessage*)msg
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:msg.subject forKey:@"subject"];
    
    if (msg.message_media_type == eIMAGE || msg.message_media_type == eAUDIO)
    {
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]init];
        [dict2 setObject:msg.body forKey:@"file_url"];
        [dict2 setObject:msg.media_file_id forKey:@"file_url"];
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict2 options:0 error:0];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [dict setValue:jsonString forKey:@"body"];
    }
    else
        [dict setValue:msg.body forKey:@"body"];
    
    [dict setValue:msg.thread_id forKey:@"thread_id"];
    [dict setValue:msg.sent_time forKey:@"sent_time"];
    [dict setValue:msg.sender_member_id forKey:@"sender_member_id"];
    [dict setValue:msg.sender_screen_name forKey:@"sender_screen_name"];
    [dict setValue:msg.recipient_member_id forKey:@"recipient_member_id"];
    [dict setValue:msg.recipient_screen_name forKey:@"recipient_screen_name"];
    [dict setValue:msg.message_id forKey:@"message_id"];
    [dict setValue:msg.read_time forKey:@"read_time"];
    [dict setValue:[MPChatMessage fromMPChatMessageType:msg.message_media_type] forKey:@"message_media_type"];
    [dict setValue:msg.sender_profile_image forKey:@"sender_profile_image"];
    [dict setValue:msg.recipient_profile_image forKey:@"recipient_profile_image"];
    [dict setValue:msg.command forKey:@"command"];
    [dict setValue:msg.media_file_id forKey:@"file_id"];
    
    return dict;
}


+ (MPChatMessage*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatMessage *msg = [[MPChatMessage alloc] initWithFoundationObj:dict];
    return msg;
}


+ (id) toJSON:(MPChatMessage*) msg
{
    NSDictionary *dict = [MPChatMessage toFoundationObj:msg];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    
    return jsonData;
}


+ (MPChatMessage*) fromJSON:(id) json
{
    NSError *error;
    id dict = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
    
    MPChatMessage *chatThread = [MPChatMessage fromFoundationObj:dict];
    return chatThread;
}


+ (MPChatMessage*) fromJSONString:(NSString*) jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    MPChatMessage *chatThread = [MPChatMessage fromJSON:data];
    return chatThread;
}


+ (NSString*) toJSONString:(MPChatMessage*) msg
{
    NSData *jsonData = [MPChatMessage toJSON:msg];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


+ (MPChatMessage*) fromRawNotificationData:(NSArray*)msg
{
    MPChatMessage *chatmsg = [[MPChatMessage alloc] initWithFoundationObj:nil];
    NSString *attrString = [msg[0] objectForKey:@"data"];
    NSArray* dataAttrs = [attrString componentsSeparatedByString:@","];
    
    chatmsg.message_id = dataAttrs[0];
    chatmsg.thread_id = dataAttrs[1];
    chatmsg.subject = dataAttrs[2];
    chatmsg.message_media_type = [MPChatMessage toMPChatMessageType:dataAttrs[4]];
    chatmsg.sent_time = [MPChatHttpManager nsDateToAcsDate:[NSDate date]];
    
    NSString *argString = [msg[0] objectForKey:@"args"];
    chatmsg.sender_screen_name = [[argString componentsSeparatedByString:@","] firstObject];

    
    NSUInteger childLen = [NSString stringWithFormat:@"%@,", chatmsg.sender_screen_name].length;
    chatmsg.body = [argString substringWithRange:NSMakeRange(childLen, argString.length - childLen)];
    
    return chatmsg;
}


+ (MPChatCommandInfo*) getCommandInfoFromMessage:(MPChatMessage*)msg
{
    NSString *body = msg.body;
    NSData *data = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dict2 = [NSJSONSerialization JSONObjectWithData:data options:0 error:0];
    MPChatCommandInfo* commandMessage = [MPChatCommandInfo fromFoundationObj:dict2];
    return commandMessage;
}


@end
