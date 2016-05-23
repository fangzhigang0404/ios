#import "MPChatRecipients.h"
#import "MPChatUser.h"

@implementation MPChatRecipients

- (id) initWithFoundationObj:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        self.users = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPChatUser* chatUser = [MPChatUser fromFoundationObj:obj];
            [self.users addObject:chatUser];
        }
    }
    return self;
}


+ (NSArray*) toFoundationObj:(MPChatRecipients*)recipients
{
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [recipients.users count]; ++i)
    {
        MPChatUser *user_ = [recipients.users objectAtIndex:i];
        NSDictionary *user = [MPChatUser toFoundationObj:user_];
        [fArray addObject:user];
    }
    
    return fArray;
}


+ (MPChatRecipients*) fromFoundationObj:(NSArray*)usersArray
{
    MPChatRecipients *recipients = [[MPChatRecipients alloc] initWithFoundationObj:usersArray];
    return recipients;
}


@end
