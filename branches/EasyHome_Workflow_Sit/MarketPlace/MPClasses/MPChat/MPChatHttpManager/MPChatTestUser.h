//
//  MPChatTestUser.h
//  MarketPlace
//
//  Created by Manish Agrawal on 10/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPChatTestUser : NSObject

@property (strong, nonatomic) NSString* memberId;
@property (strong, nonatomic) NSString* session;
@property (strong, nonatomic) NSString* secureSession;
@property (strong, nonatomic) NSString* threadId;
@property (strong, nonatomic) NSString* fileId;

/**
 *  @brief Singleton of MPChatTestUser.
 *
 *  @return MPChatTestUser.
 */
+ (MPChatTestUser*) sharedInstance;


@end
