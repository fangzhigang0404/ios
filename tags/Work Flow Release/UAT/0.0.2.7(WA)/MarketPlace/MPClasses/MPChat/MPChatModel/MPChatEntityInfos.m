#import "MPChatEntityInfos.h"
#import "MPChatEntityInfo.h"

@implementation MPChatEntityInfos

- (id) initWithFoundationObj:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        self.entityInfos = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPChatEntityInfo* info = [MPChatEntityInfo fromFoundationObj:obj];
            [self.entityInfos addObject:info];
        }
    }
    return self;
}


+ (NSArray*) toFoundationObj:(MPChatEntityInfos*)infos
{
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [infos.entityInfos count]; ++i)
    {
        MPChatEntityInfo *infos_ = [infos.entityInfos objectAtIndex:i];
        NSDictionary *infos = [MPChatEntityInfo toFoundationObj:infos_];
        [fArray addObject:infos];
    }
    
    return fArray;
}


+ (MPChatEntityInfos*) fromFoundationObj:(NSArray*)array
{
    MPChatEntityInfos *infos = [[MPChatEntityInfos alloc] initWithFoundationObj:array];
    return infos;
}

@end
