//
//  MPSystemMessageModel.h
//  MarketPlace
//
//  Created by xuezy on 16/3/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPSystemMessageModel : MPModel

@property (nonatomic,copy)NSString *body; /// The message content.
@property (nonatomic,copy)NSString *sent_time; /// Send a message of time.
@property (nonatomic,assign)NSInteger needsID;
@property (nonatomic,assign)NSInteger designerID;
@property (nonatomic,assign)NSInteger subNodeID;


///Disassemble the data
-(instancetype)initWithDict:(NSDictionary *)dict;


/**
 * @brief demandWithDict:(NSDictionary *)dict.
 *
 * @param  System message (dictionary).
 *
 * @return System message (dictionary).
**/
+(instancetype)demandWithDict:(NSDictionary *)dict;

/**
 * @brief createStystemMessage:(NSDictionary *)parametDict success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure.
 *
 * @param Application system message.
 *
 * @return System message dictionary.
 **/
+(void)createStystemMessage:(NSDictionary *)parametDict success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure;

@end
