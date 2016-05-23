//
//  MPPayView.m
//  MarketPlace
//
//  Created by Jiao on 16/3/5.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPPayView.h"


#define MPPAY_CONTRACT @"MPpayTableViewCell"
#define MPPAY_MEASURE @"MPPayForMeasureCell"
@interface MPPayView()<UITableViewDataSource, UITableViewDelegate>

@end
@implementation MPPayView
{
    UITableView *_payTableView;
}
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
    _payTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _payTableView.delegate = self;
    _payTableView.dataSource = self;
    [self addSubview:_payTableView];
    _payTableView.backgroundColor = COLOR(233, 238, 242, 1);
    _payTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_payTableView registerNib:[UINib nibWithNibName:@"MPPayForMeasureCell" bundle:nil] forCellReuseIdentifier:MPPAY_MEASURE];
    [_payTableView registerNib:[UINib nibWithNibName:@"MPpayTableViewCell" bundle:nil] forCellReuseIdentifier:MPPAY_CONTRACT];
    
}

- (void)refreshPayView {
    if (self.type == MPPayForMeasure) {
        _payTableView.rowHeight = SCREEN_HEIGHT - NAVBAR_HEIGHT;
    }else {
        NSLog(@"%f",SCREEN_HEIGHT);
        if (SCREEN_HEIGHT - NAVBAR_HEIGHT > 600) {
            _payTableView.rowHeight = SCREEN_HEIGHT - NAVBAR_HEIGHT;
        }else {
            _payTableView.rowHeight = 600;
        }
    }
    [_payTableView reloadData];
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == MPPayForMeasure) {
        MPPayForMeasureCell *cell = [tableView dequeueReusableCellWithIdentifier:MPPAY_MEASURE forIndexPath:indexPath];
        cell.delegate = (id)self.delegate;
        [cell updateDetailCellForIndex:indexPath.row];
        
        return cell;
    }else {
        MPpayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MPPAY_CONTRACT forIndexPath:indexPath];
        cell.delegate = (id)self.delegate;
        if (self.type == MPPayForContractFirst) {
            cell.isFirstPay = YES;
        }else {
            cell.isFirstPay = NO;
        }
        [cell updateDetailCellForIndex:indexPath.row];
        
        return cell;
    }
}

@end
