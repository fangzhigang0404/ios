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
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;

+ (NSArray *)getScheduleData;

+ (void)flashWithStatus:(MPStatusModel *)statusModel
             andSuccess:(void(^)(NSInteger nodeID, NSInteger flashID))success;
@end
