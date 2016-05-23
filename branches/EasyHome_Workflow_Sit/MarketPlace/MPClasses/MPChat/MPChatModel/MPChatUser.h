#import <Foundation/Foundation.h>

@interface MPChatUser : NSObject

/// name.
@property (strong, nonatomic) NSString *name;
/// user_id The user_id is user id.
@property (strong, nonatomic) NSString *user_id;
/// profile_image The profile_image is profile image.
@property (strong, nonatomic) NSString *profile_image;
//@property (strong, nonatomic) NSString *us_uid;
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param user.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPChatUser*)user;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPChatUser.
 */
+ (MPChatUser*) fromFoundationObj:(NSDictionary*)dict;

@end
