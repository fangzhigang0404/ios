//
//  MPProjectMaterial.m
//  MarketPlace
//
//  Created by Manish Agrawal on 26/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPProjectMaterial.h"

@implementation MPProjectMaterial

- (id) initWithFoundationObj:(NSDictionary*)dict
{
    self = [super init];
    
    if (self)
    {
        if (dict)
        {
            self.parameters = [dict objectForKey:@"parameters"];
            self.type = [dict objectForKey:@"type"];
        }
    }
    
    return self;
}


+ (NSDictionary*) toFoundationObj:(MPProjectMaterial*)mat
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:mat.parameters forKey:@"parameters"];
    [dict setValue:mat.type forKey:@"type"];
    
    return dict;
}


+ (MPProjectMaterial*) fromFoundationObj:(NSDictionary*)dict
{
    MPProjectMaterial* mat = [[MPProjectMaterial alloc] initWithFoundationObj:dict];
    return mat;
}

@end
