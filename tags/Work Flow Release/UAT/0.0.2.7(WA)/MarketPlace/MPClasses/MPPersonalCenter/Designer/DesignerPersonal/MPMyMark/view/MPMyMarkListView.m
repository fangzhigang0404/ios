//
//  MPMyMarkListView.m
//  MarketPlace
//
//  Created by xuezy on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMyMarkListView.h"
#import "MJRefresh.h"
#import "MPMyBiddingCell.h"
#import "MPMyBidTableViewCell.h"
@interface MPMyMarkListView ()<UITableViewDataSource,UITableViewDelegate>

@end
@implementation MPMyMarkListView
{
    UITableView * myMarkTableView;
    NSString *tableViewType;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createBiddingView];
    }
    return self;
}

- (void)createBiddingView {
    tableViewType = @"one";
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"In the standard", nil),NSLocalizedString(@"Bid_key", nil),NSLocalizedString(@"Not winning", nil),nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(-1, 0, SCREEN_WIDTH+2, 44);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:5/255.0 green:132/255.0 blue:255/255.0 alpha:1];
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    
    [self addSubview:segmentedControl];
    
    myMarkTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, CGRectGetHeight(self.frame)-44) style:UITableViewStylePlain];
    myMarkTableView.delegate = self;
    myMarkTableView.dataSource = self;
    myMarkTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    myMarkTableView.backgroundColor = [UIColor colorWithRed:239.0/255 green:241.0/255 blue:245.0/255 alpha:1];
    [myMarkTableView registerNib:[UINib nibWithNibName:@"MPMyBiddingCell" bundle:nil] forCellReuseIdentifier:@"BiddingCell"];
    [myMarkTableView registerNib:[UINib nibWithNibName:@"MPMyBidTableViewCell" bundle:nil] forCellReuseIdentifier:@"MYBIDTABELCELL"];

    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:myMarkTableView];

    [self addMyMarkRefresh];
}

- (void)addMyMarkRefresh {
    WS(weakSelf);
    myMarkTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(findDesignersViewRefreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate findDesignersViewRefreshLoadNewData:^{
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    
    myMarkTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(findDesignersViewRefreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate findDesignersViewRefreshLoadMoreData:^{
                [weakSelf endFooterRefresh];
            }];
        }
    }];
    [myMarkTableView.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [myMarkTableView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [myMarkTableView.mj_footer endRefreshing];
}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
            tableViewType = @"one";
        }
            break;
        case 1:
        {
            tableViewType = @"two";
            
        }
            break;
        case 2:
        {
            tableViewType = @"three";
            
        }
            break;
        default:
            break;
    }
    
    [self.delegate selectTypeAtString:tableViewType];
    [myMarkTableView reloadData];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(getDesignerCellCount)])
        return [self.delegate getDesignerCellCount];
    
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableViewType isEqualToString:@"one"]) {
        MPMyBiddingCell * _cell = [tableView dequeueReusableCellWithIdentifier:@"BiddingCell" forIndexPath:indexPath];
        _cell.backgroundColor = [UIColor clearColor];
        _cell.delegate = (id)self.delegate;
        [_cell updateCellForIndex:indexPath.row];
        return _cell;
    }else {
        MPMyBidTableViewCell * _cell = [tableView dequeueReusableCellWithIdentifier:@"MYBIDTABELCELL" forIndexPath:indexPath];
        _cell.backgroundColor = [UIColor clearColor];

        _cell.delegate = (id)self.delegate;
        [_cell updateCellForIndex:indexPath.row withType:tableViewType];
        return _cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableViewType isEqualToString:@"one"]) {
        return 210.0f;
    }else{
        return 210.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)])
        [self.delegate didSelectItemAtIndex:indexPath.row];
}

#pragma mark- Public interface methods

-(void) refreshFindDesignersUI
{
    [myMarkTableView reloadData];
}

@end
