//
//  MPAssertsRecordViewController.m
//  MarketPlace
//
//  Created by xuezy on 16/3/8.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPAssertsRecordViewController.h"
#import "MPAssertsTransactionRecordView.h"
#import "MPDesignerTransactionRecordModel.h"
#import "MPDesignerWithdrawModel.h"
@interface MPAssertsRecordViewController ()<MPAssertsRecordViewDelegate>

@end

@implementation MPAssertsRecordViewController
{
    MPAssertsTransactionRecordView *_recordView;
    NSMutableArray *_recordArray;
    NSInteger _offset;
    NSInteger _limit;
    BOOL _isLoadMore;
    BOOL isWithdraw;
}
- (instancetype)initWithType:(MPAssetsRecordType)type {
    self = [super init];
    if (self) {
        
        if (type==MPAssetsRecordForTrade) {
            isWithdraw = NO;

        }else{
            isWithdraw = YES;

        }
      
    }
    return self;
}

- (void)tapOnLeftButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rightButton.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (isWithdraw) {
        self.titleLabel.text = @"提现记录";

    }else{
        self.titleLabel.text = @"交易记录";

    }
    
    [self initData];
    
    [self initUI];
}

- (void)initUI {
    _recordView = [[MPAssertsTransactionRecordView alloc] initWithIsWithdraw:isWithdraw withFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
    _recordView.delegate = self;
    [self.view addSubview:_recordView];

}
- (void)initData {
    _recordArray = [NSMutableArray array];
    _limit = 10;
    _offset = 0;
}

- (void)requestData {
    WS(weakSelf);
    
    if (isWithdraw) {
        [MPDesignerWithdrawModel getDesignerWithDraw:[AppController AppGlobal_GetMemberInfoObj].acs_member_id withParameter:@{@"limit":@(_limit),@"offset":@(_offset)}  success:^(NSMutableArray *array) {
            
            if (!_isLoadMore)
                [_recordArray removeAllObjects];
            
            [weakSelf endRefreshView:_isLoadMore];
            [_recordArray addObjectsFromArray:array];
            [_recordView refreshRecordUI];

            if (_recordArray.count == 0) {
                [MPAlertView showAlertWithMessage:@"您目前还没有进行提现" sureKey:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }

        } failure:^(NSError *error) {
            [weakSelf endRefreshView:_isLoadMore];
            [MPAlertView showAlertForNetError];
            NSLog(@"%@",error);

        }];
    }else {
        [MPDesignerTransactionRecordModel getDesignerTransactionTecord:[AppController AppGlobal_GetMemberInfoObj].acs_member_id withParameter:@{@"limit":@(_limit),@"offset":@(_offset)} success:^(NSMutableArray *array) {
            
            if (!_isLoadMore)
                [_recordArray removeAllObjects];
            
            [weakSelf endRefreshView:_isLoadMore];
            [_recordArray addObjectsFromArray:array];
            [_recordView refreshRecordUI];
            
            if (_recordArray.count == 0) {
                [MPAlertView showAlertWithMessage:@"您目前还没有进行交易" sureKey:^{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });

                }];
            }

        } failure:^(NSError *error) {
            [weakSelf endRefreshView:_isLoadMore];
            [MPAlertView showAlertForNetError];
            NSLog(@"%@",error);
            
        }];

    }
    
}

#pragma mark - MPAssertsRecordViewDelegate methods

- (NSInteger)getRecordCellCount {
    return [_recordArray count];
}

- (void)assertsViewRefreshLoadNewData:(void (^)())finish {
    self.refreshForLoadNew = finish;
    _offset = 0;
    _isLoadMore = NO;
    [self requestData];
}

- (void)assertsViewRefreshLoadMoreData:(void (^)())finish {
    self.refreshForLoadMore = finish;
    _offset += _limit;
    _isLoadMore = YES;
    [self requestData];
}

#pragma mark - MPRecordTableViewCellDelegate methods

-(MPDesignerTransactionRecordModel *) getRecordModelForIndex:(NSUInteger) index {
    MPDesignerTransactionRecordModel *model = nil;
    if ([_recordArray count]) {
        return [_recordArray objectAtIndex:index];
    }
    
    return model;
}

- (MPDesignerWithdrawModel *)getWithdrawModelForIndex:(NSUInteger) index {
    MPDesignerWithdrawModel *model = nil;
    if ([_recordArray count]) {
        return [_recordArray objectAtIndex:index];
    }
    
    return model;
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    
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
