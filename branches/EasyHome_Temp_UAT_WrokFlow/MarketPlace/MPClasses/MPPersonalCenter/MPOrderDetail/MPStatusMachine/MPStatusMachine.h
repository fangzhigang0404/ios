/**
 * @file    MPStatusMachine.h
 * @brief   the manager of order status.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-01-27
 *
 */

#import <Foundation/Foundation.h>

@class MPStatusModel;
@interface MPStatusMachine : NSObject

/**
 *  @brief get the order detail of one designer.
 *
 *  @param needs_id ID of requirement.
 *
 *  @param designer_id ID of designer.
 *
 *  @param success the back block of success.
 *
 *  @param failure the back block of failure.
 *
 *  @return nil.
 */
+ (void)getCurrentStatusWithNeedsID:(NSString *)needs_id
                     withDesignerID:(NSString *)designer_id
                         andSuccess:(void(^)(MPStatusModel *statusModel))success
                         andFailure:(void(^)(NSError *error))failure;

/**
 *  @brief get the current node name for order.
 *
 *  @param statusModel the model of order detail.
 *
 *  @return the name of current node.
 */
+ (NSString *)getCurrentNodeName:(MPStatusModel *)statusModel;


/**
 *  @brief get the current sub node name for order.
 *
 *  @param sub_node_id ID of sub node.
 *
 *  @return the name of current sub node.
 */
+ (NSString *)getCurrentSubNodeName:(NSString *)sub_node_id;

/**
 *  @brief get the current message include button enabled and hidden or not for ordertail.
 *
 *  @param cur_nodeID ID of sub node.
 *
 *  @return message or UI display detail.
 */
+ (NSArray *)getCurrentStatusMessageWithCurNodeID:(NSString *)cur_nodeID;

/**
 *  @brief perform current action for order(chatRoom).
 *
 *  @param vc the controller come from.
 *
 *  @param needs_id ID of requirement.
 *
 *  @param designer_id ID of designer.
 *
 *  @param uid ID of designer at HomeStyler.
 *
 *  @param wk_cur_sub_node_id ID of current sub node.
 *
 *  @return nil.
 */
+ (void)mpPerformCurrentEventWithController:(__kindof UIViewController *)vc
                                withNeedsID:(NSString *)needs_id
                             withDesignerID:(NSString *)designer_id
                         withDesignerhs_uid:(NSString *)uid
                            andCurSubNodeID:(NSString *)wk_cur_sub_node_id;

/**
 *  @brief get the third icon in MORE by current subnode id.
 *
 *  @param wk_cur_sub_node_id ID of current sub node.
 *
 *  @param success the back block of success(iconName:the name of image, iconTitle:the title of icon).
 *
 *  @return nil.
 */
+ (void)getCurrentIconWithCurSubNodeId:(NSString *)wk_cur_sub_node_id
                           withSuccess:(void(^)(NSString *iconName, NSString *iconTitle))success;

/**
 *  @brief get the third icon in MORE by current subnode id and designer id.
 *
 *  @param needs_id ID of requirement.
 *
 *  @param designer_id ID of designer.
 *
 *  @param success the back block of success(iconName:the name of image, iconTitle:the title of icon).
 *
 *  @param failure the back block of failure.
 *
 *  @return nil.
 */
+ (void)getCurrentIconWithNeedsID:(NSString *)needs_id
                   withDesignerID:(NSString *)designer_id
                      withSuccess:(void(^)(NSString *iconName, NSString *iconTitle))success
                       andFailure:(void(^)(NSError *error))failure;
@end

