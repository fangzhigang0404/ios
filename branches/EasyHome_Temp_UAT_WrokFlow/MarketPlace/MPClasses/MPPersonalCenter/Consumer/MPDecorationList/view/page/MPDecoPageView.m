//
//  MPDecoPageView.m
//  MarketPlace
//
//  Created by WP on 16/3/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDecoPageView.h"

@interface MPDecoPageView ()

/// page label.
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@end

@implementation MPDecoPageView
{
    NSInteger _count; //!< _count the count of pages.
}

- (void)awakeFromNib {
    _pageLabel.hidden = YES;
}

- (void)updatePageViewWithIndex:(NSInteger)index {
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",index + 1,_count];
}

- (void)setPageNumWithCount:(NSInteger)count index:(NSInteger)index {
    _count = count;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",index,_count];
    if (_pageLabel.hidden && _count != 0) {
        _pageLabel.hidden = NO;
    }
}

@end
