//
//  MPBiddingDetailView.m
//  MarketPlace
//
//  Created by xuezy on 16/3/2.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPBiddingDetailView.h"
#import "MPBiddingDetailTableViewCell.h"
@interface MPBiddingDetailView()
{
    UITableView *_biddingDetailTableView;
}
@end
@implementation MPBiddingDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:238/255.0 green:241/255.0 blue:244/255.0 alpha:1];

        [self createBiddingDetailView];
        
    }
    return self;
}

- (void)createBiddingDetailView {
    
    _biddingDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, CGRectGetHeight(self.frame)) style:UITableViewStylePlain];
    _biddingDetailTableView.dataSource = self;
    _biddingDetailTableView.delegate = self;
    _biddingDetailTableView.backgroundColor = [UIColor colorWithRed:238/255.0 green:241/255.0 blue:244/255.0 alpha:1];

    [_biddingDetailTableView registerNib:[UINib nibWithNibName:@"MPBiddingDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPBiddingDetailTableViewCell"];
    _biddingDetailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_biddingDetailTableView];
}
#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPBiddingDetailTableViewCell * _cell = [tableView dequeueReusableCellWithIdentifier:@"MPBiddingDetailTableViewCell" forIndexPath:indexPath];
    _cell.backgroundColor = [UIColor clearColor];

    _cell.delegate = (id)self.delegate;
    _cell.type = self.type;
    _cell.biddingStaus = self.biddingStaus;
    [_cell updateCellForIndex];
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 790.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

#pragma mark- Public interface methods

-(void) refreshBiddingViewUI
{
    [_biddingDetailTableView reloadData];
}

@end
