/**
 * @file    MPChatEntities.h
 * @brief   entities model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

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
