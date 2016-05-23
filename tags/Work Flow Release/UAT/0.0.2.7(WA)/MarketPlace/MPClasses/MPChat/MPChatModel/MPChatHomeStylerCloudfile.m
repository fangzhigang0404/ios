//
//  MPChatHomeStylerCloudfile.m
//  MarketPlace
//
//  Created by Manish Agrawal on 25/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPChatHomeStylerCloudfile.h"

@implementation MPChatHomeStylerCloudfile

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict)
        {
            self.uid = [dict objectForKey:@"id"];
            self.name = [dict objectForKey:@"name"];
            self.url = [dict objectForKey:@"url"];
            self.thumbnail = [dict objectForKey:@"file_thumbnail"];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatHomeStylerCloudfile*)user
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:user.uid forKey:@"id"];
    [dict setValue:user.name forKey:@"name"];
    [dict setValue:user.url forKey:@"url"];
    [dict setValue:user.thumbnail forKey:@"file_thumbnail"];
    
    return dict;
}


+ (MPChatHomeStylerCloudfile*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatHomeStylerCloudfile* chatuser = [[MPChatHomeStylerCloudfile alloc] initWithFoundationObj:dict];
    return chatuser;
}
@end
