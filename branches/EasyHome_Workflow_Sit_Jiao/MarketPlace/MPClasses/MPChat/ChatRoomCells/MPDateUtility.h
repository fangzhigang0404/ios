//
//  MPDateUtilities.h
//  MarketPlace
//
//  Created by Avinash Mishra on 12/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPDateUtility : NSObject
/**
 *  @brief check if date change in.
 *
 *  @param date1 The date1 is the date before.
 *  @param date2 The date1 is the date later.
 *
 *  @return BOOL.
 */
+ (BOOL) checkIfDateChangeIn:(NSDate*)date1 toDate:(NSDate*)date2;
/**
 *  @brief formatted time from date for message cell.
 *
 *  @param date.
 *
 *  @return NSString.
 */
+ (NSString*) formattedTimeFromDateForMessageCell:(NSDate*)date;
/**
 *  @brief formatted string from date for message cell.
 *
 *  @param date.
 *
 *  @return NSString.
 */
+ (NSString*) formattedStringFromDateForChatRoom:(NSDate*)date;
/**
 *  @brief formatted string from date for chat list.
 *
 *  @param date.
 *
 *  @return NSString.
 */
+ (NSString*) formattedStringFromDateForChatList:(NSDate*)date;
/**
 *  @brief formatted string from date for message .
 *
 *  @param date.
 *
 *  @return NSString.
 */
+ (NSString*) formattedStringFromDateForMessage:(NSDate*)date;
@end
