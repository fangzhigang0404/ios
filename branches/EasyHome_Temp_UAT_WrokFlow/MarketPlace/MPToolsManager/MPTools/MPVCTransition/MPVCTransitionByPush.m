//
//  MPVCTransitionByPush.m
//  MarketPlace
//
//  Created by xuezy on 16/3/11.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPVCTransitionByPush.h"

@implementation MPVCTransitionByPush
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //    UIViewController *fromVc = [transitionContext viewControllerForKey:@"ViewController"];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    
    toVC.view.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [container addSubview:toVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionTransitionFlipFromBottom animations:^{
        toVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
