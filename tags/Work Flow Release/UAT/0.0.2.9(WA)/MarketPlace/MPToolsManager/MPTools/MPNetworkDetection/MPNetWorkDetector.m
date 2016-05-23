//
//  MPNetWorkDetector.m
//  MarketPlace
//
//  Created by Franco Liu on 16/1/20.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPNetWorkDetector.h"

@implementation MPNetWorkDetector


Reachability * hostReach;
int   _isReachable;


+(void)SetNetworkDetectionEnable:(BOOL) isEnable{
    
    if (isEnable==YES)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
        
        [hostReach startNotifier];
    }
    else
    {
         [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    }
    
}

+ (void)reachabilityChanged:(NSNotification *)note{
    
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    
    NetworkStatus status = [currReach currentReachabilityStatus];
    
   
    
    // Wan->No     wifi->No
    if(status == NotReachable)
    {
        if (_isReachable != NotReachable ) // (!NotReachable)= connected
        {
            [self NetworingShowAlert:@"Please check your network connection_key" UserActionString:@"Currently no network_key" ];
        }
      
    }
    else{
        
        BOOL isShowmsg=NO;
        
        // No->Wan    No->wifi
        if(status == ReachableViaWiFi & _isReachable==NotReachable)
            isShowmsg=YES;
        
        if(status ==ReachableViaWWAN & _isReachable==NotReachable)
            isShowmsg=YES;
        //=================
        
        
        //Change singal
        if ((status!= _isReachable) & (_isReachable!=NotReachable))
            isShowmsg=YES;
        
        
//        if (isShowmsg==YES)
//        {
//           if(status == ReachableViaWiFi )
//                [self NetworingShowAlert:@"Network connection success_key" UserActionString:@"Using WIFI network_key" ];
//        
//           if(status ==ReachableViaWWAN )
//                [self NetworingShowAlert:@"Network connection success_key" UserActionString:@"Using a mobile phone network_key" ];
//        }
        
        
    }
  
    _isReachable = status;
   
    
}
/*+ (void)reachabilityChanged:(NSNotification *)note{
    
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    
    NetworkStatus status = [currReach currentReachabilityStatus];
    
    
    if(status == NotReachable && _isReachable)
    {
        [self NetworingShowAlert:@"Please check your network connection_key" UserActionString:@"Currently no network_key" ];
 
        _isReachable = NO;
        return;
    }
    if ((status == ReachableViaWiFi || status == ReachableViaWWAN) && _isReachable == NO) {
        
        
        _isReachable = YES;
        
        if (status == ReachableViaWWAN) {
            NSLog(@"Use 3G");
            
            [self NetworingShowAlert:@"Network connection success_key" UserActionString:@"Using a mobile phone network_key" ];
 
        }if (status == ReachableViaWiFi) {
            NSLog(@"Use Wifi");
            
            [self NetworingShowAlert:@"Network connection success_key" UserActionString:@"Using WIFI network_key" ];
                    }
        
        
    }
    
    
}*/
+ (void)NetworingShowAlert:(NSString*)Notification UserActionString:(NSString*)PlsDoAction{
    
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:NSLocalizedString(Notification, @"") message:NSLocalizedString(PlsDoAction, @"") delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alertview show];
    
    [self performSelector:@selector(dimissAlert:)
               withObject:alertview
               afterDelay:2];
    
    
}
+ (void)dimissAlert:(UIAlertView *)alert {
    
    if(alert) {
        [alert dismissWithClickedButtonIndex:[alert
                                              cancelButtonIndex] animated:YES];
    }
}




@end
