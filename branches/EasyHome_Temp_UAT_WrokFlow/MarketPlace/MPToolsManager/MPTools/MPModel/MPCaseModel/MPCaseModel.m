//
//  MPCaseModel.m
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPCaseModel.h"

@implementation MPCaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"id"]) {
        
        self.case_id = value;
    }
    else if ([key isEqualToString:@"description"]) {
        
        self.description_designercase = value;
    }
    else if ([key isEqualToString:@"designer_info"]) {
        
    }
    else if ([key isEqualToString:@"images"]) {
        
    }
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self createModelWithDict:dict];
    }
    return self;
}

- (void)createModelWithDict:(NSDictionary *)dict {
    
    if ([dict isKindOfClass:[NSNull class]]) return;
    
    [self setValuesForKeysWithDictionary:dict];
    
    MPDesignerInfoModel *model = [[MPDesignerInfoModel alloc] initWithDictionary:dict[@"designer_info"]];
    self.designer_info = model;
    
    if ([dict[@"images"] isKindOfClass:[NSNull class]]) return;

    NSMutableArray *arrayImage = [NSMutableArray array];
    for (NSDictionary *dic in dict[@"images"]) {
        MPCaseImageModel *model = [[MPCaseImageModel alloc] initWithDictionary:dic];
        [arrayImage addObject:model];
    }
    self.images = (id)arrayImage;
}

- (NSString *)project_style {
    NSString *str = [MPModel stringTypeEnglishToChineseWithString:[_project_style lowercaseString]];
    return ([str isEqualToString:@"(null)"])?_project_style:str;
}

- (NSString *)room_type {
    NSString *str = [MPModel stringTypeEnglishToChineseWithString:[_room_type lowercaseString]];
    return ([str isEqualToString:@"(null)"])?_room_type:str;
}

//- (NSNumber *)room_area {
//    NSString *roomArea = [NSString stringWithFormat:@"%@_area",_room_area];
//    roomArea = [MPModel stringTypeEnglishToChineseWithString:roomArea];
//    return ([roomArea isEqualToString:@"(null)"])?_room_area:(id)roomArea;
//}

@end
