/**
 * @file    MPChatEntityInfo.h
 * @brief   entity infomation model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */
#import <Foundation/Foundation.h>

@class MPChatEntityData;

@interface MPChatEntityInfo : NSObject

///entity_type The entity_type is entity type.
@property (strong, nonatomic) NSString *entity_type;
///entity_id The entity_id is entity id.
@property (strong, nonatomic) NSString *entity_id;
///entity_data The entity_data is entity data.
@property (strong, nonatomic) MPChatEntityData *entity_data;
///date_submitted The date_submitted is submit date.
@property (strong, nonatomic) NSString *date_submitted;

// these are optional and required only for entity_type = FILE, a little muddy
///x_coordinate.
@property (strong, nonatomic) NSNumber *x_coordinate;
///y_coordinate.
@property (strong, nonatomic) NSNumber *y_coordinate;
///z_coordinate.
@property (strong, nonatomic) NSNumber *z_coordinate;
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param entity .
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatEntityInfo*)entity;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPChatEntityInfo.
 */
+ (MPChatEntityInfo*) fromFoundationObj:(NSDictionary*)dict;


@end
