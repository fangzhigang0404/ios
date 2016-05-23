#import "MPChatThread.h"
#import "MPChatRecipients.h"
#import "MPChatUser.h"
#import "MPChatEntityInfos.h"
#import "MPChatMessage.h"

@implementation MPChatThread

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        self.subject = [dict objectForKey:@"subject"];
        self.thread_id = [dict objectForKey:@"thread_id"];
        self.recipients = [MPChatRecipients fromFoundationObj:[dict objectForKey:@"recipients"]];
        self.total_message_count = [dict objectForKey:@"total_message_count"];
        self.unread_message_count = [dict objectForKey:@"unread_message_count"];
        self.sender = [MPChatUser fromFoundationObj:[dict objectForKey:@"sender"]];
        self.created_date = [dict objectForKey:@"created_date"];
        self.entity = [MPChatEntityInfos fromFoundationObj:[dict objectForKey:@"entity"]];
        self.lastMessage = [MPChatMessage fromFoundationObj:[dict objectForKey:@"latest_message"]];
    }
    return self;
}

+ (NSDictionary*) toFoundationObj:(MPChatThread*)thread
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:thread.subject forKey:@"subject"];
    [dict setValue:thread.thread_id forKey:@"thread_id"];
    [dict setValue:[MPChatRecipients toFoundationObj:thread.recipients] forKey:@"recipients"];
    [dict setValue:thread.total_message_count forKey:@"total_message_count"];
    [dict setValue:thread.unread_message_count forKey:@"unread_message_count"];
    
    [dict setValue:[MPChatUser toFoundationObj:thread.sender] forKey:@"sender"];
    [dict setValue:thread.created_date forKey:@"created_date"];
    [dict setValue:[MPChatEntityInfos toFoundationObj:thread.entity] forKey:@"entity"];
    [dict setValue:[MPChatMessage toFoundationObj:thread.lastMessage] forKey:@"lastest_message"];
    
    return dict;
}


+ (MPChatThread*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatThread *chatThread = [[MPChatThread alloc] initWithFoundationObj:dict];
    return chatThread;
}


+ (MPChatThread*)fromJSON:(id) json
{
    NSError *error;
    id dict = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];

    MPChatThread *chatThread = [MPChatThread fromFoundationObj:dict];
    return chatThread;
}


+ (id)toJSON:(MPChatThread*) thread
{
    NSDictionary *dict = [MPChatThread toFoundationObj:thread];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    
    return jsonData;
}


+ (MPChatThread*)fromJSONString:(NSString*) jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    MPChatThread *chatThread = [MPChatThread fromJSON:data];
    return chatThread;
}


+ (NSString*)toJSONString:(MPChatThread*) thread
{
    NSData *jsonData = [MPChatThread toJSON:thread];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}


- (NSString *) updateThreadWithLastMessage:(MPChatMessage*)message increaseUnreadCountBy:(NSUInteger)unReadCount
{
    self.lastMessage = message;
    self.unread_message_count = [NSNumber numberWithUnsignedLong:[self.unread_message_count integerValue] + unReadCount];
    return nil;
}

@end
