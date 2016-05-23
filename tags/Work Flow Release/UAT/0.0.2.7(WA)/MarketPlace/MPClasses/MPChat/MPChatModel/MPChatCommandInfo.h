/**
 * @file    MPChatCommandInfo.h
 * @brief   command infomation model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <Foundation/Foundation.h>


@interface MPChatCommandInfo : NSObject

/// consumer_id The consumer_id is consumer id.
@property (nonatomic, strong) NSString*         consumer_id;
/// designer_id The designer_id is designer id.
@property (nonatomic, strong) NSString*         designer_id;
/// for_consumer.
@property (nonatomic, strong) NSString*         for_consumer;
/// for_designer.
@property (nonatomic, strong) NSString*         for_designer;
/// need_id The need_id is need id.
@property (nonatomic, strong) NSString*         need_id;
/// sender.
@property (nonatomic, strong) NSString*         sender;
/// sub_node_id The sub_node_id is sub node id.
@property (nonatomic, strong) NSString*         sub_node_id;

/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param user.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatCommandInfo*)user;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param json.
 *
 *  @return MPChatCommandInfo.
 */
+ (MPChatCommandInfo*) fromFoundationObj:(NSDictionary*)json;


@end
