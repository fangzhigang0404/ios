//
//  LoadMoreHeaderView.m
//  MarketPlace
//
//  Created by Avinash Mishra on 16/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPLoadMoreHeaderView.h"

@interface MPLoadMoreHeaderView ()
{
    __weak IBOutlet UILabel*    _loadMoreLabel;
    __weak IBOutlet UIActivityIndicatorView *_activityIndicator;
}

@end


@implementation MPLoadMoreHeaderView

- (void)awakeFromNib
{
    _loadMoreLabel.text = NSLocalizedString(@"LOAD_EARLIER_MESSAGES", @"LOAD EARLIER MESSAGES");
    _activityIndicator.hidden = YES;
    [self addTapOnImage];
}

- (void) addTapOnImage
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self addGestureRecognizer:tap];
}

- (void) imageTapped:(UITapGestureRecognizer*)tapG
{
    [self.delegate loadMoreData];
}

- (void) startIndicator
{
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
}

- (void) stopIndicator
{
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
}

@end
