/**
 * @file    MPChatHomeStylerCloudfiles.h
 * @brief   cloud files model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <Foundation/Foundation.h>

@interface MPChatHomeStylerCloudfiles : NSObject

///files The files is array of MPChatHomeStylerCloudfile.
@property (strong, nonatomic) NSMutableArray *files; // array of MPChatHomeStylerCloudfile
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param files.
 *
 *  @return NSArray array.
 */
+ (NSArray*) toFoundationObj:(MPChatHomeStylerCloudfiles*)files;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param array.
 *
 *  @return MPChatHomeStylerCloudfiles.
 */
+ (MPChatHomeStylerCloudfiles*) fromFoundationObj:(NSArray*)array;


@end
