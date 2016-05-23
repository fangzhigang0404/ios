//
//  MPChatHomeStylerCloudfile.h
//  MarketPlace
//
//  Created by Manish Agrawal on 25/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPChatHomeStylerCloudfile : NSObject

///uid.
@property (strong, nonatomic) NSNumber *uid;
///name.
@property (strong, nonatomic) NSString *name;
///url.
@property (strong, nonatomic) NSString *url;
///thumbnail.
@property (strong, nonatomic) NSString *thumbnail;
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param user.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatHomeStylerCloudfile*)user;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict .
 *
 *  @return MPChatHomeStylerCloudfile.
 */
+ (MPChatHomeStylerCloudfile*) fromFoundationObj:(NSDictionary*)dict;


@end
