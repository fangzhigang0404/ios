//
//  MPWorkFlowModel.h
//  MarketPlace
//
//  Created by Jiao on 16/2/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPWorkFlowModel : MPModel

@property (nonatomic, copy) NSString *wk_template_id;//工作流模板ID
@property (nonatomic, copy) NSString *wk_cur_node_id;//当前正在执行的node id
@property (nonatomic, copy) NSString *wk_cur_sub_node_id;//当前正在执行的subnode id

+ (instancetype)getWorkFlowWithDict:(NSDictionary *)dict;
@end
