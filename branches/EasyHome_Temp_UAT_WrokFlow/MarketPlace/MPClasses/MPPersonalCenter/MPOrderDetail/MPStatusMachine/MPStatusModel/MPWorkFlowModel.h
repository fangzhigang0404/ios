/**
 * @file    MPWorkFlowModel.h
 * @brief   the model of work flow.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-29
 *
 */

#import "MPModel.h"

@interface MPWorkFlowModel : MPModel

/// the ID of template.
@property (nonatomic, copy) NSString *wk_template_id;

/// the ID of current node.
@property (nonatomic, copy) NSString *wk_cur_node_id;

/// the ID of current sub node.
@property (nonatomic, copy) NSString *wk_cur_sub_node_id;

/**
 *  @brief get the model of work flow.
 *
 *  @param dict the dictionary of data.
 *
 *  @return MPWorkFlowModel.
 */
+ (instancetype)getWorkFlowWithDict:(NSDictionary *)dict;
@end
