//
//  MPMyProjectViewController.m
//  MarketPlace
//
//  Created by xuezy on 16/1/20.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMyProjectViewController.h"
#import "MPProjectTableViewCell.h"
#import "MPBeishuTableViewCell.h"
#import "MPAPI.h"
#import "MBProgressHUD.h"
#import "MPDesignerOrderModel.h"
#import "MPMyProjectModel.h"
#import "MJRefresh.h"
#import "MPOrderEmptyView.h"
@interface MPMyProjectViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MPMyProjectViewController

{
    UITableView *projectTabelView;
    NSMutableArray *projectArray;
    NSString *tableViewType;
    NSMutableArray *orderArray;
    
    BOOL isCommon;
    NSInteger _beiShuoffset;
    NSInteger _beiShulimit;
    BOOL _beiShuisLoadMore;
   
    NSInteger _offset;
    NSInteger _limit;
    NSInteger _isLoadMore;
    MPOrderEmptyView *_emptyView;

   
}


- (void)viewWillAppear:(BOOL)animated {
    
    if ([tableViewType isEqualToString:@"one"]) {
        
    }else{
        [self requestData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.rightButton.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"Decoration order_key", @"");
    tableViewType = [[NSString alloc] init];
    
    if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
        
        tableViewType = @"one";
    } else {
        
        if (self.is_loho !=1) {
            tableViewType= @"two";
            
        }else {
            tableViewType= @"one";
            
        }

    }
    
    orderArray = [NSMutableArray array];
    _offset = 0;
    _limit = 100;
    _isLoadMore = NO;
    _beiShulimit=100;
    _beiShuoffset = 0;
    _beiShuisLoadMore = NO;
    isCommon = YES;
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255 green:241.0/255 blue:245.0/255 alpha:1];

    NSArray *segmentedArray;
    
    if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
        
    } else {
        if (self.is_loho != 1) {
            
        }else{
            segmentedArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"set meal_key", nil),NSLocalizedString(@"Common order", nil),nil];
            
        }

        
    }
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.frame = CGRectMake(-1, NAVBAR_HEIGHT, SCREEN_WIDTH+2, 44);
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor colorWithRed:5/255.0 green:132/255.0 blue:255/255.0 alpha:1];//    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    
    [segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:segmentedControl];
    
    
    projectArray = [NSMutableArray array];
    

    projectTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT+44, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT-44) style:UITableViewStylePlain];
    
    if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
        
        projectTabelView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);

    } else {
        if (self.is_loho != 1) {
            projectTabelView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
        }

        
    }
 
    projectTabelView.delegate = self;
    projectTabelView.dataSource = self;
    projectTabelView.backgroundColor = [UIColor colorWithRed:239.0/255 green:241.0/255 blue:245.0/255 alpha:1];
    [projectTabelView registerNib:[UINib nibWithNibName:@"MPProjectTableViewCell" bundle:nil] forCellReuseIdentifier:@"ProjectList"];
    
    [projectTabelView registerNib:[UINib nibWithNibName:@"MPBeishuTableViewCell" bundle:nil] forCellReuseIdentifier:@"BeishuList"];
    projectTabelView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:projectTabelView];
    [self addRefresh];
}

- (void)initData {
   // [self showHUD];
    
    [MPMyProjectModel getDataWithParameters:@{@"limit":@(_beiShulimit),@"offset":@(_beiShuoffset)} success:^(NSArray *array) {
        
        if (!_beiShuisLoadMore) {
            [projectArray removeAllObjects];
        }else{
            
        }
        

        [projectArray addObjectsFromArray:array];
        
        
       // if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            if (projectArray.count == 0) {
                _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MPOrderEmptyView" owner:self options:nil] lastObject];
                _emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT-44);
                _emptyView.infoLabel.text = @"您还没有订单项目，请去应标大厅接单";
                [projectTabelView addSubview:_emptyView];
                
            }else{
                if (_emptyView) [_emptyView removeFromSuperview];
                
            }

       // }
        
        
        [projectTabelView reloadData];
        [self endHeaderRefresh];
        [self endFooterRefresh];
        [self hideHUD];
    } failure:^(NSError *error) {
        NSLog(@"error:%@",error);
        [self hideHUD];
        [self endHeaderRefresh];
        [self endFooterRefresh];

    }];
    
}

