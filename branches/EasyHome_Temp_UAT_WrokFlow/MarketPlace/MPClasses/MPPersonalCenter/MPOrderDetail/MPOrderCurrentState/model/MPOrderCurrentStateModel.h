/**
 * @file    MPOrderCurrentStateModel.h
 * @brief   the model of current asset status.
 * @author  Jiao
 * @version 1.0
 * @date    2016-01-27
 *
 */

#import <Foundation/Foundation.h>

@class MPStatusModel;
@interface MPOrderCurrentStateModel : NSObject

/// the name of image.
@property (nonatomic, copy) NSString *imageName;

/// the title of node.
@property (nonatomic, copy) NSString *title;

/// the detail title of node.
@property (nonatomic, copy) NSString *detailTitle;

/**
 *  @brief get data from plist.
 *
 *  @return MPOrderCurrentStateModels.
 */
+ (NSArray *)getScheduleData;

/**
 *  @brief get the n and flash ID
 *
 *  @param statusModel the model of order.
 *
 *  @return success the back block of success with node ID and flash ID.
 */
+ (void)flashWithStatus:(MPStatusModel *)statusModel
             andSuccess:(void(^)(NSInteger nodeID, NSInteger flashID))success;
@end
