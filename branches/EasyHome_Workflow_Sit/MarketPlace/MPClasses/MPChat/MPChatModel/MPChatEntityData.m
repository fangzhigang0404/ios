#import "MPChatEntityData.h"
#import "MPChatThumbnails.h"

@implementation MPChatEntityData

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict)
        {
            self.asset_name = [dict objectForKey:@"asset_name"];
            self.asset_id = [dict objectForKey:@"asset_id"];
            self.thumbnails = [MPChatThumbnails fromFoundationObj:[dict objectForKey:@"thumbnails"]];
            self.public_file_url = [dict objectForKey:@"public_file_url"];
            self.workflow_step_name = [dict objectForKey:@"workflow_step_name"];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatEntityData*)entityData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:entityData.asset_name forKey:@"asset_name"];
    [dict setValue:entityData.asset_id forKey:@"asset_id"];
    [dict setValue:[MPChatThumbnails toFoundationObj:entityData.thumbnails] forKey:@"thumbnails"];
    [dict setValue:entityData.public_file_url forKey:@"public_file_url"];
    [dict setValue:entityData.workflow_step_name forKey:@"workflow_step_name"];
    
    return dict;
}


+ (MPChatEntityData*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatEntityData *entityData = [[MPChatEntityData alloc] initWithFoundationObj:dict];
    return entityData;
}


@end
