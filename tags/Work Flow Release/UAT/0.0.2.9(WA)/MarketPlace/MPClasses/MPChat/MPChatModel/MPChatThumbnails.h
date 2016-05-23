/**
 * @file    MPChatThumbnails.h
 * @brief   Thumbnails model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */
#import <Foundation/Foundation.h>

@interface MPChatThumbnails : NSObject

///thumbnails The thumbnails is array of MPChatThumbnail.
@property (strong, nonatomic) NSMutableArray *thumbnails; // array of MPChatThumbnail
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param data.
 *
 *  @return NSArray.
 */
+ (NSArray*) toFoundationObj:(MPChatThumbnails*)data;

/**
 *  @brief model setvalue from dictionary .
 *
 *  @param fObj.
 *
 *  @return MPChatThumbnails.
 */
+ (MPChatThumbnails*) fromFoundationObj:(NSArray*)fObj;

@end