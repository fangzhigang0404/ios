//
//  MPChatHomeStylerCloudfiles.h
//  MarketPlace
//
//  Created by Manish Agrawal on 25/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

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
