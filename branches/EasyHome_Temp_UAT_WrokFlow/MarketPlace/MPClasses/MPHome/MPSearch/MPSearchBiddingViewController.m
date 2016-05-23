/**
 * @file    MPSearchBiddingViewController.m
 * @brief   the frame of MPSearchBiddingViewController.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-25
 */

#import "MPSearchBiddingViewController.h"
#import "MPSearchBiddingView.h"
#import "MPDecorationNeedModel.h"
#import "MPDecorationBaseModel.h"
#import "MPEditDemandViewController.h"
#import "MPOrderEmptyView.h"

@interface MPSearchBiddingViewController ()<MPSearchBiddingViewDelegate>
{
    MPSearchBiddingView *_searchView;   //!< _listView the view for table.
    BOOL _isLoadMore;                   //!< _isLoadMore load more or not.
    NSMutableArray * demandArray;       //!< demandArray array for datasource.
    NSInteger _offset;                  //!< _offset offset how many.
    NSInteger _limit;                   //!< _limit limlt how many.
    NSString *areaString;               //!< areaString selected area value.
    NSString *formString;               //!< formString unit value selection.
    NSString *styleString;              //!< styleString select the style value.
    NSString *typeStr;                  //!< typeStr select the type of value.
    MPOrderEmptyView *_emptyView;       //!< _emptyView the view for no needs.

}
@end

@implementation MPSearchBiddingViewController

-(id)init
{
    self = [super init];
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initData];
    areaString = [[NSString alloc] init];
    styleString = [[NSString alloc] init];
    typeStr = [[NSString alloc] init];
    formString = [[NSString alloc] init];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MPSearch" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.navgationImageview.hidden = YES;
    //_searchView = [[[NSBundle mainBundle] loadNibNamed:@"MPSearchBiddingView" owner:self options:nil] firstObject];
    _searchView = [[MPSearchBiddingView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _searchView.delegate = self;
    _searchView.hotKeywords = dictionary[@"data"];
    
    [self.view addSubview:_searchView];
    [self constraintSearchView:_searchView];
    
}
- (void)initData {
    demandArray = [NSMutableArray array];
    
    _offset = 0;
    _limit = 10;
    _isLoadMore = NO;
}
- (void)initUpData {
    
    NSString *offset = [NSString stringWithFormat:@"%ld",(long)_offset];
    NSString *limit = [NSString stringWithFormat:@"%ld",(long)_limit];
    [_searchView removeKeyBoardObserver];

    WS(weakSelf);
    [MPDecorationBaseModel createMarkHallWithUrlDict:@{@"offset":offset,@"limit":limit,@"custom_string_restroom":@"",@"custom_string_bedroom":@"",@"custom_string_area":areaString,@"custom_string_form":formString,@"custom_string_style":styleString,@"custom_string_type":typeStr} success:^(NSArray *array) {
        if (!_isLoadMore) {
            [demandArray removeAllObjects];
        }
        
        [weakSelf endRefreshView:_isLoadMore];
        [demandArray addObjectsFromArray:array];
        
        if (demandArray.count==0) {
            if (_emptyView) return;
            _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MPOrderEmptyView" owner:self options:nil] lastObject];
            _emptyView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
            _emptyView.infoLabel.text = NSLocalizedString(@"just_no_find", nil);            _emptyView.imageView.image = [UIImage imageNamed:@"search_case_logo"];
            [self.view addSubview:_emptyView];

        }else{
            if (_emptyView) {
                [_emptyView removeFromSuperview];
                _emptyView = nil;
            }

        }
        [_searchView refreshBiddingViewUI];
    } failure:^(NSError *error) {
        [weakSelf endRefreshView:_isLoadMore];
        [MPAlertView showAlertWithTitle:nil message:NSLocalizedString(@"just_tip_net_error", nil) sureKey:^{

            [weakSelf performSelector:@selector(pop) withObject:nil afterDelay:0.5];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        NSLog(@"error:%@",error);
    }];
}

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - MPFindDesignersViewDelegate methods

- (NSInteger) getBiddingCellCount {
    return [demandArray count];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    MPDecorationNeedModel *model=[demandArray objectAtIndex:index];
    
    //self.tabBarController.tabBar.hidden = YES;
    
    MPEditDemandViewController * vc = [[MPEditDemandViewController alloc]init];
    vc.needs_id = [model.needs_id description];
    vc.type = @"mark";
    vc.biddingStaus = model.bidding_status;
    [self customPushViewController:vc animated:YES];
}

- (void)biddingViewRefreshLoadNewData:(void (^)())finish {
    self.refreshForLoadNew = finish;
    _offset = 0;
    _isLoadMore = NO;
    [self initUpData];
}

- (void)biddingViewRefreshLoadMoreData:(void (^)())finish {
    self.refreshForLoadMore = finish;
    _offset += _limit;
    _isLoadMore = YES;
    [self initUpData];
}

#pragma mark - MPFindDesignersTableViewCellDelegate methods

- (MPDecorationNeedModel *)getBidingModelForIndex:(NSUInteger) index
{
    MPDecorationNeedModel *model = nil;
    
    if ([demandArray count])
        return [demandArray objectAtIndex:index];
    
    return model;
}


- (void)stringSelectType:(NSString *)typeString withTitleString:(NSString *)titleString {
    
    
    areaString = @"";
    styleString = @"";
    typeStr = @"";
    formString = @"";
    
    _isLoadMore = NO;
    _offset = 0;
    _limit = 10;
    [demandArray removeAllObjects];
    
    if ([typeString isEqualToString:@"面积"]) {
        areaString = titleString;
    }else if ([typeString isEqualToString:@"类型"]){
        typeStr = titleString;
    }else if ([typeString isEqualToString:@"风格"]){
        styleString = titleString;
    }else{
        formString = titleString;
    }
    
    [self initUpData];
}

-(void)constraintSearchView:(MPSearchBiddingView*)searchView
{
    searchView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:searchView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1
                                                           constant:0]];
}


#pragma mark MPSearchViewDelegate


-(void)onSearchTrigerred:(NSString*) searchKey
{
    //    MPCaseLibraryViewController *controller = [[MPCaseLibraryViewController alloc] init];
    //    //self.tabBarController.tabBar.hidden = YES;
    //    [self.navigationController pushViewController:controller animated:YES];
}


-(void)onSearchViewDismiss
{
    [_searchView removeKeyBoardObserver];
    [self.navigationController popViewControllerAnimated:YES];
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
