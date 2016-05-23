/**
 * @file    MPConsumerCaseView.m
 * @brief   the frame of MPConsumerCaseView.
 * @author  Xue
 * @version 1.0
 * @date    2015-12-10
 */

#import "MPCaseLibraryView.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "MPCaseLibraryTableViewCell.h"
@interface MPCaseLibraryView ()

{
    UITableView *_caseTableView;   //!< _caseTableView the tableview .
    UIImageView *_emptyView;      //!< _emptyView the view for no cases.

}
@end

@implementation MPCaseLibraryView
-(NSMutableArray *)caseArray {
    if (_caseArray == nil) {
        _caseArray = [[NSMutableArray alloc]init];
    }
    return _caseArray;
}
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        
        [self createCasetableView];

    }
       return self;
}

/// Create putted forward view.
- (void)createCasetableView {
    
    _caseTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _caseTableView.delegate = self;
    _caseTableView.dataSource = self;
    [_caseTableView registerNib:[UINib nibWithNibName:@"MPCaseLibraryTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPCaseLibraryTableViewCell"];
    _caseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_caseTableView];

    _emptyView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2 - 95, (150/375.0) * SCREEN_WIDTH, 190, 59)];
    _emptyView.image = [UIImage imageNamed:HOME_CASE_EMPTY_IMAGE];
    [_caseTableView addSubview:_emptyView];

    [self addRefresh];
}


/// add refresh load more data & load new data
- (void)addRefresh {
    WS(weakSelf);
    /// add head refresh.
    _caseTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate refreshLoadNewData:^() {
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    _caseTableView.mj_header.automaticallyChangeAlpha = YES;
    
    _caseTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate refreshLoadMoreData:^() {
                [weakSelf endFooterRefresh];
            }];
        }
    }];
    [_caseTableView.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_caseTableView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [_caseTableView.mj_footer endRefreshing];
}


#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(getCaseCellCount)])
        return [self.delegate getCaseCellCount];
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPCaseLibraryTableViewCell * _cell = [tableView dequeueReusableCellWithIdentifier:@"MPCaseLibraryTableViewCell" forIndexPath:indexPath];
    _cell.delegate = (id)self.delegate;
    [_cell updateCellForIndex:indexPath.row];
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH * CASE_IMAGE_RATIO + 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectedItemAtIndex:)]) {
        
        [self.delegate didSelectedItemAtIndex:indexPath.row];
        
    }

}



#pragma mark- Public interface methods

-(void) refreshCasesLibraryUI
{
    if (_emptyView)
        [_emptyView removeFromSuperview];
    [_caseTableView reloadData];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
