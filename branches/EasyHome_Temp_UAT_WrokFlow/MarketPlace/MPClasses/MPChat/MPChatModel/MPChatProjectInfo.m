//
//  MPChatProjectInfo.m
//  MarketPlace
//
//  Created by Manish Agrawal on 26/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPChatProjectInfo.h"

@implementation MPChatProjectInfo

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict)
        {
            self.asset_id = [dict objectForKey:@"asset_id"];
            self.current_step = [dict objectForKey:@"current_step"];
            self.current_step_thread = [dict objectForKey:@"current_step_thread"];
            self.current_subNode = [dict objectForKey:@"current_subNode"];
            self.is_beishu = ![[dict objectForKey:@"is_beishu"] boolValue];
            self.workflow_id = [dict objectForKey:@"workflow_id"];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPChatProjectInfo*)info
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:info.asset_id forKey:@"asset_id"];
    [dict setValue:info.current_step forKey:@"current_step"];
    [dict setValue:info.current_step_thread forKey:@"current_step_thread"];
    [dict setValue:info.current_subNode forKey:@"current_subNode"];
    [dict setValue:info.workflow_id forKey:@"workflow_id"];
    
    return dict;
}


+ (MPChatProjectInfo*) fromFoundationObj:(NSDictionary*)dict
{
    MPChatProjectInfo* info = [[MPChatProjectInfo alloc] initWithFoundationObj:dict];
    return info;
}

+ (MPChatProjectInfo*) fromRawResposnseObj:(NSDictionary*)res
{
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    if (res)
    {
        [dict setObject:[res objectForKey:@"needs_id"] forKey:@"asset_id"];
        [dict setObject:res[@"is_beishu"] forKey:@"is_beishu"];
        ///-----------------------------------------------------------------------------
        /// if it is beishu, get the @"beishu_thread_id"  temporary
        if (![res[@"is_beishu"] boolValue]) {
            if (![res[@"beishu_thread_id"] isKindOfClass:[NSNull class]])
                [dict setObject:res[@"beishu_thread_id"] forKey:@"current_step_thread"];
            
            return [MPChatProjectInfo fromFoundationObj:dict];
        }
        ///-----------------------------------------------------------------------------
        NSArray* bidders = [res objectForKey:@"bidders"];
        NSDictionary* bidder = [bidders objectAtIndex:0];
        
        if (bidder && ![bidder isKindOfClass:[NSNull class]])
        {
            NSString* currentStep = [bidder objectForKey:@"wk_current_step_id"];
            [dict setObject:currentStep forKey:@"current_step"];
            
            NSString* workflowId = [bidder objectForKey:@"wk_id"];
            [dict setObject:workflowId forKey:@"workflow_id"];
            
            NSString *currentSubNodeID = [NSString stringWithFormat:@"%@",[bidder objectForKey:@"wk_cur_sub_node_id"]];
            [dict setObject:currentSubNodeID forKey:@"current_subNode"];
            
            NSArray* steps = [bidder objectForKey:@"wk_steps"];
            
            for (int i =0; i < [steps count]; ++i)
            {
                NSDictionary* step = steps[i];
                NSNumber* stepId = [step objectForKey:@"wk_step_id"];
                if ([stepId integerValue] == [currentStep integerValue])
                {
                    NSString* currentthread = [step objectForKey:@"thread_id"];
                    if (![currentthread isKindOfClass:[NSNull class]])
                        [dict setObject:currentthread forKey:@"current_step_thread"];
                    break;
                }
            }
        }
    }
    
    return [MPChatProjectInfo fromFoundationObj:dict];
}

@end
