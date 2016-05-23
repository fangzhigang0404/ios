#import "MPChatUser.h"
#import "MPChatUtility.h" 


@implementation MPChatUser

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict)
        {
            
            self.name = [dict objectForKey:@"name"];
//            self.us_uid=[MPChatUtility getUserHs_Uid:self.name ];
            //self.us_uid=@"c6efcfee-dfa2-475e-9f03-f943324a1a98";
            
            self.user_id = [[dict objectForKey:@"id"] stringValue];
            self.profile_image = [dict objectForKey:@"profile_image"];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatUser*)user
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:user.name forKey:@"name"];
    [dict setValue:user.user_id forKey:@"id"];
    [dict setValue:user.profile_image forKey:@"profile_image"];

    return dict;
}


+ (MPChatUser*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatUser* chatuser = [[MPChatUser alloc] initWithFoundationObj:dict];
    return chatuser;
}


@end
