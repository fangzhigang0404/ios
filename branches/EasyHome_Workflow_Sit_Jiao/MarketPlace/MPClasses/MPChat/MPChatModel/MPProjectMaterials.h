/**
 * @file    MPProjectMaterials.h
 * @brief   project materials model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

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
