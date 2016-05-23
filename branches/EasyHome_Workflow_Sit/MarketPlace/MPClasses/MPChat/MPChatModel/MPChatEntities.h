//
//  MPChatEntities.h
//  MarketPlace
//
//  Created by Manish Agrawal on 10/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPChatEntities : NSObject

/// entities The entities is array of MPChatEntity.
@property (strong, nonatomic) NSMutableArray *entities; // array of MPChatEntity
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param conversations .
 *
 *  @return NSArray array.
 */
+ (NSArray*) toFoundationObj:(MPChatEntities*)entities;
/**
 *  @brief model setvalue from  dictionary .
 *
 *  @param array .
 *
 *  @return MPChatEntities .
 */
+ (MPChatEntities*) fromFoundationObj:(NSArray*)array;


@end
