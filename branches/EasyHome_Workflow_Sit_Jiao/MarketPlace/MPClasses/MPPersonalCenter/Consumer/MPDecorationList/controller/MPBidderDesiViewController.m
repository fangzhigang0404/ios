//
//  MPBidderDesiViewController.m
//  MarketPlace
//
//  Created by WP on 16/3/5.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPBidderDesiViewController.h"
#import "MPBidderView.h"

@interface MPBidderDesiViewController ()<MPBidderViewDelegate>

@end

@implementation MPBidderDesiViewController
{
    MPBidderView *_bidderView;
}

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rightButton setImage:nil forState:UIControlStateNormal];
    
    _bidderView = [[MPBidderView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT)];
    _bidderView.delegate = self;
    [self.view addSubview:_bidderView];
}

#pragma mark - MPBidderViewDelegate
- (NSInteger)getBidderRowsInSection {
    return 0;
}

@end
