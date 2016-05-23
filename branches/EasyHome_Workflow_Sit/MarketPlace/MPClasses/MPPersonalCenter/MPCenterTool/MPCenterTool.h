/**
 * @file    MPCenterTool.h
 * @brief   the tool of person center.
 * @author  niu
 * @version 1.0
 * @date    2015-04-07
 */

#import <Foundation/Foundation.h>

@class MPMemberModel;
@interface MPCenterTool : NSObject

/**
 *  @brief the method for save person base information, include is_ioho.
 *
 *  @param model the model for member.
 *
 *  @return void nil.
 */
+ (void)savePersonCenterInfo:(MPMemberModel *)model;

/**
 *  @brief the method for get person base information, include is_ioho.
 *
 *  @param nil.
 *
 *  @return MPMemberModel the model of member.
 */
+ (MPMemberModel *)getPersonCenterInfo;

/**
 *  @brief the method for save person real information.
 *
 *  @param audit_status the string for real or not.
 *
 *  @return void nil.
 */
+ (void)saveAuditStatus:(NSString *)audit_status;

/**
 *  @brief the method for get person real information.
 *
 *  @param nil.
 *
 *  @return NSString the string of real information.
 */
+ (NSString *)getAuditStatus;

/**
 *  @brief the method for save nick name when login.
 *
 *  @param nick_name the string for nick name.
 *
 *  @return void nil.
 */
+ (void)saveNickName:(NSString *)nick_name;

/**
 *  @brief the method for get nick name.
 *
 *  @param nil.
 *
 *  @return NSString the string of nick name.
 */
+ (NSString *)getNickName;

/**
 *  @brief the method for get loho.
 *
 *  @param nil.
 *
 *  @return NSString the string of loho.
 */
+ (NSString *)getIsLoho;

/**
 *  @brief the method for set button image.
 *
 *  @param btn the button need to setting image.
 *
 *  @param netAvator the string of avator.
 *
 *  @return void nil.
 */
+ (void)setHeadIcon:(UIButton *)btn
             avator:(NSString *)netAvator;

@end
