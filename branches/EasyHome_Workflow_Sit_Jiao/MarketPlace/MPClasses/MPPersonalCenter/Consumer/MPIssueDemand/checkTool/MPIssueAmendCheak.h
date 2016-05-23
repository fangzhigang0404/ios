/**
 * @file    MPIssueAmendCheak.h
 * @brief   the view for no needs.
 * @author  niu
 * @version 1.0
 * @date    2016-02-01
 */

#import <Foundation/Foundation.h>

@interface MPIssueAmendCheak : NSObject

/// check name.
+ (BOOL)checkContactsName:(NSString *)name;

/// check phone number.
+ (BOOL)checkContactsMobile:(NSString *)phoneNumber;

/// check renovation budget.
+ (BOOL)checkDesignBudget:(NSString *)designBudget;

/// check renovation budget.
+ (BOOL)checkRenovationBudget:(NSString *)renovationBudget;

/// check houseArea.
+ (BOOL)checkHouseArea:(NSString *)houseArea;

/// check neighbourhoods.
+ (BOOL)checkNeighbourhoods:(NSString *)neighbourhoods;

/// check house type.
+ (BOOL)checkHouseType:(NSString *)houseType;

/// check house size.
+ (BOOL)checkHouseSize:(NSString *)houseSize;

/// check renovation style.
+ (BOOL)checkRenovationStyle:(NSString *)renovationStyle;

/// check address.
+ (BOOL)checkAddress:(NSString *)address;

/// check measureTime.
+ (BOOL)checkMeasureTime:(NSString *)measure;
@end
