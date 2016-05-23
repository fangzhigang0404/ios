#import "MPChatMessages.h"
#import "MPChatMessage.h"

@implementation MPChatMessages

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    if (self)
    {
        NSArray* array = [dict objectForKey:@"messages"];
        self.messages = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPChatMessage* msg = [MPChatMessage fromFoundationObj:obj];
            [self.messages addObject:msg];
        }
        self.numMessages = [dict objectForKey:@"count"];
        self.offset = [dict objectForKey:@"offset"];
    }
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatMessages*)msgs
{
    NSMutableDictionary *fDict= [[NSMutableDictionary alloc] init];
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [msgs.messages count]; ++i)
    {
        MPChatMessage *msg_ = [msgs.messages objectAtIndex:i];
        NSDictionary *msg = [MPChatMessage toFoundationObj:msg_];
        [fArray addObject:msg];
    }
    
    [fDict setObject:fArray forKey:@"messages"];
    [fDict setObject:msgs.numMessages forKey:@"count"];
    [fDict setObject:msgs.offset forKey:@"offset"];
    return fDict;
}


+ (MPChatMessages*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatMessages *msgs = [[MPChatMessages alloc] initWithFoundationObj:dict];
    return msgs;
}

@end
