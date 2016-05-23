/**
 * @file    MPSearchBiddingView.m
 * @brief   the view for search bidding view.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-25
 */

#import "MPSearchBiddingView.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "MPTranslate.h"
#import "MJRefresh.h"
#import "MPBiddingTableViewCell.h"
@interface MPSearchBiddingView()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
{
    UITableView *_searchTableView;   //<! Association condition tableview.
    NSMutableArray *searchResults;   //<!searchResults array for datasource.
    UITableView *_biddingTableView;  //<!_biddingTableView result bidding tableview.
    float keyboardHeight;            //<!keyboard height.
    
    UISearchBar *searchBiddingBar;   //<!search bar.
    UIButton *fadeButton;            //<!keyboard close button.
}
//@property(nonatomic, strong) IBOutlet UISearchBar *searchBar;
//@property(nonatomic, strong) IBOutlet UIButton *fadeButton;

@end

@implementation MPSearchBiddingView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createFindView];
        [self createSearchBiddingHallView];
    }
    return self;
}

- (void)createSearchBiddingHallView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    topView.backgroundColor = [UIColor colorWithRed:0.975
                                              green:0.975
                                               blue:0.975
                                              alpha:1];
    [self addSubview:topView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(12, 21, 32, 32);
    [backButton setImage:[UIImage imageNamed:@"iconmonstr-back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(moveBack:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:backButton];
    
    fadeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fadeButton.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT);
    [fadeButton addTarget:self action:@selector(dismissFading:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:fadeButton];
    
    searchBiddingBar = [[UISearchBar alloc] initWithFrame:CGRectMake(60, 14, SCREEN_WIDTH-70, 44)];
    searchBiddingBar.searchBarStyle = UISearchBarStyleMinimal;
    searchBiddingBar.tintColor = [UIColor blackColor];
    searchBiddingBar.placeholder = @"搜索风格、户型、面积";
    searchBiddingBar.delegate = self;
    [topView addSubview:searchBiddingBar];
    
}
/// Create find designers view.
- (void)createFindView {
    
    if (_biddingTableView==nil) {
        _biddingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, self.frame.size.height-64)];
        _biddingTableView.delegate = self;
        _biddingTableView.dataSource = self;
        [_biddingTableView registerNib:[UINib nibWithNibName:@"MPBiddingTableViewCell" bundle:nil] forCellReuseIdentifier:@"MPBiddingTableViewCell"];
        _biddingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_biddingTableView];

    }
    
    [self addDesignerLibraryRefresh];
}

- (void)addDesignerLibraryRefresh {
    WS(weakSelf);
    _biddingTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(biddingViewRefreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate biddingViewRefreshLoadNewData:^{
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    
    _biddingTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        if ([weakSelf.delegate respondsToSelector:@selector(biddingViewRefreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate biddingViewRefreshLoadMoreData:^{
                [weakSelf endFooterRefresh];
            }];
        }
    }];
    [_biddingTableView.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_biddingTableView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [_biddingTableView.mj_footer endRefreshing];
}

- (void)createSearchTableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    if (_searchTableView==nil) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.backgroundColor = [UIColor whiteColor];
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [fadeButton addSubview:_searchTableView];
        
    }
    
}

- (void)removeKeyBoardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
#pragma UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == _searchTableView) {
        return 50;
    }else{
        return 124.0f;
    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _biddingTableView) {
        if([self.delegate respondsToSelector:@selector(getBiddingCellCount)])
            return [self.delegate getBiddingCellCount];

    }else{
        return searchResults.count;

    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==_biddingTableView) {
        MPBiddingTableViewCell *_cell = [tableView dequeueReusableCellWithIdentifier:@"MPBiddingTableViewCell" forIndexPath:indexPath];
        _cell.delegate = (id)self.delegate;
        [_cell updateCellForIndex:indexPath.row];
        return _cell;

    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = searchResults[indexPath.row];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
        return cell;

    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissFading:nil];

    if (tableView == _biddingTableView) {
        if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:)])
            [self.delegate didSelectItemAtIndex:indexPath.row];
    }else{
        NSString *title = [searchResults objectAtIndex:indexPath.row];
        
        searchBiddingBar.text = title;
        NSString *englishTitle = [MPTranslate stringTypeChineseToEnglishWithString:title];
        NSString *typeString = [MPTranslate stringToTypeWithString:title];
        NSLog(@"选择的分类:%@,****%@",englishTitle,typeString);
        [self.delegate stringSelectType:typeString withTitleString:englishTitle];
        
        
       // [self createFindView];

    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (void)deleteduplicateArray {
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < [searchResults count]; i++){
        
        if ([categoryArray containsObject:[searchResults objectAtIndex:i]] == NO){
            
            [categoryArray addObject:[searchResults objectAtIndex:i]];
            
        }
        
        
        
    }
    
    searchResults = categoryArray;
}

- (void)refreshBiddingViewUI {
    [_biddingTableView reloadData];
}
#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    searchResults = [[NSMutableArray alloc]init];
    if (searchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:searchBar.text]) {
        for (int i=0; i<self.hotKeywords.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:self.hotKeywords[i]]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:self.hotKeywords[i]];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:self.hotKeywords[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:self.hotKeywords[i]];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:self.hotKeywords[i]];
                    [self deleteduplicateArray];
                    
                }
            }
            else {
                NSRange titleResult=[self.hotKeywords[i] rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:self.hotKeywords[i]];
                    
                }
            }
        }
    } else if (searchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:searchBar.text]) {
        for (NSString *tempStr in self.hotKeywords) {
            NSRange titleResult=[tempStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:tempStr];
                //                [self deleteduplicateArray];
                
            }
        }
    }
    
    float height =searchResults.count*50;
    
    if (height>SCREEN_HEIGHT-NAVBAR_HEIGHT-keyboardHeight) {
        height =SCREEN_HEIGHT-NAVBAR_HEIGHT-keyboardHeight;
    }
    _searchTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    [_searchTableView reloadData];
}

- (void) keyboardWasShown:(NSNotification *) notif

{
    
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    keyboardHeight = keyboardSize.height;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    
    ///keyboardWasShown = YES;
    
}

#pragma mark - UISearchbar datasource methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"********");
    
    [searchBar setShowsCancelButton:YES];

    [self showFading];
    [self createSearchTableView];
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length > 0)
    {
        [self dismissFading:nil];
        
        if ([self.delegate respondsToSelector:@selector(onSearchTrigerred:)])
            [self.delegate onSearchTrigerred:searchBar.text];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissFading:nil];
}


#pragma mark- UIButton Actions

-(void)moveBack:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onSearchViewDismiss)])
        [self.delegate onSearchViewDismiss];
}


-(void)dismissFading:(id)sender
{
    [searchBiddingBar resignFirstResponder];
    [self endEditing:YES];
    [searchBiddingBar setShowsCancelButton:NO];
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         fadeButton.alpha = 0;
     } completion:^(BOOL finished) {
         
     }];
    
}



#pragma mark- Private methods

-(void) showFading
{
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         fadeButton.alpha = 1.0;
     } completion:^(BOOL finished) {
         
     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
