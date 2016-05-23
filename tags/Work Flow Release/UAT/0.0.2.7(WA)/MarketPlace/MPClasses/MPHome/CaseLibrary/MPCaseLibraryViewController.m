/**
 * @file    MPCaseLibraryViewController.h
 * @brief   the frame of MPCaseLibraryViewController.
 * @author  Xue
 * @version 1.0
 * @date    2015-12-10
 */

#import "MPCaseLibraryViewController.h"
#import "MPCaseLibraryView.h"
#import "MPCaseDetailViewController.h"
#import "MPChatListViewController.h"
#import "MPCaseBaseModel.h"
#import "MPCaseLibraryDetailViewController.h"
#import "MPCaseScreenViewController.h"
#import "MPSearchCaseViewController.h"
#import "MPOrderEmptyView.h"
@interface MPCaseLibraryViewController ()<MPCaseViewDelegate,caseScreendelegate>

@end

@implementation MPCaseLibraryViewController
{
    MPCaseLibraryView *consumerCaseView;       //!< _listView the view for table.
    NSInteger _offset;                         //!< _offset offset how many.
    NSInteger _limit;                          //!< _limit limlt how many.
    BOOL _isLoadMore;
    NSMutableArray *_consumerArray;             //!< demandArray array for datasource.
    NSString *areaString;                       //!< areaString selected area value.
    NSString *formString;                       //!< formString unit value selection.
    NSString *styleString;                      //!< styleString select the style value.
    NSString *typeStr;                          //!< typeStr select the type of value.
    NSMutableDictionary *cellSelectDict;        //!< Record all options worth position for the back to the filter interface.
    NSMutableDictionary *cellSelectTypeDict;     //!< Record all the selected values for interface back to the screening.
    MPOrderEmptyView *_emptyView;                //!< _emptyView the view for no cases.

}

- (void)tapOnRightButton:(id)sender
{
    MPSearchCaseViewController *search = [[MPSearchCaseViewController alloc] init];

    [self customPushViewController:search animated:YES];

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    areaString = [[NSString alloc] init];
    styleString = [[NSString alloc] init];
    typeStr = [[NSString alloc] init];
    formString = [[NSString alloc] init];
    cellSelectDict = [NSMutableDictionary dictionary];
    cellSelectTypeDict = [NSMutableDictionary dictionary];

    // Do any additional setup after loading the view.
    //self.tabBarController.tabBar.hidden = YES;
    self.titleLabel.text = NSLocalizedString(@"caseKey",nil);
    [self initData];
//    self.rightButton.hidden = YES;
    self.rightButton.frame = CGRectMake(SCREEN_WIDTH - 41, 22, 40, 40);
    self.rightButton.imageEdgeInsets = UIEdgeInsetsMake(10, 4, 10, 16);

    [self createScreenButton];
    consumerCaseView = [[MPCaseLibraryView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
    consumerCaseView.delegate = self;
    [self.view addSubview:consumerCaseView];
    
}

- (void)createScreenButton {
    UIButton *screenButton = [UIButton buttonWithType:UIButtonTypeCustom];
    screenButton.frame = CGRectMake(SCREEN_WIDTH-85, 22,40,40);
//    [screenButton setBackgroundImage:[UIImage imageNamed:SEARCH_CASE_TOP] forState:UIControlStateNormal];
    [screenButton setImage:[UIImage imageNamed:SEARCH_CASE_TOP] forState:UIControlStateNormal];
    [screenButton addTarget:self action:@selector(screenClick) forControlEvents:UIControlEventTouchUpInside];
//    screenButton.backgroundColor = [UIColor redColor];
    [self.navgationImageview addSubview:screenButton];
}

- (void)screenClick {
    MPCaseScreenViewController *classCation = [[MPCaseScreenViewController alloc] init];
    classCation.delegate = self;
    
    NSLog(@"我先知道的数据有没有:%@",cellSelectTypeDict);
    classCation.selectDict = [NSMutableDictionary dictionaryWithDictionary:cellSelectDict];
    classCation.selectTypeDict = [NSMutableDictionary dictionaryWithDictionary:cellSelectTypeDict];

    [self presentViewController:classCation animated:YES completion:nil];

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
    [MPCaseBaseModel getCaseLibrayWithOffset:[NSString stringWithFormat:@"%ld",(long)_offset] limit:[NSString stringWithFormat:@"%ld",(long)_limit] custom_string_area:areaString custom_string_form:formString custom_string_style:styleString custom_string_type:typeStr custom_string_keywords:@"" success:^(NSArray *array) {
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

        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [consumerCaseView refreshCasesLibraryUI];
        });

    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
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


/// Rewrite the superclass showMenu method.
- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - MPDesignersLibraryViewDelegate methods

-(NSUInteger) getCaseCellCount
{
    return [_consumerArray count];
}


-(void) didSelectedItemAtIndex:(NSUInteger)index;
{
    //self.tabBarController.tabBar.hidden = YES;
    MPCaseModel * model = [_consumerArray objectAtIndex:index];
    
    MPCaseLibraryDetailViewController *caseDetail = [[MPCaseLibraryDetailViewController alloc] init];
    caseDetail.model = model;
    caseDetail.arrayDS = _consumerArray;
    caseDetail.index = index;
    caseDetail.case_id = model.case_id;
    [self customPushViewController:caseDetail animated:YES];

//    MPCaseDetailViewController *detail = [[MPCaseDetailViewController alloc] init];
//    detail.case_Id = model.case_id;
//    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - MPCaseLibraryTableViewCellDelegate methods

-(MPCaseModel *)getCaseLibraryModelForIndex:(NSUInteger) index
{
    MPCaseModel* model = nil;
    //caseArray
    if ([_consumerArray count])
        return [_consumerArray objectAtIndex:index];
    
    return model;
}


- (void)selectedClassificationDict:(NSMutableDictionary *)classficationDict withSelectDict:(NSMutableDictionary *)selectDict{
    
    NSLog(@"********筛选的条件:%@",classficationDict);
    cellSelectDict = selectDict;
    cellSelectTypeDict = classficationDict;
    areaString = @"";
    styleString = @"";
    typeStr = @"";
    formString = @"";

    NSArray *keyArray = [classficationDict allKeys];
    
    for (int i = 0; i<keyArray.count; i++) {
        
        NSString *stringValue = [keyArray objectAtIndex:i];
        
        _isLoadMore = NO;
        _offset = 0;
        _limit = 10;
        [_consumerArray removeAllObjects];
        
        NSString *selectString = [classficationDict objectForKey:stringValue];
        
        if ([stringValue isEqualToString:@"面积"]) {
            if ([selectString isEqualToString:@"全部"]) {
                areaString = @"";
            }else{
                areaString = [MPTranslate stringTypeChineseToEnglishWithString:selectString];
                
            }
        }else if ([stringValue isEqualToString:@"类型"]){
            if ([selectString isEqualToString:@"全部"]) {
                typeStr = @"";
            }else{
                typeStr = [MPTranslate stringTypeChineseToEnglishWithString:selectString];
                
            }
            
        }else if ([stringValue isEqualToString:@"风格"]){
            if ([selectString isEqualToString:@"全部"]) {
                styleString = @"";
            }else{
                styleString = [MPTranslate stringTypeChineseToEnglishWithString:selectString];
                
            }
        }else if ([stringValue isEqualToString:@"户型"]){
            if ([selectString isEqualToString:@"全部"]) {
                formString = @"";
            }else{
                formString = [MPTranslate stringTypeChineseToEnglishWithString:selectString];
                
            }
        }
        
    }
    
    
    [self requestData];
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
