/**
 * @file    MPDesignerlist.m.
 * @brief   the frame of demand list ViewController.
 * @author  Xue.
 * @version 1.0.
 * @date    2016-01-11.
 */

#import "MPDesignerlist.h"
#import "MPEditDemandViewController.h"
#import "UIImageView+WebCache.h"
#import "MPDecorationBaseModel.h"
#import "MPBiddingHallView.h"
#import "MPSearchBiddingViewController.h"
#import "MPCaseScreenViewController.h"
#import "MPOrderEmptyView.h"
@interface MPDesignerlist ()<MPBiddingViewDelegate,caseScreendelegate>
{
    
    NSMutableArray * demandArray;               //!< demandArray array for datasource.
    NSInteger _offset;                          //!< _offset offset how many.
    NSInteger _limit;                           //!< _limit limlt how many.
    BOOL _isLoadMore;
    NSString *areaString;                       //!< areaString selected area value.
    NSString *formString;                       //!< formString unit value selection.
    NSString *styleString;                      //!< styleString select the style value.
    NSString *typeStr;                          //!< typeStr select the type of value.
    NSMutableDictionary *cellSelectDict;        //!< Record all options worth position for the back to the filter interface.
    NSMutableDictionary *cellSelectTypeDict;    //!< Record all the selected values for interface back to the screening.


    MPBiddingHallView *_biddingView;            //!< _listView the view for table.
    MPOrderEmptyView *_emptyView;               //!< _emptyView the view for no needs.
}
@end

@implementation MPDesignerlist

- (void)viewWillAppear:(BOOL)animated {
    if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
        
    } else {
        [self initUpData];

    }
   
}

- (void)tapOnRightButton:(id)sender {
    MPSearchBiddingViewController *search = [[MPSearchBiddingViewController alloc] init];
    [self customPushViewController:search animated:YES];
}

- (void)tapOnLeftButton:(id)sender {
    MPCaseScreenViewController *classCation = [[MPCaseScreenViewController alloc] init];
    classCation.delegate = self;
    classCation.selectDict = cellSelectDict;
    classCation.selectTypeDict = cellSelectTypeDict;
    [self presentViewController:classCation animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    areaString = [[NSString alloc] init];
    styleString = [[NSString alloc] init];
    typeStr = [[NSString alloc] init];
    formString = [[NSString alloc] init];
    self.rightButton.hidden = YES;

    
    if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
        
    } else {
        self.menuLabel.text = nil;
        //    self.leftButton.hidden = YES;
        self.titleLabel.text = NSLocalizedString(@"Mark Hall_key", @"");
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.rightButton.frame = CGRectMake(SCREEN_WIDTH - 41, 27, 26, 26);
        [self.leftButton setTitle:@"筛选" forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftButton setBackgroundImage:nil forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        
        UIImageView *_sanjiaoImage = [[UIImageView alloc] initWithFrame:CGRectMake(55, 38, 11, 8)];
        _sanjiaoImage.image = [UIImage imageNamed:@"sanjiao"];
        [self.navgationImageview addSubview:_sanjiaoImage];

        [self initData];
        [self initUI];
    }
}

- (void)selectedClassificationDict:(NSMutableDictionary *)classficationDict withSelectDict:(NSMutableDictionary *)selectDict {
    
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
        [demandArray removeAllObjects];
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
    
    
    [self initUpData];
}

- (void)initUI {
    
    _biddingView = [[MPBiddingHallView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT-TABBAR_HEIGHT)];
    _biddingView.delegate = self;
    [self.view addSubview:_biddingView];
    
}
- (void)initData {
    demandArray = [NSMutableArray array];

    _offset = 0;
    _limit = 10;
    _isLoadMore = NO;
    areaString = [[NSString alloc] init];
    styleString = [[NSString alloc] init];
    typeStr = [[NSString alloc] init];
    formString = [[NSString alloc] init];
}

- (void)initUpData {

    NSString *offset = [NSString stringWithFormat:@"%ld",(long)_offset];
    NSString *limit = [NSString stringWithFormat:@"%ld",(long)_limit];
    
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
            _emptyView.infoLabel.text = NSLocalizedString(@"just_no_find", nil);
            _emptyView.imageView.image = [UIImage imageNamed:@"search_case_logo"];
            [self.view addSubview:_emptyView];
            
        }else{
            
            if (_emptyView) {
                [_emptyView removeFromSuperview];
                _emptyView = nil;
            }
        }

        [_biddingView refreshBiddingViewUI];
    } failure:^(NSError *error) {
        [weakSelf endRefreshView:_isLoadMore];
      
        [_biddingView refreshBiddingViewUI];

        NSLog(@"error:%@",error);
    }];
}


#pragma mark - MPFindDesignersViewDelegate methods

- (NSInteger) getBiddingCellCount {
    return [demandArray count];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
    MPDecorationNeedModel *model=[demandArray objectAtIndex:index];
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
