//
//  MPVCTransitionByPop.m
//  MarketPlace
//
//  Created by xuezy on 16/3/11.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPVCTransitionByPop.h"

@implementation MPVCTransitionByPop
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    fromVc.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    [container insertSubview:toVc.view belowSubview:fromVc.view];
//    [container addSubview:fromVc.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
        fromVc.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        BOOL flag = ![transitionContext transitionWasCancelled];
        [transitionContext completeTransition:flag];
    }];
}

@end
