//
//  MPBidderView.m
//  MarketPlace
//
//  Created by WP on 16/3/5.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPBidderView.h"
#import "MPBidderCell.h"

@interface MPBidderView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MPBidderView
{
    UITableView *_tableView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createBidderTableView];
    }
    return self;
}

- (void)createBidderTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MPBidderCell" bundle:nil] forCellReuseIdentifier:@"MPBidderCell"];
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(getBidderRowsInSection)]) {
        return [self.delegate getBidderRowsInSection];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *bidderCellID = @"MPBidderCell";
    MPBidderCell *cell = [tableView dequeueReusableCellWithIdentifier:bidderCellID forIndexPath:indexPath];
    cell.delegate = (id)self.delegate;
    [cell updateCellAtIndex:indexPath.row];
    return cell;
}

#pragma mark- Public interface methods
- (void)refreshBidderUI {
    [_tableView reloadData];
}

@end