- (void)requestData {
    [self showHUD];
    
    WS(weakSelf);
    [MPDesignerOrderModel createDesignerOrdersListWithParameters:@{@"limit":@(_limit),@"offset":@(_offset)} success:^(NSMutableArray *array) {
        if (!_isLoadMore) {
            [orderArray removeAllObjects];
        }else{
            
        }
        
        [orderArray addObjectsFromArray:array];
        
       // if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            if (orderArray.count == 0) {
                _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MPOrderEmptyView" owner:self options:nil] lastObject];
                _emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT-44);
                _emptyView.infoLabel.text = @"您还没有订单项目，请去应标大厅接单";
                [projectTabelView addSubview:_emptyView];
                
            }else{
                if (_emptyView) [_emptyView removeFromSuperview];
                
            }

            
      //  }
      
        
        [projectTabelView reloadData];
        
        [weakSelf endHeaderRefresh];
        [weakSelf endFooterRefresh];
        [weakSelf hideHUD];

    } failure:^(NSError *error) {
        
        
        
        NSLog(@"%@",error);
        [weakSelf hideHUD];
    }];
}

- (void)showHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/// 请求结束
- (void)hideHUD {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void)refreshLoadNewData{
    
    if ([tableViewType isEqualToString:@"one"]) {
    
        _beiShuoffset = 0;
        _beiShuisLoadMore =NO;
        [self initData];
    }else {
        _offset = 0;
        _isLoadMore = NO;
        [self requestData];
    }
   
    
}

- (void)refreshLoadMoreData {
    
    if ([tableViewType isEqualToString:@"one"]) {
        _beiShuoffset +=_beiShulimit;
        _beiShuisLoadMore = YES;
        [self initData];
    }else{
        _offset += _limit;
        _isLoadMore = YES;
        [self requestData];
    }
}

/// add refresh load more data & load new data
- (void)addRefresh {
    /// add head refresh.
    projectTabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self refreshLoadNewData];
        
    }];
    projectTabelView.mj_header.automaticallyChangeAlpha = YES;
    
    projectTabelView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [self refreshLoadMoreData];
        
    }];
    [projectTabelView.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [projectTabelView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [projectTabelView.mj_footer endRefreshing];
}

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - tableViewDelegate & dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([tableViewType isEqualToString:@"two"]) {
        
        return orderArray.count;
    }else{
        return projectArray.count;
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if ([tableViewType isEqualToString:@"two"]) {
        MPProjectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectList" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.model = [orderArray objectAtIndex:indexPath.row];
        [cell upLoadData];
        
        return cell;
    }else {
        
        MPBeishuTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:@"BeishuList" forIndexPath:indexPath];
        cells.model = [projectArray objectAtIndex:indexPath.row];
        [cells upLoadData];
        return cells;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableViewType isEqualToString:@"two"]) {
        return 223.0f;
    }
    return 313.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    
    [_emptyView removeFromSuperview];
    
    
   

    switch (Index) {
        case 0:
        {
            tableViewType = @"one";
            
            if (projectArray.count == 0) {
                _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MPOrderEmptyView" owner:self options:nil] lastObject];
                _emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT-44);
                _emptyView.infoLabel.text = @"您还没有订单项目，请去应标大厅接单";
                [projectTabelView addSubview:_emptyView];
                
            }else{
                if (_emptyView) [_emptyView removeFromSuperview];
                
            }

        }
            break;
        case 1:
        {
            tableViewType = @"two";
            
            if (isCommon == YES) {
                [self requestData];
                isCommon = NO;
            }
            
            if (orderArray.count == 0) {
                _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MPOrderEmptyView" owner:self options:nil] lastObject];
                _emptyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT-44);
                _emptyView.infoLabel.text = @"您还没有订单项目，请去应标大厅接单";
                [projectTabelView addSubview:_emptyView];
                
            }else{
                if (_emptyView) [_emptyView removeFromSuperview];
                
            }

            
        }
            break;
            
        default:
            break;
    }
    
    [projectTabelView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
