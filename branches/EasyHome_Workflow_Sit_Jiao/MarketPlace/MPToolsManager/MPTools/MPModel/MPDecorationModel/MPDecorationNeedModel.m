//
//  MPDecorationNeedModel.m
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDecorationNeedModel.h"

@implementation MPDecorationNeedModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        if (![dictionary isKindOfClass:[NSNull class]]) {
            [self setValuesForKeysWithDictionary:dictionary];
            [self setBidderListWithDict:dictionary];
        }
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"bidders"]) {
        
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (void)setBidderListWithDict:(NSDictionary *)dict {
    NSMutableArray *arrayBidder = [NSMutableArray array];
    
    if ([dict[@"bidders"] isKindOfClass:[NSNull class]]) {
        
    }else{
        for (NSDictionary *dic in dict[@"bidders"]) {
            MPDecorationBidderModel *model = [[MPDecorationBidderModel alloc] initWithDictionary:dic];
            model.template_id = self.wk_template_id;
            [arrayBidder addObject:model];
        }
        self.bidders = (id)arrayBidder;
    }
  
}

/// english to chinese
- (NSString *)house_type {
    NSString *str = [MPModel stringTypeEnglishToChineseWithString:[_house_type lowercaseString]];
    return ([str isEqualToString:@"(null)"])?_house_type:str;
}

- (NSString *)room {
    NSString *str = [MPModel stringTypeEnglishToChineseWithString:[_room lowercaseString]];
    return ([str isEqualToString:@"(null)"])?_room:str;
}

- (NSString *)living_room {
    NSString *str = [MPModel stringTypeEnglishToChineseWithString:[[NSString stringWithFormat:@"%@_living",_living_room] lowercaseString]];
    return ([str isEqualToString:@"(null)"])?_living_room:str;
}

- (NSString *)toilet {
    NSString *str = [MPModel stringTypeEnglishToChineseWithString:[[NSString stringWithFormat:@"%@_toilet",_toilet] lowercaseString]];
    return ([str isEqualToString:@"(null)"])?_toilet:str;
}

- (NSString *)decoration_style {
    NSString *str = [MPModel stringTypeEnglishToChineseWithString:[_decoration_style lowercaseString]];
    return ([str isEqualToString:@"(null)"])?_decoration_style:str;
}

- (NSString *)district_name {
    if ([_district_name isEqualToString:@"none"]) {
        return @"";
    }
    return _district_name;
}

@end
