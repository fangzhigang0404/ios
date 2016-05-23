/**
 * @file    MPDesignerDetailViewController.h
 * @brief   the controller of designer detail.
 * @author  niu
 * @version 1.0
 * @date    2016-01-26
 */

#import "MPBaseViewController.h"

@class MPDesignerInfoModel;
@class MPDecorationNeedModel;
@interface MPDesignerDetailViewController : MPBaseViewController

/**
 *  @brief the method for instancetype.
 *
 *  @param isDesignerPersonCenter the bool for come from person center or not.
 *
 *  @param model the model for designer.
 *
 *  @param isConsumerNeeds the bool for come from consumerNeeds.
 *
 *  @param needModel the model for decoration.
 *
 *  @param index the index for designer in bidders.
 *
 *  @return void nil.
 */
- (instancetype)initWithIsDesignerCenter:(BOOL)isDesignerPersonCenter
                       designerInfoModel:(MPDesignerInfoModel *)model
                         isConsumerNeeds:(BOOL)isConsumerNeeds
                                needInfo:(MPDecorationNeedModel *)needModel
                           needInfoIndex:(NSInteger)index;

/// the block for measure.
@property (nonatomic, copy) void (^success)();

/// chat room id.
@property (nonatomic, copy) NSString *thread_id;

@end
