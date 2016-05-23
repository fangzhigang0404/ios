/**
 * @file    MPMeasureModelToDict.h
 * @brief   the tool of create request body.
 * @author  niu
 * @version 1.0
 * @date    2015-03-24
 */

#import <Foundation/Foundation.h>

@class MPDecorationNeedModel;
@interface MPMeasureModelToDict : NSObject

/**
 *  @brief the method for create request body.
 *
 *  @param model the model for decoration.
 *
 *  @param date the date for measure time.
 *
 *  @param designer_id the id for designer.
 *
 *  @param measurePrice the price for measure.
 *
 *  @param hs_uid the string for designer uid.
 *
 *  @return void nil.
 */
+ (NSDictionary *)getMeasureBodyWithModel:(MPDecorationNeedModel *)model
                              measureDate:(NSString *)date
                               designerId:(NSString *)designer_id
                              mesurePrice:(NSString *)measurePrice
                                   hs_uid:(NSString *)hs_uid
                                 threadID:(NSString *)thread_id;


@end
