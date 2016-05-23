/**
 * @file    MPDateManager.h
 * @brief   the manager of date.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-22
 *
 */

#import <Foundation/Foundation.h>

@interface MPStringManager : NSObject
/**
 *  @brief turn the server's time to custom'time.
 *
 *  @param dateStr the string of time from server.
 *
 *  @return NSString the string of time with custom.
 */
+ (NSString *)formatMPDate:(NSString *)dateStr;

/**
 *  @brief deal the number of unread.
 *
 *  @param unReadStr the unRead number of server.
 *
 *  @return NSString the string of deal.
 */
+ (NSString *)formatMPUnread:(NSString *)unReadStr;
@end
