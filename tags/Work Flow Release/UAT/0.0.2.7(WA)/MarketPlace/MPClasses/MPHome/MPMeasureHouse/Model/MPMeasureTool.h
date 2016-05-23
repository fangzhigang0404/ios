/**
 * @file    MPMeasureTool.h
 * @brief   the tool for measure.
 * @author  niu
 * @version 1.0
 * @date    2015-03-24
 */

#import <Foundation/Foundation.h>

@interface MPMeasureTool : NSObject

/**
 *  @brief the method for judge measure time.
 *
 *  @param year choose year.
 *
 *  @param month choose month.
 *
 *  @param day choose day.
 *
 *  @param hour choose hour.
 *
 *  @return void nil.
 */
+ (BOOL)isCurrentDataOverMeasure:(NSInteger)year
                           month:(NSInteger)month
                             day:(NSInteger)day
                            hour:(NSInteger)hour;

/**
 *  @brief the method for save measure success info.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
+ (void)saveMeasureSuccessInfo;

/**
 *  @brief the method for clean measure info.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
+ (void)clearMeasureInfo;

/**
 *  @brief the method for judge measure success or not.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
+ (BOOL)measureStatusSuccessOrNot;

/**
 *  @brief the method for get current date.
 *
 *  @param nil.
 *
 *  @return NSDictionary the date dictionary.
 */
+ (NSDictionary *)getCurrentDate;

@end
