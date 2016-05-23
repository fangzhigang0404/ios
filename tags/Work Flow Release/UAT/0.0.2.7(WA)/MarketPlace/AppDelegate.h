//
//  AppDelegate.h
//  MarketPlace
//
//  Created by xuezy on 15/12/15.
//  Copyright © 2015年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoginDidRefreshDelegate <NSObject>

- (void)loginDidRefreshData;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) id<LoginDidRefreshDelegate> loginDelegate;
@property (nonatomic, assign)BOOL  isReachable;
@property (nonatomic, strong) UIWebView *webView;

@end

