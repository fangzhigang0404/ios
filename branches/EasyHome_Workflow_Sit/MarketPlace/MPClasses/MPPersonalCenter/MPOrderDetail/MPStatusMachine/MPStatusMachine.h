//
//  MPStateMachine.h
//  MarketPlace
//
//  Created by Jiao on 16/1/27.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPStatusModel;
@interface MPStatusMachine : NSObject

+ (instancetype)sharedInstance;

///根据needs_id 和 designer_id 查询当前状态
+ (void)getCurrentStatusWithNeedsID:(NSString *)needs_id
                     withDesignerID:(NSString *)designer_id
                       andSuccess:(void(^)(MPStatusModel *statusModel))success
                         andFailure:(void(^)(NSError *error))failure;

///下面方法基于上面的查询当前状态的方法
///获取当前状态node_id 对应的名字
+ (NSString *)getCurrentNodeName:(MPStatusModel *)statusModel;

///获取当前状态sub_node_id 对应的名字
+ (NSString *)getCurrentSubNodeName:(NSString *)sub_node_id;

/// 获取当前状态对应节点返回的提示信息
+ (NSArray *)getCurrentStatusMessageWithCurNodeID:(NSString *)cur_nodeID;

/// 全流程-执行当前动作
/// perform current action in chatRoom
+ (void)mpPerformCurrentEventWithController:(__kindof UIViewController *)vc
                                withNeedsID:(NSString *)needs_id
                             withDesignerID:(NSString *)designer_id
                         withDesignerhs_uid:(NSString *)uid
                            andCurSubNodeID:(NSString *)wk_cur_sub_node_id;

///通过 sub_node_id 获取更多中的第三个图片
///get the third icon in MORE by current subnode id
+ (void)getCurrentIconWithCurSubNodeId:(NSString *)wk_cur_sub_node_id
                           withSuccess:(void(^)(NSString *iconName, NSString *iconTitle))success;

///通过 needs_id 和 designer_id 获取更多中的第三个图片
///get the third icon in MORE by current subnode id
+ (void)getCurrentIconWithNeedsID:(NSString *)needs_id
                   withDesignerID:(NSString *)designer_id
                      withSuccess:(void(^)(NSString *iconName, NSString *iconTitle))success
                       andFailure:(void(^)(NSError *error))failure;
@end

