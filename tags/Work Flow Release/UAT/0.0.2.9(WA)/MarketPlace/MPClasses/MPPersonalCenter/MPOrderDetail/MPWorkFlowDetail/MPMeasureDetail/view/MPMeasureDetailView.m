//
//  MPMeasureDetailView.m
//  MarketPlace
//
//  Created by Jiao on 16/1/28.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMeasureDetailView.h"
#import "MPMeasureDetailCell.h"
@interface MPMeasureDetailView ()<UITableViewDataSource, UITableViewDelegate>

@end
@implementation MPMeasureDetailView
{
    UITableView *_tableView;
}

#pragma mark -Init Method
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
    }
    return self;
}

#pragma mark -Custom Method
- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MPMeasureDetailCell" bundle:nil] forCellReuseIdentifier:@"MPMeasureDetailCell"];
    _tableView.estimatedRowHeight = 700;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.backgroundColor = COLOR(233, 238, 242, 1);
    self.backgroundColor = COLOR(233, 238, 242, 1);
    [self addSubview:_tableView];
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MPMeasureDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPMeasureDetailCell"];
    cell.delegate = (id)self.delegate;
    [cell updateDetailCellForIndex:indexPath.row];
    return cell;
}

- (void)refreshMeasureDetailView {
    [_tableView reloadData];
}

@end
