/**
 * @file    MPDesignerDetailView.h
 * @brief   the view of controller.
 * @author  niu
 * @version 1.0
 * @date    2015-01-26
 */

#import "MPDesignerDetailView.h"
#import "MPDesignerDetailHeaderTableViewCell.h"
#import "MPDesignerDetailTableViewCell.h"
#import "MJRefresh.h"

@interface MPDesignerDetailView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MPDesignerDetailView
{
    UITableView *_tableView;    //!< _tableView the tableView.
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createDesignerDetailTableView];
    }
    return self;
}

- (void)createDesignerDetailTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = COLOR(236, 239, 242, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MPDesignerDetailHeaderTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPDesignerDetailHeader"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPDesignerDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPDesignerDetail"];
    [self addSubview:_tableView];
    
    [self addDesignerDetailRefresh];
}

- (void)addDesignerDetailRefresh {
    WS(weakSelf);
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(designerDetailViewRefreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate designerDetailViewRefreshLoadNewData:^{
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(designerDetailViewRefreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate designerDetailViewRefreshLoadMoreData:^{
                [weakSelf endFooterRefresh];
            }];
        }
    }];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_tableView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [_tableView.mj_footer endRefreshing];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(getDesignerDetailCaseCount)]) {
        return [self.delegate getDesignerDetailCaseCount];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MPDesignerDetailHeaderTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MPDesignerDetailHeader" forIndexPath:indexPath];
        cell.delegate = (id)self.delegate;
        [cell updateCellForIndex:indexPath.row isCenter:self.isDesigner];
        return cell;
    }
    MPDesignerDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPDesignerDetail" forIndexPath:indexPath];
    cell.delegate = (id)self.delegate;
    [cell updateCellForIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (self.isDesigner) {
            return 212.0f;
        }
        return 255.0f;
    }
    return SCREEN_WIDTH * CASE_IMAGE_RATIO + 63;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectCellAtIndex:)]) {
        [self.delegate didSelectCellAtIndex:indexPath.row];
    }
}

#pragma mark- Public interface methods
- (void)refreshDesignerDetailUI {
    [_tableView reloadData];
}

@end
