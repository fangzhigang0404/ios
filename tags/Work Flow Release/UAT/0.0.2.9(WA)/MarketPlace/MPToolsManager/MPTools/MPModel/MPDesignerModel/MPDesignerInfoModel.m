//
//  MPDesignerInfoModel.m
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignerInfoModel.h"

@implementation MPDesignerInfoModel

/// kvc.
-  (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"designer"]) {
        
    } else if ([key isEqualToString:@"real_name"]) {
        
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (![dict isKindOfClass:[NSNull class]]) {
            [self setValuesForKeysWithDictionary:dict];
            [self setDesignerModelWithDict:dict];
        }
    }
    return self;
}

- (void)setDesignerModelWithDict:(NSDictionary *)dict {
    MPDesignerModel *model = [[MPDesignerModel alloc] initWithDictionary:dict[@"designer"]];
    self.designer = model;
    
    MPDesiRealNameModel *modelRealName = [[MPDesiRealNameModel alloc] initWithDictionary:dict[@"real_name"]];
    self.real_name = modelRealName;
}

@end
