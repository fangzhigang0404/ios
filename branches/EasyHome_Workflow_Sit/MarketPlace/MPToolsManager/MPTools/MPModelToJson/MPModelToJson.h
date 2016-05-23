/**
 * @file    MPModelToJson.h
 * @brief   deal the object to dictionary or json.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-22
 *
 */

#import <Foundation/Foundation.h>

@interface MPModelToJson : NSObject

/**
 *  @brief turn the object to Dictionary.
 *
 *  @param obj the object.
 *
 *  @return Nsdictionary the dictionary of object.
 */
+ (NSDictionary *)getObjectData:(id)obj;

/**
 *  @brief turn the object to the data of Json.
 *
 *  @param obj the object.
 *
 *  @param error the error of turning.
 *
 *  @return NSData the Json of object.
 */
+ (NSData *)getJSON:(id)obj error:(NSError **)error;
@end
