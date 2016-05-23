/**
 * @file    MPFindDesignersView.m
 * @brief   the view of find designer.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPFindDesignersView.h"
#import "MPFindDesignersTableViewCell.h"

#import "MJRefresh.h"

@implementation MPFindDesignersView
{
    UITableView *_findTabelview;          //<! list view of table.
    MPFindDesignersTableViewCell *_cell;  //<! the view for cell.
    BOOL _isLoadMore;
    UIImageView *_emptyView;              //!< _emptyView the view for no designers.
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
        _isLoadMore = NO;
        [self createFindView];

    }
    return self;
}
/// Create find designers view.
- (void)createFindView {
    
    _findTabelview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    _findTabelview.delegate = self;
    _findTabelview.dataSource = self;
    [_findTabelview registerNib:[UINib nibWithNibName:@"MPFindDesignersTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPFindDesigners"];
    _findTabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_findTabelview];
    
    _emptyView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2 - 95, (150/375.0) * SCREEN_WIDTH, 190, 59)];
    _emptyView.image = [UIImage imageNamed:HOME_CASE_EMPTY_IMAGE];
    [_findTabelview addSubview:_emptyView];
    
    [self addDesignerLibraryRefresh];
}

- (void)addDesignerLibraryRefresh {
    WS(weakSelf);
    _findTabelview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _isLoadMore = NO;
        if ([weakSelf.delegate respondsToSelector:@selector(findDesignersViewRefreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate findDesignersViewRefreshLoadNewData:^{
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    
    _findTabelview.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        if ([weakSelf.delegate respondsToSelector:@selector(findDesignersViewRefreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate findDesignersViewRefreshLoadMoreData:^{
                [weakSelf endFooterRefresh];
            }];
        }
    }];
    [_findTabelview.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_findTabelview.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [_findTabelview.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(getDesignerCellCount)])
        return [self.delegate getDesignerCellCount];
    
    return 0;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _cell = [tableView dequeueReusableCellWithIdentifier:@"MPFindDesigners" forIndexPath:indexPath];
    _cell.delegate = (id)self.delegate;
    [_cell updateCellForIndex:indexPath.row];
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 92.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)])
        [self.delegate didSelectItemAtIndex:indexPath.row];
}

#pragma mark- Public interface methods

-(void) refreshFindDesignersUI
{
    if (_isLoadMore) {
        [UIView animateWithDuration:0.5 animations:^{
            _findTabelview.contentOffset = CGPointMake(_findTabelview.contentOffset.x, _findTabelview.contentOffset.y + 92);
        }];
    }
    
    if (_emptyView)
        [_emptyView removeFromSuperview];
    [_findTabelview reloadData];
}

@end
