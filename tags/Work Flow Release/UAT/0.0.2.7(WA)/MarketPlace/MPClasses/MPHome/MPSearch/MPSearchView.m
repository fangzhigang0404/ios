/**
 * @file    MPSearchView.m
 * @brief   Search  the view.
 * @author  Xue.
 * @version 1.0.
 * @date    2015-12-15.
 */

#import "MPSearchView.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"
#import "MPTranslate.h"
#import "MJRefresh.h"
#import "MPHomeViewCell.h"
@interface MPSearchView()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
{
    UITableView *_searchTableView;
    NSMutableArray *searchResults;
    UICollectionView *_homeCollectionView;
    float keyboardHeight;
}
@property(nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property(nonatomic, strong) IBOutlet UIButton *fadeButton;

@end

#define CELL_HEIGHT 40

@implementation MPSearchView
- (void)createCollectionView
{
    if (_homeCollectionView==nil) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.bounds.size.width, SCREEN_WIDTH * CASE_IMAGE_RATIO + 49);
        flowLayout.sectionInset = UIEdgeInsetsZero;
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _homeCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) collectionViewLayout:flowLayout];
        _homeCollectionView.contentInset = UIEdgeInsetsMake(NAVBAR_HEIGHT, 0, 0, 0);
        [self addSubview:_homeCollectionView];
        [self sendSubviewToBack:_homeCollectionView];

        _homeCollectionView.delegate = self;
        _homeCollectionView.dataSource = self;
        _homeCollectionView.showsVerticalScrollIndicator = NO;
        _homeCollectionView.backgroundColor = [UIColor clearColor];
        [_homeCollectionView registerNib:[UINib nibWithNibName:@"MPHomeViewCell" bundle:nil] forCellWithReuseIdentifier:@"MPHomeViewCell"];
        _homeCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self addRefresh];

    }
}

/// add refresh load more data & load new data
- (void)addRefresh {
    WS(weakSelf);
    /// add head refresh.
    _homeCollectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshLoadNewData:)]) {
            [weakSelf endFooterRefresh];
            [weakSelf.delegate refreshLoadNewData:^() {
                [weakSelf endHeaderRefresh];
            }];
        }
    }];
    _homeCollectionView.mj_header.automaticallyChangeAlpha = NO;
    _homeCollectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(refreshLoadMoreData:)]) {
            [weakSelf endHeaderRefresh];
            [weakSelf.delegate refreshLoadMoreData:^() {
                [weakSelf endFooterRefresh];
            }];
        }
    }];
//    [_homeCollectionView.mj_header beginRefreshing];
}

/// end header refresh
- (void)endHeaderRefresh {
    [_homeCollectionView.mj_header endRefreshing];
}

/// end footer refresh
- (void)endFooterRefresh {
    [_homeCollectionView.mj_footer endRefreshing];
}

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.delegate getNumberOfItemsInCollection];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPHomeViewCell* cell = (MPHomeViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"MPHomeViewCell" forIndexPath:indexPath];
    cell.delegate = (id)self.delegate;
    [cell updateCellUIForIndex:indexPath.item];
    return cell;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


#pragma mark UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    [self.delegate didSelectedItemAtIndex:indexPath.item];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void) refreshFindDesignersUI {
    [_homeCollectionView reloadData];
}
- (void)createSearchTableView {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    if (_searchTableView==nil) {
        
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height)];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.backgroundColor = [UIColor whiteColor];
        _searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.fadeButton addSubview:_searchTableView];

    }
    
}

- (void)removeKeyBoardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}
#pragma UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = searchResults[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor blackColor];
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *title = [searchResults objectAtIndex:indexPath.row];
    
    self.searchBar.text = title;
    NSString *englishTitle = [MPTranslate stringTypeChineseToEnglishWithString:title];
    NSString *typeString = [MPTranslate stringToTypeWithString:title];
    NSLog(@"选择的分类:%@,****%@",englishTitle,typeString);
    [self.delegate stringSelectType:typeString withTitleString:englishTitle];
    [self dismissFading:nil];

    
    [self createCollectionView];
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
    
    _searchTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

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
        [self createCollectionView];

        if ([self.delegate respondsToSelector:@selector(onSearchTrigerred:)])
            [self.delegate onSearchTrigerred:searchBar.text];
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self dismissFading:nil];
}


#pragma mark- UIButton Actions

-(IBAction)moveBack:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(onSearchViewDismiss)])
        [self.delegate onSearchViewDismiss];
}


-(IBAction)dismissFading:(id)sender
{
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:NO];
    
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         self.fadeButton.alpha = 0;
     } completion:^(BOOL finished) {
         
     }];
    
}


#pragma mark- Private methods

-(void) showFading
{
    [UIView animateWithDuration:0.3 animations:
     ^(void){
         self.fadeButton.alpha = 1.0;
        
     } completion:^(BOOL finished) {
         
     }];
}

@end
