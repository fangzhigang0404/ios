#import "MPChatEntity.h"
#import "MPChatConversations.h"
#import "MPChatEntityData.h"

@implementation MPChatEntity

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict)
        {
            self.entity_type = [dict objectForKey:@"entity_type"];
            self.entity_id = [dict objectForKey:@"entity_id"];
            self.conversations = [MPChatConversations fromFoundationObj:[dict objectForKey:@"conversations"]];
            self.entity_data = [MPChatEntityData fromFoundationObj:[dict objectForKey:@"entity_data"]];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatEntity*)entity
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:entity.entity_type forKey:@"entity_type"];
    [dict setValue:entity.entity_id forKey:@"entity_id"];
    [dict setValue:[MPChatConversations toFoundationObj:entity.conversations] forKey:@"conversations"];
    [dict setValue:[MPChatEntityData toFoundationObj:entity.entity_data] forKey:@"entity_data"];
    
    return dict;
}


+ (MPChatEntity*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatEntity* entity = [[MPChatEntity alloc] initWithFoundationObj:dict];
    return entity;
}

@end
