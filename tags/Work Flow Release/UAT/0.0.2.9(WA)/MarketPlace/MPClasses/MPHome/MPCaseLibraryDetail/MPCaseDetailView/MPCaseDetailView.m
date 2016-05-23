/**
 * @file    MPCaseDetailView.m
 * @brief   caseDetailView.
 * @author  Xue.
 * @version 1.0
 * @date    2015-12-22
 */

#import "MPCaseDetailView.h"
#import "MPCaseModel.h"
#import "UIImageView+WebCache.h"
#import "HFStretchableTableHeaderView.h"
#import "MPChatListViewController.h"
#import "MPCaseDetailTableViewCell.h"
#import "MPCaseDescriptionTableViewCell.h"
#import "MPChatRoomViewController.h"
#import "MPDesignerInfoModel.h"

@interface MPCaseDetailView ()<MPCaseDetailCellDelegate>

@property(nonatomic,strong)UIImageView *tableViewHeaderView;
@property (nonatomic,strong)HFStretchableTableHeaderView *stretchHeaderView;
@property(nonatomic,strong)MPCaseModel *caseDetailModel;

@end
@implementation MPCaseDetailView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor colorWithRed:233/255.0 green:237/255.0 blue:241/255.0 alpha:1];
//    self.caseDetailModel = [MPCaseDetailModel  getData];
    return self;
}

- (void)updateCaseDetailData:(MPCaseModel *)model {
    self.caseDetailModel = model;
    self.caseDetailArray = [[NSMutableArray alloc] initWithArray:self.caseDetailModel.images];
    [self createCaseDetailTableView];
}
- (void)backButtonClick {
    
    if ([self.delegate respondsToSelector:@selector(popViewController)]) {
        
        [self.delegate popViewController];
    }
}


- (void)createCaseDetailTableView {
    
    
    self.caseDetailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
    self.caseDetailTableView.delegate = self;
    self.caseDetailTableView.dataSource = self;
    self.caseDetailTableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    self.caseDetailTableView.showsVerticalScrollIndicator = NO;
    self.caseDetailTableView.backgroundColor = [UIColor clearColor];
    [self.caseDetailTableView registerNib:[UINib nibWithNibName:@"MPCaseDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"CASEDETAILCELL"];
    [self.caseDetailTableView registerNib:[UINib nibWithNibName:@"MPCaseDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"CasedescriptionCell"];
    [self addSubview:self.caseDetailTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        return SCREEN_WIDTH * CASE_IMAGE_RATIO + 57;
    }else {
        return SCREEN_HEIGHT - SCREEN_WIDTH * CASE_IMAGE_RATIO - NAVBAR_HEIGHT - 57;
    }

   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    if (indexPath.row == 0) {
     
        MPCaseDescriptionTableViewCell *cell = (MPCaseDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CasedescriptionCell" forIndexPath:indexPath];
        [cell updateCellWithString:self.caseDetailModel];
        cell.delegate = (id)self.delegate;
        return cell;
    }else{
        
        MPCaseDetailTableViewCell *cell = (MPCaseDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CASEDETAILCELL" forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateCellWithImageUrl:self.caseDetailModel];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)closeView {

    [self backButtonClick];
}
- (void)collectButtonClick:(UIButton *)button {
    if (button.selected) {
        
        button.selected= NO;
        
    }else{
        button.selected = YES;
        
        
    }
}

#pragma mark - stretchableTable delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.stretchHeaderView scrollViewDidScroll:scrollView];
}

- (void)viewDidLayoutSubviews
{
    [self.stretchHeaderView resizeView];
}

@end
