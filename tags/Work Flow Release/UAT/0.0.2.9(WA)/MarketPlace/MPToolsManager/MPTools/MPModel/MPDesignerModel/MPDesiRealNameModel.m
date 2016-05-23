//
//  MPDesiRealNameModel.m
//  MarketPlace
//
//  Created by WP on 16/2/25.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesiRealNameModel.h"

@implementation MPDesiRealNameModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        if (![dict isKindOfClass:[NSNull class]]) {
            [self setValuesForKeysWithDictionary:dict];
        }
    }
    return self;
}

@end
