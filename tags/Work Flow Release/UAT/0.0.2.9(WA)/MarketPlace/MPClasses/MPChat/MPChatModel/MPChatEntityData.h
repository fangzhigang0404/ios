/**
 * @file    MPChatEntityData.h
 * @brief   entity data model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <Foundation/Foundation.h>

@class MPChatThumbnails;

@interface MPChatEntityData : NSObject

///asset_name The asset_name is asset name.
@property (strong, nonatomic) NSString *asset_name;
///asset_id The asset_id is asset id.
@property (strong, nonatomic) NSNumber *asset_id;
///thumbnails The thumbnails is array of MPChatThumbnail.
@property (strong, nonatomic) MPChatThumbnails *thumbnails; // array of MPChatThumbnail
///public_file_url The public_file_url is public file uerl.
@property (strong, nonatomic) NSString *public_file_url;
///workflow_step_name The workflow_step_name is workflow step name.
@property (strong, nonatomic) NSString *workflow_step_name;

/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param user.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatEntityData*)user;
/**
 *  @brief model setvalue from dictionary . 
 *
 *  @param json.
 *
 *  @return MPChatEntityData.
 */
+ (MPChatEntityData*) fromFoundationObj:(NSDictionary*)json;

@end
