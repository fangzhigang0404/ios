/**
 * @file    MPProjectMaterial.h
 * @brief   project material model.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <Foundation/Foundation.h>

@interface MPProjectMaterial : NSObject

/// parameters The parameters is dictionary or array.
@property (strong, nonatomic) id parameters; //dictionary or array
/// type.
@property (strong, nonatomic) NSNumber *type;
/**
 *  @brief dictionary setvalue from  model .
 *
 *  @param user.
 *
 *  @return NSDictionary.
 */
+ (NSDictionary*) toFoundationObj:(MPProjectMaterial*)user;
/**
 *  @brief model setvalue from dictionary .
 *
 *  @param dict.
 *
 *  @return MPProjectMaterial.
 */
+ (MPProjectMaterial*) fromFoundationObj:(NSDictionary*)dict;

@end
