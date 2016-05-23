#import "MPChatThumbnail.h"

@implementation MPChatThumbnail

- (id) initWithFoundationObj:(NSDictionary*)jsonDict
{
    self = [super init];
    
    if (self)
    {
        if (jsonDict)
        {
            self.caption = [jsonDict objectForKey:@"caption"];
            self.desc = [jsonDict objectForKey:@"desc"];
            self.file_id = [jsonDict objectForKey:@"file_id"];
            self.thumb_path_prefix = [jsonDict objectForKey:@"thumb_path_prefix"];
            
            NSNumber* isPrimary = [jsonDict objectForKey:@"is_primary"];
            self.is_primary = [isPrimary boolValue];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatThumbnail*)thumbnail
{
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:thumbnail.caption forKey:@"caption"];
    [jsonDict setValue:thumbnail.desc forKey:@"desc"];
    [jsonDict setValue:thumbnail.file_id forKey:@"file_id"];
    [jsonDict setValue:thumbnail.thumb_path_prefix forKey:@"thumb_path_prefix"];

    NSNumber *isPrimary = [NSNumber numberWithBool:thumbnail.is_primary];
    [jsonDict setValue:isPrimary forKey:@"is_primary"];

    return jsonDict;
}


+ (MPChatThumbnail*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatThumbnail* thumb = [[MPChatThumbnail alloc] initWithFoundationObj:dict];
    return thumb;
}

@end
