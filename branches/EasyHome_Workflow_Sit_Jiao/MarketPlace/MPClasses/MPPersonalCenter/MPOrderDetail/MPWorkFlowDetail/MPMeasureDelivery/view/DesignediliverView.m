//
//  DesignediliverView.m
//  MarketPlace
//
//  Created by zzz on 16/3/16.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "DesignediliverView.h"
#define BILLCELL @"DesignedeliverCell"
@implementation DesignediliverView

- (void)initView{
    
    UITableView * CheckProView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    CheckProView.delegate = self;
    CheckProView.dataSource = self;
    [self addSubview:CheckProView];
    
    UINib *cellNib = [UINib nibWithNibName:@"DesignedeliverCell" bundle:nil];
    [CheckProView registerNib:cellNib forCellReuseIdentifier:BILLCELL];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DesignedeliverCell * Cell = [tableView dequeueReusableCellWithIdentifier:BILLCELL forIndexPath:indexPath];
    Cell.delegate = (id)self.delegate;
    Cell.SentBtn.hidden = self.sel;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return Cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return self.bounds.size.height;
}


@end
