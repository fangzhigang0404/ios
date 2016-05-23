/**
 * @file    MPDateManager.m
 * @brief   the manager of date.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-22
 *
 */

#import "MPStringManager.h"

@implementation MPStringManager

#pragma mark -Deal Date
+ (NSString *)formatMPDate:(NSString *)dateStr {
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    [formatter setDateFormat:@"MMMM dd,yyyy HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:[NSDate date] options:0];
    
    if ([MPStringManager isThisYear:date]) {/// this year.
        if (cmps.day == 0) {/// today.
            if (cmps.hour >= 1) {/// in an hour.
                return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
            }else if(cmps.minute >= 1) {/// out of one minute.
                return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
            }else {/// in minutes.
                return @"刚刚";
            }
        }else if (cmps.day == 1) {/// yesterday
            formatter.dateFormat = @"昨天 HH:mm";
            return [formatter stringFromDate:date];
        }else {
            formatter.dateFormat = @"MM/dd HH:mm";
            return [formatter stringFromDate:date];
        }
    }else {
        formatter.dateFormat = @"yy/MM/dd";
        return [formatter stringFromDate:date];
    }
}

+ (BOOL)isThisYear:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSDateComponents *dateCmps = [calendar components:unit fromDate:date];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

#pragma mark -Deal UnRead
+ (NSString *)formatMPUnread:(id)unReadStr {
    NSInteger unRead = [unReadStr integerValue];
    if (unRead >= 99) {
        return @"99+";
    }else {
        return [NSString stringWithFormat:@"%@",unReadStr];
    }
}
@end
