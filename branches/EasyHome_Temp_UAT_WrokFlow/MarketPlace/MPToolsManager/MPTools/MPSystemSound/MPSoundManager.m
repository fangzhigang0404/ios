//
//  MPSoundManager.m
//  MarketPlace
//
//  Created by Jiao on 15/12/17.
//  Copyright © 2015年 xuezy. All rights reserved.
//

#import "MPSoundManager.h"
#import <AVFoundation/AVFoundation.h>

@implementation MPSoundManager
{
    SystemSoundID sound;
}

+ (instancetype)sharedInstance {
    
    static MPSoundManager *s_manager = nil;
    static dispatch_once_t s_predicate;
    dispatch_once(&s_predicate, ^{
        s_manager = [[super allocWithZone:NULL]init];
    });
    
    return s_manager;
}

///override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [MPSoundManager sharedInstance];
}

///override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return [MPSoundManager sharedInstance];
}

- (void)playSound {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        // NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/ReceivedMessage.caf"];
//        NSString *path=[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:@"ReceivedMessage" ofType:@"caf"];
//        //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];
//        if (path) {
//            OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&sound);
//            
//            if (error != kAudioServicesNoError) {//获取的声音的时候，出现错误
//                
//            }
//        }
        //    //1.获得音效文件的全路径
        //
        // NSURL *url=[[NSBundle mainBundle]URLForResource:@"buyao.wav" withExtension:nil];
        //
        ////2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
        //SystemSoundID soundID=0;
        //AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        //
        ////把需要销毁的音效文件的ID传递给它既可销毁
        ////AudioServicesDisposeSystemSoundID(soundID);
        //
        // //3.播放音效文件
        // //下面的两个函数都可以用来播放音效文件，第一个函数伴随有震动效果
        // AudioServicesPlayAlertSound(soundID);
        AudioServicesPlaySystemSound(1003);
        
    });
    
    
    
}
@end
