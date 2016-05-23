//
//  MPNetWorkDetector.h
//  MarketPlace
//
//  Created by Franco Liu on 16/1/20.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface MPNetWorkDetector : NSObject{
    
}
+(void)SetNetworkDetectionEnable:(BOOL) isEnable;
//-(void) GetWorkFlowStatus:(NSString *) CurrentOrder WorkFlowStatusOfAnOrder:(OrderStatus*)status  ;
@end
