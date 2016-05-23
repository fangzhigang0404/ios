//
//  MPTranslate.m
//  MarketPlace
//
//  Created by xuezy on 16/2/25.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPTranslate.h"

@implementation MPTranslate

+ (NSString *)stringTypeEnglishToChineseWithString:(NSString *)string {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MPSearchChinese" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *stringChinese = [NSString stringWithFormat:@"%@",dictionary[string]];
    return stringChinese;
}

+ (NSString *)stringTypeChineseToEnglishWithString:(NSString *)string {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MPSearchEnglish" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *stringEnglish = [NSString stringWithFormat:@"%@",dictionary[string]];
    return stringEnglish;
    
}

+ (NSString *)stringToTypeWithString:(NSString *)string {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MPSearchType" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    NSString *stringType = [NSString stringWithFormat:@"%@",dictionary[string]];
    return stringType;
}

@end
