#import "MPChatThreads.h"
#import "MPChatThread.h"

@implementation MPChatThreads

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        NSArray* array = [dict objectForKey:@"threads"];
        self.threads = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPChatThread* thread = [MPChatThread fromFoundationObj:obj];
            [self.threads addObject:thread];
        }
        self.numThreads = [dict objectForKey:@"count"];
    }
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatThreads*)threads
{
    NSMutableDictionary *fDict= [[NSMutableDictionary alloc] init];
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [threads.threads count]; ++i)
    {
        MPChatThread *thread_ = [threads.threads objectAtIndex:i];
        NSDictionary *thread = [MPChatThread toFoundationObj:thread_];
        [fArray addObject:thread];
    }
    
    [fDict setObject:fArray forKey:@"threads"];
    [fDict setObject:threads.numThreads forKey:@"count"];
    return fDict;
}


+ (MPChatThreads*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatThreads *threads = [[MPChatThreads alloc] initWithFoundationObj:dict];
    return threads;
}

@end
