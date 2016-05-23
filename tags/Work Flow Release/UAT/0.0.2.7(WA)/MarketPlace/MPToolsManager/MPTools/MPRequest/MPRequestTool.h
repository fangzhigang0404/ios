//
//  MPRequestTool.h
//  MarketPlace
//
//  Created by WP on 16/4/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPRequestTool : NSObject

/// cheak 401.
+ (BOOL)statueIsOverdue:(NSInteger)statusCode;

+ (NSDictionary *)addAuthorizationForHeader:(NSDictionary *)header;

@end
