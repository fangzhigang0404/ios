//
//  MPProjectMaterials.m
//  MarketPlace
//
//  Created by Manish Agrawal on 26/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPProjectMaterials.h"
#import "MPProjectMaterial.h"

@implementation MPProjectMaterials

- (id) initWithFoundationObj:(NSArray*)array
{
    self = [super init];
    if (self)
    {
        self.materials = [[NSMutableArray alloc] init];
        for (int i = 0; i < [array count]; ++i)
        {
            id obj = [array objectAtIndex:i];
            MPProjectMaterial* entity = [MPProjectMaterial fromFoundationObj:obj];
            [self.materials addObject:entity];
        }
    }
    return self;
}


+ (NSArray*) toFoundationObj:(MPProjectMaterials*)array
{
    NSMutableArray *fArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [array.materials count]; ++i)
    {
        MPProjectMaterial *entity_ = [array.materials objectAtIndex:i];
        NSDictionary *entity = [MPProjectMaterial toFoundationObj:entity_];
        [fArray addObject:entity];
    }
    
    return fArray;
}


+ (MPProjectMaterials*) fromFoundationObj:(NSArray*)array
{
    MPProjectMaterials *entities = [[MPProjectMaterials alloc] initWithFoundationObj:array];
    return entities;
}

@end
