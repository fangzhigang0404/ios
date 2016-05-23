//
//  MPProjectMaterials.h
//  MarketPlace
//
//  Created by Manish Agrawal on 26/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPProjectMaterials : NSObject

///materials The materials is array of MPChatEntity.
@property (strong, nonatomic) NSMutableArray *materials; // array of MPChatEntity
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param entities.
 *
 *  @return NSArray.
 */
+ (NSArray*) toFoundationObj:(MPProjectMaterials*)entities;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param array.
 *
 *  @return MPProjectMaterials.
 */
+ (MPProjectMaterials*) fromFoundationObj:(NSArray*)array;


@end
