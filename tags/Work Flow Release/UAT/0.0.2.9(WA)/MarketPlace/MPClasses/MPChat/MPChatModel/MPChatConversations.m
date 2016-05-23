#import "MPChatConversations.h"
#import "MPChatConversation.h"

@implementation MPChatConversations

- (id) initWithFoundationObj:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        self.conversations = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPChatConversation* con = [MPChatConversation fromFoundationObj:obj];
            [self.conversations addObject:con];
        }
    }
    return self;
}


+ (NSArray*) toFoundationObj:(MPChatConversations*)cons
{
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [cons.conversations count]; ++i)
    {
        MPChatConversation *con_ = [cons.conversations objectAtIndex:i];
        NSDictionary *user = [MPChatConversation toFoundationObj:con_];
        [fArray addObject:user];
    }
    
    return fArray;
}


+ (MPChatConversations*) fromFoundationObj:(NSArray*)obj
{
    MPChatConversations *cons = [[MPChatConversations alloc] initWithFoundationObj:obj];
    return cons;
}


@end
