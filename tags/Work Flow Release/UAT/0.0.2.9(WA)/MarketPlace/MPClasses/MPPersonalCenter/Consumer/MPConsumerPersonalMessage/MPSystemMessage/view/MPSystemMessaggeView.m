//
//  MPSystemMessaggeView.m
//  MarketPlace
//
//  Created by xuezy on 16/3/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPSystemMessaggeView.h"
#import "MJRefresh.h"
#import "MPSystemMessageTableViewCell.h"


@implementation MPSystemMessaggeView
{
    UITableView *_systemTableView;
    
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createSystemView];
    }
    return self;
}

- (void)createSystemView {
    _systemTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    _systemTableView.delegate = self;
    _systemTableView.dataSource = self;
    _systemTableView.estimatedRowHeight = 110;
    _systemTableView.rowHeight = UITableViewAutomaticDimension;
    [_systemTableView registerNib:[UINib nibWithNibName:@"MPSystemMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPSystemMessageTableViewCell"];
    _systemTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_systemTableView];
    
    [self addDesignerLibraryRefresh];

}
- (void)addDesignerLibraryRefresh {
    WS(weakSelf);
    _systemTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(systemMessageViewRefreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate systemMessageViewRefreshLoadNewData:^{
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    
    _systemTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(systemMessageViewRefreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate systemMessageViewRefreshLoadMoreData:^{
                [weakSelf endFooterRefresh];
            }];
        }
    }];
    [_systemTableView.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_systemTableView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [_systemTableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(getSystemMessageCellCount)])
        return [self.delegate getSystemMessageCellCount];
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPSystemMessageTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"MPSystemMessageTableViewCell" forIndexPath:indexPath];
    _cell.delegate = (id)self.delegate;
    [_cell updateCellForIndex:indexPath.row];
    return _cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)])
        [self.delegate didSelectItemAtIndex:indexPath.row];
    
    
    
}

#pragma mark- Public interface methods

-(void)refreshSystemMessageUI
{
    [_systemTableView reloadData];
}

@end
