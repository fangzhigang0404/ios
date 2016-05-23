/**
 * @file    MPChatTestUser.h
 * @brief   test user model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

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
