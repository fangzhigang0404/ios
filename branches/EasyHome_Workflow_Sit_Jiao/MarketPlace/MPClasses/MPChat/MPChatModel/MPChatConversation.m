#import "MPChatConversation.h"
#import "MPChatMessage.h"

@implementation MPChatConversation

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict)
        {
            self.thread_id = [dict objectForKey:@"thread_id"];
            self.total_message_count = [dict objectForKey:@"total_message_count"];
            self.unread_message_count = [dict objectForKey:@"unread_message_count"];
            self.date_submitted = [dict objectForKey:@"date_submitted"];
            self.latest_message = [MPChatMessage fromFoundationObj:[dict objectForKey:@"latest_message"]];
            
            self.x_coordinate = [dict objectForKey:@"x_coordinate"];
            self.y_coordinate = [dict objectForKey:@"y_coordinate"];
            self.z_coordinate = [dict objectForKey:@"z_coordinate"];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatConversation*)conversation
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:conversation.thread_id forKey:@"thread_id"];
    [dict setValue:conversation.total_message_count forKey:@"total_message_count"];
    [dict setValue:conversation.unread_message_count forKey:@"unread_message_count"];
    [dict setValue:conversation.date_submitted forKey:@"date_submitted"];
    [dict setValue:[MPChatMessage toFoundationObj:conversation.latest_message] forKey:@"latest_message"];
    [dict setValue:conversation.x_coordinate forKey:@"x_coordinate"];
    [dict setValue:conversation.y_coordinate forKey:@"y_coordinate"];
    [dict setValue:conversation.z_coordinate forKey:@"z_coordinate"];
    
    return dict;
}


+ (MPChatConversation*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatConversation* con = [[MPChatConversation alloc] initWithFoundationObj:dict];
    return con;
}

@end
