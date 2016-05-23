//
//  MPDeliveryView.m
//  MarketPlace
//
//  Created by Jiao on 16/3/22.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryView.h"
#import "MPDeliveryForMeasureCell.h"
#import "MPDeliveryForDesignCell.h"

#define MPDeliveryForMeasure @"MPDeliveryForMeasure"
#define MPDeliveryForDesign @"MPDeliveryForDesign"
@interface MPDeliveryView() <UITableViewDataSource, UITableViewDelegate>

@end
@implementation MPDeliveryView
{
    UITableView *_deliveryTableView;
    MPDeliveryType _type;
}
- (instancetype)initWithFrame:(CGRect)frame andType:(MPDeliveryType)type {
    self = [super initWithFrame:frame];
    if (self) {
        _type = type;
        [self createTableView];
    }
    return self;
}

- (void)createTableView {
    _deliveryTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _deliveryTableView.delegate = self;
    _deliveryTableView.dataSource = self;
    [self addSubview:_deliveryTableView];
    _deliveryTableView.backgroundColor = COLOR(233, 238, 242, 1);
    _deliveryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_deliveryTableView registerNib:[UINib nibWithNibName:@"MPDeliveryForMeasureCell" bundle:nil] forCellReuseIdentifier:MPDeliveryForMeasure];
    [_deliveryTableView registerNib:[UINib nibWithNibName:@"MPDeliveryForDesignCell" bundle:nil] forCellReuseIdentifier:MPDeliveryForDesign];
    _deliveryTableView.rowHeight = SCREEN_HEIGHT - NAVBAR_HEIGHT;
}

#pragma mark - UITabelViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == MPDeliveryTypeForDesignSubmit || _type == MPDeliveryTypeForDesignView) {
        MPDeliveryForDesignCell *cell = [tableView dequeueReusableCellWithIdentifier:MPDeliveryForDesign];
        cell.delegate = (id)self.delegate;
        [cell updateCellForIndex:indexPath.row];
        return cell;
    }else {
        MPDeliveryForMeasureCell *cell = [tableView dequeueReusableCellWithIdentifier:MPDeliveryForMeasure];
        cell.delegate = (id)self.delegate;
        [cell updateCellForIndex:indexPath.row];
        return cell;
    }
}

- (void)refreshDeliveryView {
    [_deliveryTableView reloadData];
}
@end
