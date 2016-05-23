/**
 * @file    MPSearchCaseViewController.m
 * @brief   Search the viewcontroller.
 * @author  Xue.
 * @version 1.0.
 * @date    2015-12-15.
 */

#import "MPSearchCaseViewController.h"
#import "MPCaseLibraryViewController.h"
#import "MPSearchView.h"
#import "MPCaseModel.h"
#import "MPCaseBaseModel.h"
#import "MPDesignerDetailViewController.h"
#import "MPCaseDetailViewController.h"
#import "MPTranslate.h"
#import "MPOrderEmptyView.h"
#import "MPCaseLibraryDetailViewController.h"
@interface MPSearchCaseViewController() <MPSearchViewDelegate>
{
    MPSearchView *_searchView;          //!< _listView the view for table.
    BOOL _isLoadMore;                   //!< _isLoadMore load more or not.
    NSMutableArray *_consumerArray;     //!< _consumerArray array for datasource.
    NSInteger _offset;                  //!< _offset offset how many.
    NSInteger _limit;                   //!< _limit limlt how many.
    
    NSString *areaString;               //!< areaString selected area value.
    NSString *formString;               //!< formString unit value selection.
    NSString *styleString;              //!< styleString select the style value.
    NSString *typeStr;                  //!< typeStr select the type of value.
    NSString *keywordsStr;              //!< keyword string.
    MPOrderEmptyView *_emptyView;       //!< _emptyView the view for no cases.

}
@end

@implementation MPSearchCaseViewController


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
    keywordsStr = [[NSString alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"MPSearch" ofType:@"plist"];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    self.navgationImageview.hidden = YES;
    _searchView = [[[NSBundle mainBundle] loadNibNamed:@"MPSearchView" owner:self options:nil] firstObject];
    _searchView.delegate = self;

    _searchView.hotKeywords = dictionary[@"data"];
    
    [self.view addSubview:_searchView];
    [self constraintSearchView:_searchView];
}
- (void)initData {
    _consumerArray= [NSMutableArray array];
    _isLoadMore = NO;
    _offset = 0;
    _limit = 10;
}
- (void)requestData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    WS(weakSelf);
    [MPCaseBaseModel getCaseLibrayWithOffset:[NSString stringWithFormat:@"%ld",(long)_offset] limit:[NSString stringWithFormat:@"%ld",(long)_limit] custom_string_area:areaString custom_string_form:formString custom_string_style:styleString custom_string_type:typeStr custom_string_keywords:keywordsStr success:^(NSArray *array) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });

        if (!_isLoadMore)
            [_consumerArray removeAllObjects];
        [weakSelf endRefreshView:_isLoadMore];
        [_consumerArray addObjectsFromArray:array];
        if (_consumerArray.count==0) {

            if (_emptyView) return;
            _emptyView = [[[NSBundle mainBundle] loadNibNamed:@"MPOrderEmptyView" owner:self options:nil] lastObject];
            _emptyView.frame = CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT);
            _emptyView.infoLabel.text = NSLocalizedString(@"just_no_find", nil);
            _emptyView.imageView.image = [UIImage imageNamed:@"search_case_logo"];
            [self.view addSubview:_emptyView];

        }else{
            
            if (_emptyView) {
                [_emptyView removeFromSuperview];
                _emptyView = nil;
            }
        }
        [_searchView refreshFindDesignersUI];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });

        [MPAlertView showAlertForNetError];
        [weakSelf endRefreshView:_isLoadMore];
    }];
}

- (void)refreshLoadNewData:(void (^)())finish {
    self.refreshForLoadNew = finish;
    _isLoadMore = NO;
    _offset = 0;
    [self requestData];
    
}

- (void)refreshLoadMoreData:(void (^)())finish {
    self.refreshForLoadMore = finish;
    _isLoadMore = YES;
    _offset += _limit;
    [self requestData];
}
#pragma mark -------MPHomeViewDelegate, MPHomeViewCellDelegate--------

- (MPCaseModel *) getDatamodelForIndex:(NSUInteger) index
{
    return [_consumerArray objectAtIndex:index];
}

- (void) designerIconClickedAtIndex:(NSUInteger) consumer
{
    MPCaseModel *caseModel = _consumerArray[consumer];
    MPDesignerInfoModel *model = caseModel.designer_info;
    model.member_id = caseModel.designer_id;
    
    MPDesignerDetailViewController *detail = [[MPDesignerDetailViewController alloc]
                                              initWithIsDesignerCenter:NO
                                              designerInfoModel:model
                                              isConsumerNeeds:NO
                                              needInfo:nil
                                              needInfoIndex:0];
    
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)chatButtonClickedAtIndex:(NSUInteger)consumer {
    MPCaseModel *model = _consumerArray[consumer];
    
    NSLog(@"%@",model.designer_id);
    
    if ([AppController AppGlobal_GetLoginStatus]) {
        
        [AppController chatWithVC:self
                       ReceiverID:[model.designer_id description]
              ReceiverHomeStyleID:model.hs_designer_uid
                     receiverName:model.designer_info.nick_name
                          assetID:nil
                         isQRScan:NO];
        
    } else {
        [AppController AppGlobal_ProccessLogin];
    }
}


- (void)didSelectedItemAtIndex:(NSUInteger)index {
//    MPCaseModel *model= [_consumerArray objectAtIndex:index];
//    MPCaseDetailViewController *detail = [[MPCaseDetailViewController alloc] init];
//    NSLog(@"%@",model.case_id);
//    detail.case_Id = model.case_id;
//    [self.navigationController pushViewController:detail animated:YES];
    
    MPCaseModel * model = [_consumerArray objectAtIndex:index];
    
    MPCaseLibraryDetailViewController *caseDetail = [[MPCaseLibraryDetailViewController alloc] init];
    caseDetail.model = model;
    caseDetail.arrayDS = _consumerArray;
    caseDetail.index = index;
    caseDetail.case_id = model.case_id;
    [self customPushViewController:caseDetail animated:YES];

}


- (NSUInteger) getNumberOfItemsInCollection {
    return _consumerArray.count;
}

- (void)stringSelectType:(NSString *)typeString withTitleString:(NSString *)titleString {
    
    areaString = @"";
    styleString = @"";
    typeStr = @"";
    formString = @"";
    keywordsStr= @"";
    _isLoadMore = NO;
    _offset = 0;
    _limit = 10;
    [_consumerArray removeAllObjects];
    
    if ([typeString isEqualToString:@"面积"]) {
        areaString = titleString;
    }else if ([typeString isEqualToString:@"类型"]){
        typeStr = titleString;
    }else if ([typeString isEqualToString:@"风格"]){
        styleString = titleString;
    }else{
        formString = titleString;
    }
    
    [self requestData];

}

-(void)constraintSearchView:(MPSearchView*)searchView
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

    NSLog(@"搜索到条件:%@",searchKey);
    typeStr = @"";
    formString = @"";
    styleString = @"";
    areaString = @"";
    keywordsStr = [searchKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self requestData];

}

-(void)onSearchViewDismiss
{
    [_searchView removeKeyBoardObserver];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
