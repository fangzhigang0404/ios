#import "MPChatEntityInfo.h"
#import "MPChatEntityData.h"

@implementation MPChatEntityInfo

- (id) initWithFoundationObj:(NSDictionary*)entity
{
    self = [super init];
    
    if (self)
    {
        if (entity)
        {
            self.entity_type = [entity objectForKey:@"entity_type"];
            self.entity_id = [entity objectForKey:@"entity_id"];
            self.entity_data = [MPChatEntityData fromFoundationObj:[entity objectForKey:@"entity_data"]];
            self.date_submitted = [entity objectForKey:@"date_submitted"];
            
            if ([self isFileEntity:self.entity_type])
            {
                self.x_coordinate = [entity objectForKey:@"x_coordinate"];
                self.y_coordinate = [entity objectForKey:@"y_coordinate"];
                self.z_coordinate = [entity objectForKey:@"z_coordinate"];
            }
        }
    }
    
    return self;
}


- (BOOL) isFileEntity:(NSString*)entity_type
{
    return [entity_type isEqualToString:@"FILE"];
}


+ (NSDictionary*) toFoundationObj:(MPChatEntityInfo*)entity
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:entity.entity_type forKey:@"entity_type"];
    [dict setValue:entity.entity_id forKey:@"entity_id"];
    [dict setValue:[MPChatEntityData toFoundationObj:entity.entity_data] forKey:@"entity_data"];
    [dict setValue:entity.date_submitted forKey:@"date_submitted"];
    
    NSString *entity_type = entity.entity_type;
    if ([entity_type isEqualToString:@"FILE"])
    {
        [dict setValue:entity.x_coordinate forKey:@"x_coordinate"];
        [dict setValue:entity.y_coordinate forKey:@"y_coordinate"];
        [dict setValue:entity.z_coordinate forKey:@"z_coordinate"];
    }
    
    return dict;
}


+ (MPChatEntityInfo*) fromFoundationObj:(NSDictionary*)dict;
{
    MPChatEntityInfo *chatEntity = [[MPChatEntityInfo alloc] initWithFoundationObj:dict];
    return chatEntity;
}

@end

