//
//  MPDecoPageView.m
//  MarketPlace
//
//  Created by WP on 16/3/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDecoPageView.h"

@interface MPDecoPageView ()

/// page control.
@property (weak, nonatomic) IBOutlet UIPageControl *pageContril;

/// page label.
@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@end

@implementation MPDecoPageView
{
    NSInteger _count; //!< _count the count of pages.
}

- (void)awakeFromNib {
    self.pageLabel.hidden = YES;
}

- (void)updatePageViewWithIndex:(NSInteger)index {
    self.pageContril.currentPage = index;
    self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",index + 1,_count];
}

- (void)setPageNumWithCount:(NSInteger)count {
    _count = count;
    self.pageContril.numberOfPages = count;
    if (_count > 10) {
        self.pageContril.hidden = YES;
        self.pageLabel.hidden = NO;
        self.pageLabel.text = [NSString stringWithFormat:@"%ld/%ld",_count - 10,_count];
    }
}

@end
