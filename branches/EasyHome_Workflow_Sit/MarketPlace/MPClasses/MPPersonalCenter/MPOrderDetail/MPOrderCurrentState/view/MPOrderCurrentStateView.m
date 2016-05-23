//
//  MPOrderCurrentStateView.m
//  MarketPlace
//
//  Created by Jiao on 16/1/27.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPOrderCurrentStateView.h"
#import "MPOrderCurrentStateCell.h"
#import "MJRefresh.h"
#define FLASH @"cellFlase"

@interface MPOrderCurrentStateView () <UITableViewDataSource,UITableViewDelegate>

@end
@implementation MPOrderCurrentStateView

{
    UITableView *_tableView;
    NSInteger _count;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTableView];
    }
    return self;
}

- (void)createTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"MPOrderCurrentStateCell" bundle:nil] forCellReuseIdentifier:@"MPOrderCurrentState"];
    [self addSubview:_tableView];
    
    [self addRefresh];
}

- (void)addRefresh {
    WS(weakSelf);
    /// add head refresh.
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([self.delegate respondsToSelector:@selector(initDataBack:)]) {
            [self.delegate initDataBack:^{
               dispatch_async(dispatch_get_main_queue(), ^{
                   [_tableView reloadData];
                   [weakSelf endHeaderRefresh];
               });
            }];
        }
    }];
    _tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self beginHeaderRefresh];
}

- (void)beginHeaderRefresh {
    [_tableView.mj_header beginRefreshing];
}
/// end header refresh
- (void)endHeaderRefresh {
    [_tableView.mj_header endRefreshing];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if ([self.delegate respondsToSelector:@selector(getContractCount)]) {
//        _count = [self.delegate getContractCount];
//        return _count;
//    }
//    return 0;
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPOrderCurrentStateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MPOrderCurrentState" forIndexPath:indexPath];
    cell.delegate = (id)self.delegate;
    [cell updateCellForIndex:indexPath.row];
    if (indexPath.row <= self.nodeID - 1) {
        cell.contentView.alpha = 1.0;
    }
    if (indexPath.row == self.flashID - 1) {
        cell.contentView.alpha = 1.0;
        [cell.iconImageView.layer addAnimation:[self cellFlash:0.8f] forKey:FLASH];
    }
    if (indexPath.row == _count - 1) {
        [[cell viewWithTag:999] removeFromSuperview];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= self.nodeID - 1 || indexPath.row == self.flashID - 1) {
        if ([self.delegate respondsToSelector:@selector(didSelectCellAtIndex:)]) {
            [self.delegate didSelectCellAtIndex:indexPath.row];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 111.0f;
}

#pragma mark- Public interface methods
- (void)refreshOrderStateView {
    [_tableView.mj_header beginRefreshing];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#pragma mark -Animation
-(CABasicAnimation *)cellFlash:(float)time
{
    CABasicAnimation *animation =[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:1.2f];//这是透明度。
    animation.autoreverses = YES;
    animation.duration = time;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    return animation;
}
@end
