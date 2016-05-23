//
//  MPDateUtilities.m
//  MarketPlace
//
//  Created by Avinash Mishra on 12/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPDateUtility.h"

@implementation MPDateUtility

+ (NSLocale *) getPreferredLocale
{
    NSLocale *prefferedLanguageLocale = [NSLocale localeWithLocaleIdentifier:[[[NSBundle mainBundle] preferredLocalizations] firstObject]];
    
    if (!prefferedLanguageLocale)
        prefferedLanguageLocale = [NSLocale currentLocale];
    
    return prefferedLanguageLocale;
}

+ (NSString*) formattedTimeFromDate:(NSDate*)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSString *localeFormatString = [NSDateFormatter dateFormatFromTemplate:@"HH:mm" options:0 locale:[self getPreferredLocale]];
    [format setDateFormat:localeFormatString];
    [format setTimeStyle:NSDateFormatterShortStyle];
    NSString *timeString = [format stringFromDate:date];
    return timeString;
}


+ (NSString*) formattedDateFromDate:(NSDate*)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSString *localeFormatString = [NSDateFormatter dateFormatFromTemplate:@"MM/dd" options:0 locale:[self getPreferredLocale]];
    [format setDateStyle:NSDateFormatterShortStyle];
    [format setDateFormat:localeFormatString];
    
    NSString *timeString = [format stringFromDate:date];
    return timeString;
}


+ (NSString*) formattedTimeFromDateForMessageCell:(NSDate*)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSString *localeFormatString = [NSDateFormatter dateFormatFromTemplate:@"HH:mm" options:0 locale:[self getPreferredLocale]];
    [format setDateFormat:localeFormatString];
    [format setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *timeString = [format stringFromDate:date];
    return timeString;
}
+ (NSString*) formattedDateFromDateForMessage:(NSDate*)date
{
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    NSString *timeString= [outputFormatter stringFromDate:date];
    
    
    return timeString;
}


+ (NSString*) formattedStringFromDateForChatRoom:(NSDate*)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSString *localeFormatString = [NSDateFormatter dateFormatFromTemplate:@"MMM dd yyy" options:0 locale:[self getPreferredLocale]];
    
    [format setDateFormat:localeFormatString];
    
    NSString *timeString = [format stringFromDate:[NSDate date]];
    NSDate *  todayDate = [format dateFromString:timeString];
    NSTimeInterval interval = [date timeIntervalSinceDate:todayDate];
    if (interval > 0)
        return NSLocalizedString(@"Today", @"Today");
    else if (interval > -24 * 60 * 60)
        return NSLocalizedString(@"Yesterday", @"Yesterday");
    else
        return [self formattedDateFromDate:date];
}


+ (NSString*) formattedStringFromDateForChatList:(NSDate*)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    NSString *localeFormatString = [NSDateFormatter dateFormatFromTemplate:@"MMM dd yyy" options:0 locale:[self getPreferredLocale]];
    
    [format setDateFormat:localeFormatString];
    
    NSString *timeString = [format stringFromDate:[NSDate date]];
    NSDate *  todayDate = [format dateFromString:timeString];
    NSTimeInterval interval = [date timeIntervalSinceDate:todayDate];
    if (interval > 0)
        return [self formattedTimeFromDate:date];
    else if (interval > -24 * 60 * 60)
        return NSLocalizedString(@"Yesterday", @"Yesterday");
    else
        return [self formattedDateFromDate:date];
}


+ (NSString*) formattedStringFromDateForMessage:(NSDate*)date
{
    return [self formattedDateFromDateForMessage:date];
}



+ (BOOL) checkIfDateChangeIn:(NSDate*)date1 toDate:(NSDate*)date2
{
    NSDateComponents *otherDay = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date1];
    NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date2];
    return (!([today day] == [otherDay day] &&
              [today month] == [otherDay month] &&
              [today year] == [otherDay year] &&
              [today era] == [otherDay era]));
}


@end
