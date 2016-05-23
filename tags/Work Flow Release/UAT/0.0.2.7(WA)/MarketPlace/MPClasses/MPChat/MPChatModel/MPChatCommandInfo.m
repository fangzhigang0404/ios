//
//  MPChatCommandMessage.m
//  MarketPlace
//
//  Created by Avinash Mishra on 17/03/16.
//  Copyright © 2016 xuezy. All rights reserved.
//



/*
 {"consumer_id":"20730177","designer_id":"20730178","for_consumer":"量房成果交付","for_designer":"量房成果交付","need_id":"1556175","sender":"designer","sub_node_id":"51"}
 */


#import "MPChatCommandInfo.h"

@implementation MPChatCommandInfo


- (id) initWithFoundationObj:(NSDictionary*)jsonDict
{
    self = [super init];
    
    if (self)
    {
        if (jsonDict)
        {
            self.consumer_id = [jsonDict objectForKey:@"consumer_id"];
            self.designer_id = [jsonDict objectForKey:@"designer_id"];
            self.for_consumer = [jsonDict objectForKey:@"for_consumer"];
            self.for_designer = [jsonDict objectForKey:@"for_designer"];
            self.need_id = [jsonDict objectForKey:@"need_id"];
            self.sender = [jsonDict objectForKey:@"sender"];
            self.sub_node_id = [jsonDict objectForKey:@"sub_node_id"];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatCommandInfo*)commandMessage
{
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setValue:commandMessage.consumer_id forKey:@"consumer_id"];
    [jsonDict setValue:commandMessage.designer_id forKey:@"designer_id"];
    [jsonDict setValue:commandMessage.for_consumer forKey:@"for_consumer"];
    [jsonDict setValue:commandMessage.for_designer forKey:@"for_designer"];
    [jsonDict setValue:commandMessage.need_id forKey:@"need_id"];
    [jsonDict setValue:commandMessage.sender forKey:@"sender"];
    [jsonDict setValue:commandMessage.sub_node_id forKey:@"file_id"];
    
    return jsonDict;
}


+ (MPChatCommandInfo*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatCommandInfo* commandMessage = [[MPChatCommandInfo alloc] initWithFoundationObj:dict];
    return commandMessage;
}


@end
