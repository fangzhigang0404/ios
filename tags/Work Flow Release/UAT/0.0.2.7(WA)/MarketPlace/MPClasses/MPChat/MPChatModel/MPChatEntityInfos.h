/**
 * @file    MPChatEntityInfos.h
 * @brief   entity infomations model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */
#import <Foundation/Foundation.h>

@interface MPChatEntityInfos : NSObject

/// entityInfos The entityInfos is array of MPChatEntityInfo.
@property (strong, nonatomic) NSMutableArray *entityInfos; // array of MPChatEntityInfo
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param entityInfos.
 *
 *  @return NSArray array.
 */
+ (NSArray*) toFoundationObj:(MPChatEntityInfos*)entityInfos;

/**
 *  @brief model setvalue from dictionary .
 *
 *  @param array.
 *
 *  @return MPChatEntityInfos .
 */
+ (MPChatEntityInfos*) fromFoundationObj:(NSArray*)array;

@end
