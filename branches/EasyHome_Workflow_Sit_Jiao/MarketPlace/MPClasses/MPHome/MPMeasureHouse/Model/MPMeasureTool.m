/**
 * @file    MPMeasureTool.m
 * @brief   the tool for measure.
 * @author  niu
 * @version 1.0
 * @date    2015-03-24
 */

#import "MPMeasureTool.h"

@implementation MPMeasureTool

+ (void)saveMeasureSuccessInfo {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"measure_success"];
}

+ (BOOL)measureStatusSuccessOrNot {
    NSString *str =  [[NSUserDefaults standardUserDefaults] objectForKey:@"measure_success"];
    BOOL bl = [str isEqualToString:@"1"];
    return bl;
}

+ (void)clearMeasureInfo {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"measure_success"];
}

+ (BOOL)isCurrentDataOverMeasure:(NSInteger)year
                           month:(NSInteger)month
                             day:(NSInteger)day
                            hour:(NSInteger)hour {
    
    NSDictionary *dateDic = [self getCurrentDate];
    NSInteger curYear  = [dateDic[@"year"] integerValue];
    NSInteger curMonth = [dateDic[@"month"] integerValue];
    NSInteger curDay  = [dateDic[@"day"] integerValue];
    NSInteger curHour  = [dateDic[@"hour"] integerValue];
    
    if (curYear > year) {
        return YES;
    } else if (curYear == year) {
        if (curMonth > month) {
            return YES;
        } else if (curMonth == month) {
            if (curDay > day) {
                return YES;
            } else if (curDay == day) {
                if (curHour >= hour) {
                    return YES;
                }
            }
        }
    }
    
    return NO;
}

+ (NSDictionary *)getCurrentDate {

    NSDate *date = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:date];
    
    NSDictionary *dict = @{@"year"  : @([comps year]),
                           @"month" : @([comps month]),
                           @"day"   : @([comps day]),
                           @"hour"  : @([comps hour])
                           };
    NSInteger year=[comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    MPLog(@"%@",[NSString stringWithFormat:@"%ld年%ld月",year,month]);
    MPLog(@"%@",[NSString stringWithFormat:@"%ld%ld%ld",day,[comps hour],[comps minute]]);
    return dict;
}

@end
