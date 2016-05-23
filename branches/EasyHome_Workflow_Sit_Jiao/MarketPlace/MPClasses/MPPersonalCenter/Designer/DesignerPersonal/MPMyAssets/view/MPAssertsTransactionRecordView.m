//
//  MPAssertsTransactionRecordView.m
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPAssertsTransactionRecordView.h"
#import "MPAssertsTransactionCell.h"
#import "MPWithdrawalsTableViewCell.h"
#import "MJRefresh.h"
@interface MPAssertsTransactionRecordView ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_recordTableView;
}
@end

@implementation MPAssertsTransactionRecordView
- (instancetype)initWithIsWithdraw:(BOOL)isWithdraw withFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.isWithdraw = isWithdraw;
        [self createRecordView];
    }
    return self;
}


- (void)createRecordView {
    _recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    _recordTableView.delegate = self;
    _recordTableView.dataSource = self;
    [_recordTableView registerNib:[UINib nibWithNibName:@"MPAssertsTransactionCell" bundle:nil] forCellReuseIdentifier:@"MPAssertsTransactionCell"];
    [_recordTableView registerNib:[UINib nibWithNibName:@"MPWithdrawalsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPWithdrawalsTableViewCell"];

    _recordTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _recordTableView.backgroundColor = [UIColor colorWithRed:234/255.0 green:238/255.0 blue:241/255.0 alpha:1];
    [self addSubview:_recordTableView];
    [self addDesignerLibraryRefresh];
    
//    //---
//    self.isWithdraw = YES;
    if (self.isWithdraw) {
        _recordTableView.estimatedRowHeight = 260;
        _recordTableView.rowHeight = UITableViewAutomaticDimension;
    }else {
        _recordTableView.rowHeight = 210.0f;
    }
}
- (void)addDesignerLibraryRefresh {
    WS(weakSelf);
    _recordTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(assertsViewRefreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate assertsViewRefreshLoadNewData:^{
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    
    _recordTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(assertsViewRefreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate assertsViewRefreshLoadMoreData:^{
                [weakSelf endFooterRefresh];
            }];
        }
    }];
    [_recordTableView.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_recordTableView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [_recordTableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(getRecordCellCount)])
        return [self.delegate getRecordCellCount];
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isWithdraw) {
        MPWithdrawalsTableViewCell * _cell = [tableView dequeueReusableCellWithIdentifier:@"MPWithdrawalsTableViewCell" forIndexPath:indexPath];
        _cell.backgroundColor = [UIColor clearColor];
        _cell.delegate = (id)self.delegate;
        [_cell updateCellForIndex:indexPath.row];
        return _cell;

    }else{
        MPAssertsTransactionCell * _cell = [tableView dequeueReusableCellWithIdentifier:@"MPAssertsTransactionCell" forIndexPath:indexPath];
        _cell.backgroundColor = [UIColor clearColor];
        _cell.delegate = (id)self.delegate;
        [_cell updateCellForIndex:indexPath.row];
        
        return _cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)])
        [self.delegate didSelectItemAtIndex:indexPath.row];
}

#pragma mark- Public interface methods

-(void) refreshRecordUI
{
    [_recordTableView reloadData];
}

@end
