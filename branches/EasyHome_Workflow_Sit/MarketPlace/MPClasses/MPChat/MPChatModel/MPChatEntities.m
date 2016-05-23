//
//  MPChatEntities.m
//  MarketPlace
//
//  Created by Manish Agrawal on 10/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPChatEntities.h"
#import "MPChatEntity.h"

@implementation MPChatEntities

- (id) initWithFoundationObj:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        self.entities = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPChatEntity* entity = [MPChatEntity fromFoundationObj:obj];
            [self.entities addObject:entity];
        }
    }
    return self;
}


+ (NSArray*) toFoundationObj:(MPChatEntities*)array
{
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array.entities count]; ++i)
    {
        MPChatEntity *entity_ = [array.entities objectAtIndex:i];
        NSDictionary *entity = [MPChatEntity toFoundationObj:entity_];
        [fArray addObject:entity];
    }
    
    return fArray;
}


+ (MPChatEntities*) fromFoundationObj:(NSArray*)array
{
    MPChatEntities *entities = [[MPChatEntities alloc] initWithFoundationObj:array];
    return entities;
}

@end
