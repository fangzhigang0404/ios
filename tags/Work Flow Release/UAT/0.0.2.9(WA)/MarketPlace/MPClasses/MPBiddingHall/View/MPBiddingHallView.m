/**
 * @file    MPBiddingHallView.m.
 * @brief   the view for bidding hall.
 * @author  Xue.
 * @version 1.0.
 * @date    2016-02-24.
 */
#import "MPBiddingHallView.h"
#import "MJRefresh.h"
#import "MPBiddingTableViewCell.h"
@interface MPBiddingHallView ()
{
    UITableView *_biddingTableView;
}
@end
@implementation MPBiddingHallView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createFindView];
    }
    return self;
}

/// Create find designers view.
- (void)createFindView {
    
    _biddingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) style:UITableViewStylePlain];
    _biddingTableView.delegate = self;
    _biddingTableView.dataSource = self;
    [_biddingTableView registerNib:[UINib nibWithNibName:@"MPBiddingTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPBiddingTableViewCell"];
    _biddingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_biddingTableView];
    
    [self addDesignerLibraryRefresh];
}

- (void)addDesignerLibraryRefresh {
    WS(weakSelf);
    _biddingTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(biddingViewRefreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate biddingViewRefreshLoadNewData:^{
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    
    _biddingTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(biddingViewRefreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate biddingViewRefreshLoadMoreData:^{
                [weakSelf endFooterRefresh];
            }];
        }
    }];
    [_biddingTableView.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_biddingTableView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [_biddingTableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(getBiddingCellCount)])
        return [self.delegate getBiddingCellCount];
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPBiddingTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"MPBiddingTableViewCell" forIndexPath:indexPath];
    _cell.delegate = (id)self.delegate;
    [_cell updateCellForIndex:indexPath.row];
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 102.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)])
        [self.delegate didSelectItemAtIndex:indexPath.row];
}

#pragma mark- Public interface methods

-(void) refreshBiddingViewUI
{
    [_biddingTableView reloadData];
}

@end
