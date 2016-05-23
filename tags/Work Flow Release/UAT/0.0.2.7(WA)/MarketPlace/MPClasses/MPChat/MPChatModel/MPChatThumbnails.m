#import "MPChatThumbnails.h"
#import "MPChatThumbnail.h"

@implementation MPChatThumbnails

- (id) initWithFoundationObj:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        self.thumbnails = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPChatThumbnail* thumbnail = [MPChatThumbnail fromFoundationObj:obj];
            [self.thumbnails addObject:thumbnail];
        }
    }
    return self;
}


+ (NSArray*) toFoundationObj:(MPChatThumbnails*)data
{
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [data.thumbnails count]; ++i)
    {
        MPChatThumbnail *thumbnail_ = [data.thumbnails objectAtIndex:i];
        NSDictionary *thumbnail = [MPChatThumbnail toFoundationObj:thumbnail_];
        [fArray addObject:thumbnail];
    }
    
    return fArray;
    
}


+ (MPChatThumbnails*) fromFoundationObj:(NSArray*)fObj
{
    MPChatThumbnails *thumbnails = [[MPChatThumbnails alloc] initWithFoundationObj:fObj];
    return thumbnails;
}


@end
