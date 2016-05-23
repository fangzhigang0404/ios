#import <Foundation/Foundation.h>


@interface MPChatRecipients : NSObject

///users The users is array of MPChatUser.
@property (strong, nonatomic) NSMutableArray *users; // array of MPChatUser
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param recipients.
 *
 *  @return NSArray.
 */
+ (NSArray*) toFoundationObj:(MPChatRecipients*)recipients;
/**
 *  @brief model setvalue from array .
 *
 *  @param usersArray.
 *
 *  @return MPChatRecipients.
 */
+ (MPChatRecipients*) fromFoundationObj:(NSArray*)usersArray;

@end