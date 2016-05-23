//
//  MPSoundManager.h
//  MarketPlace
//
//  Created by Jiao on 15/12/17.
//  Copyright © 2015年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPSoundManager : NSObject
+ (instancetype)sharedInstance;
- (void)playSound;
@end
