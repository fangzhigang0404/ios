//
//  MPChatProjectInfo.h
//  MarketPlace
//
//  Created by Manish Agrawal on 26/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPChatProjectInfo : NSObject

/// asset_id The asset_id is asset id.
@property (strong, nonatomic) NSNumber *asset_id;
/// current_step The current_step is current step.
@property (strong, nonatomic) NSString *current_step;
/// current_step_thread The current_step_thread is current step thread.
@property (strong, nonatomic) NSString *current_step_thread;
/// current_subNode The current_subNode is current sub node.
@property (strong, nonatomic) NSString *current_subNode;
/// is_beishu The is_beishu is beishu or not.
@property (assign,nonatomic) BOOL is_beishu;

@property (strong, nonatomic) NSString *workflow_id;

/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param info.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatProjectInfo*)info;
/**
 *  @brief model setvalue from dictionary.
 *
 *  @param dict.
 *
 *  @return MPChatProjectInfo.
 */
+ (MPChatProjectInfo*) fromFoundationObj:(NSDictionary*)dict;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPChatProjectInfo.
 */
+ (MPChatProjectInfo*) fromRawResposnseObj:(NSDictionary*)dict;

@end
