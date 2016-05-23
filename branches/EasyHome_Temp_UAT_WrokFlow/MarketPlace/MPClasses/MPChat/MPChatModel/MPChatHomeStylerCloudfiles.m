//
//  MPChatHomeStylerCloudfiles.m
//  MarketPlace
//
//  Created by Manish Agrawal on 25/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPChatHomeStylerCloudfiles.h"
#import "MPChatHomeStylerCloudfile.h"

@implementation MPChatHomeStylerCloudfiles
- (id) initWithFoundationObj:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        self.files = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPChatHomeStylerCloudfile* entity = [MPChatHomeStylerCloudfile fromFoundationObj:obj];
            [self.files addObject:entity];
        }
    }
    return self;
}


+ (NSArray*) toFoundationObj:(MPChatHomeStylerCloudfiles*)array
{
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array.files count]; ++i)
    {
        MPChatHomeStylerCloudfile *entity_ = [array.files objectAtIndex:i];
        NSDictionary *entity = [MPChatHomeStylerCloudfile toFoundationObj:entity_];
        [fArray addObject:entity];
    }
    
    return fArray;
}


+ (MPChatHomeStylerCloudfiles*) fromFoundationObj:(NSArray*)array
{
    MPChatHomeStylerCloudfiles *entities = [[MPChatHomeStylerCloudfiles alloc] initWithFoundationObj:array];
    return entities;
}

@end
