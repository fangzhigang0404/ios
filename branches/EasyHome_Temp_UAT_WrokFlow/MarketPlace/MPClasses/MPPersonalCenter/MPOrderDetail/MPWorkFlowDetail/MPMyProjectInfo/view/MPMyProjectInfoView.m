//
//  MPMyProjectInfoView.m
//  MarketPlace
//
//  Created by xuezy on 16/3/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMyProjectInfoView.h"
#import "MJRefresh.h"
#import "MPMyProjectInfoTableViewCell.h"
@implementation MPMyProjectInfoView

{
    UITableView *_myProjectInfoTabelview;
    
    NSMutableArray *_projectInfoArray;
    MPProjectInfoType _type;

}

-(NSMutableArray *)_projectInfoArray {
    if (_projectInfoArray == nil) {
        _projectInfoArray = [[NSMutableArray alloc]init];
    }
    return _projectInfoArray;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _projectInfoArray = [NSMutableArray array];
        [self createMyProjectInfoView];
    }
    return self;
}


- (void)createMyProjectInfoView {
    
    _myProjectInfoTabelview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
    _myProjectInfoTabelview.delegate = self;
    _myProjectInfoTabelview.dataSource = self;
    [_myProjectInfoTabelview registerNib:[UINib nibWithNibName:@"MPMyProjectInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPMyProjectInfo"];
    _myProjectInfoTabelview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_myProjectInfoTabelview];
    [self addRefresh];

}

/// add refresh load more data & load new data
- (void)addRefresh {
    WS(weakSelf);
    /// add head refresh.
    _myProjectInfoTabelview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(myProjectInfoViewRefreshLoadNewData:)]) {
            [weakSelf.delegate myProjectInfoViewRefreshLoadNewData:^() {
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    _myProjectInfoTabelview.mj_header.automaticallyChangeAlpha = YES;
    [_myProjectInfoTabelview.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_myProjectInfoTabelview.mj_header endRefreshing];
}



#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _projectInfoArray.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MPMyProjectInfoTableViewCell * _cell = [tableView dequeueReusableCellWithIdentifier:@"MPMyProjectInfo" forIndexPath:indexPath];
    
    NSDictionary *dict = [_projectInfoArray objectAtIndex:indexPath.row];
    _cell.titlelabel.text= [dict objectForKey:@"title"];
    _cell.iconImageView.image = [UIImage imageNamed:dict[@"icon"]];
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectItemWthType:)]) {
        
        
        MPProjectInfoType selectType;
        switch (_type) {
            case ProjectTypeForNone:
            {
                selectType = ProjectTypeForNone;
            }
                break;
            case ProjectTypeForContract:
            {
                if (indexPath.row == 0) {
                    selectType = ProjectTypeForMeasureList;
                }else {
                    selectType = ProjectTypeForContract;
                }
                
            }
                break;
            case ProjectTypeForMeasureList:
            {
                selectType = ProjectTypeForMeasureList;
            }
                break;
            case ProjectTypeForDesignDelivery:
            {
                if (indexPath.row == 0) {
                    selectType = ProjectTypeForMeasureList;
                }else if (indexPath.row == 1) {
                    selectType = ProjectTypeForContract;
                }else {
                    selectType = ProjectTypeForDesignDelivery;
                }
                
            }
                break;
            case ProjectTypeForMeasureDelivery:
            {
                if (indexPath.row == 0) {
                    selectType = ProjectTypeForMeasureList;
                }else {
                    selectType = ProjectTypeForMeasureDelivery;
                }

            }
                break;
            default:
                break;
        }

        [self.delegate didSelectItemWthType:selectType];
    }
    
}



#pragma mark- Public interface methods

- (void) refreshMyProjectInfoWithType:(MPProjectInfoType)type {
    _type = type;
    [_projectInfoArray removeAllObjects];
    switch (type) {
        case ProjectTypeForNone:
        {
            
        }
            break;
        case ProjectTypeForContract:
        {
            [_projectInfoArray addObject: @{@"title":@"量房资料",@"icon":@"info_measure"}];
            [_projectInfoArray addObject: @{@"title":@"设计合同",@"icon":@"info_contract"}];

        }
            break;
        case ProjectTypeForMeasureList:
        {
            [_projectInfoArray addObject: @{@"title":@"量房资料",@"icon":@"info_measure"}];
        }
            break;
        case ProjectTypeForDesignDelivery:
        {
            [_projectInfoArray addObject: @{@"title":@"量房资料",@"icon":@"info_measure"}];
            [_projectInfoArray addObject: @{@"title":@"设计合同",@"icon":@"info_contract"}];
            [_projectInfoArray addObject: @{@"title":@"设计交付",@"icon":@"info_delivery"}];

        }
            break;
        case ProjectTypeForMeasureDelivery:
        {
            [_projectInfoArray addObject: @{@"title":@"量房资料",@"icon":@"info_measure"}];
            [_projectInfoArray addObject: @{@"title":@"量房交付",@"icon":@"info_delivery"}];
        }
            break;
        default:
            break;
    }
    
    NSLog(@"项目资料的数据:%@",_projectInfoArray);
    [_myProjectInfoTabelview reloadData];
}

@end
