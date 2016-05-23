//
//  MPDesignContractDetailView.m
//  MarketPlace
//
//  Created by Jiao on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignContractDetailView.h"
#import "MPDesignContractCell.h"

static NSString * cellID = @"MPContract";
@implementation MPDesignContractDetailView
{
    UIButton * btnon;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {
    self.conTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.conTableView.delegate =self;
    self.conTableView.dataSource = self;
    [self addSubview:self.conTableView];
    [self.conTableView registerNib:[UINib nibWithNibName:@"MPDesignContractCell" bundle:nil] forCellReuseIdentifier:cellID];
    self.conTableView.scrollEnabled = YES;
    self.conTableView.rowHeight = 1391;
    self.backgroundColor = COLOR(231, 238, 241, 1);
    self.conTableView.backgroundColor = COLOR(231, 238, 241, 1);
    self.conTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)refreshContractView {
    [self.conTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MPDesignContractCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.deleage =(id)self.deleage;
    [cell updateCellForIndex:indexPath.row];
    
    return cell;
}
@end
