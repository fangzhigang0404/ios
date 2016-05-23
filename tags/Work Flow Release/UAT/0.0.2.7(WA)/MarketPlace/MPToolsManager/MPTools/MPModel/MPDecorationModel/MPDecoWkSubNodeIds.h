//
//  MPDecoWkSubNodeIds.h
//  MarketPlace
//
//  Created by WP on 16/2/25.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@protocol MPDecoWkSubNodeIds <NSObject>

@end

@interface MPDecoWkSubNodeIds : MPModel

@property (nonatomic, retain) NSNumber *sub_node_id;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
