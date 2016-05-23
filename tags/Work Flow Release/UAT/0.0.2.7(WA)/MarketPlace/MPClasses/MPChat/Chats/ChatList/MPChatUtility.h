/**
 * @file    MPChatUtility.h
 * @brief   Chat utility.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <Foundation/Foundation.h>

#define Default_UserImage   @"default_avatar.png"
//#define Default_SystemUserName   @"居然之家"
//#define Default_SystemUserName   @"EZHome-Admin"

 
@class MPChatUser;
@class MPChatThread;

@interface MPChatUtility : NSObject
/**
 *  @brief get user info.
 *
 *  @param thread .
 *  @param loggedInUserId The string is logged in user id.
 *
 *  @return MPChatUser.
 */
+ (MPChatUser*) getComplimentryUserFromThread:(MPChatThread*)thread withLoginUserId:(NSString*)loggedInUserId;
/**
 *  @brief get image url for photo of the user.
 *
 *  @param thread The thread info of the user.
 *
 *  @return NSString imageURL.
 */
+ (NSString*) getFileUrlFromThread:(MPChatThread*) thread;
/**
 *  @brief get work flow step name.
 *
 *  @param thread The thread info of the user.
 *
 *  @return NSString.
 */
+ (NSString*) getWorkflowStepNameFromThread:(MPChatThread*) thread;
/**
 *  @brief get asset name.
 *
 *  @param thread The thread info of the user.
 *
 *  @return NSString.
 */
+ (NSString*) getAssetNameFromThread:(MPChatThread*) thread;
/**
 *  @brief get asset id.
 *
 *  @param thread The thread info of the user.
 *
 *  @return NSString.
 */
+ (NSString*) getAssetIdFromThread:(MPChatThread*) thread;
/**
 *  @brief get file entity id.
 *
 *  @param thread The thread info of the user.
 *
 *  @return NSString.
 */
+ (NSString*) getFileEntityIdForThread:(MPChatThread*) thread;
/**
 *  @brief get work flow id.
 *
 *  @param thread The thread info of the user.
 *
 *  @return NSString.
 */
+ (NSString*) getWorkflowIdForThread:(MPChatThread*) thread;
/**
 *  @brief get user display name.
 *
 *  @param user The user is a model with info.
 *
 *  @return NSString name.
 */
+ (NSString*) getUserDisplayNameFromUser:(NSString*) userName;
/**
 *  @brief analyze avatar image is default image or not.
 *
 *  @param userProfileImage The userProfileImage is the uer profile image url.
 *
 *  @return BOOL.
 */
+ (BOOL) isAvatarImageIsDefaultForUser:(NSString*) userProfileImage;
/**
 *  @brief analyze thread is system thread or not.
 *
 *  @param thread_id The string thread_id is the thread id of the chatroom.
 *
 *  @return BOOL.
 */
+ (BOOL) isSystemThread:(NSString *)thread_id;
/**
 *  @brief get system thread user name.
 *
 *  @param thread_id The string thread_id is the thread of the chatroom.
 *  @param defaultName The string defaultName is the system user default name.
 *
 *  @return NSString defaultName.
 */
+ (NSString*) getSystemThreaduserName:(NSString *)thread_id withDefault:(NSString*)defaultName;
/**
 *  @brief get user hs_uid.
 *
 *  @param name The hs_uid is conponent of name.
 *
 *  @return NSString.
 */
+ (NSString*) getUserHs_Uid:(NSString *)name;
/**
 *  @brief get user hs_uid.
 *
 *  @param thread The thread info of the user.
 *  @param AcsId The string AcsId getted when member logged in.
 *
 *  @return MPChatUser.
 */
+ (MPChatUser*) getThreadDesignerHomeStyleIdFromThread:(MPChatThread*)thread withAcsId:(NSString*)AcsId;

@end
