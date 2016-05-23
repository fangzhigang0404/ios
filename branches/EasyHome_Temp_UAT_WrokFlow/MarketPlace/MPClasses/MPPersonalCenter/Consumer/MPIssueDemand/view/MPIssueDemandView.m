/**
 * @file    MPIssueDemandView.m
 * @brief   the view of controller.
 * @author  niu
 * @version 1.0
 * @date    2016-2-1
 */

#import "MPIssueDemandView.h"
#import "MPIssueDemandCell.h"

@interface MPIssueDemandView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MPIssueDemandView
{
    UITableView *_tableView;        //!< _tableView the tableView.
    MPIssueDemandCell *_cell;       //!< _cell the cell of tableView.
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createIssueDemandTableView];
    }
    return self;
}

- (void)createIssueDemandTableView {
    self.backgroundColor = COLOR(237, 240, 243, 1);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MPIssueDemandCell" bundle:nil] forCellReuseIdentifier:@"MPIssueDemand"];
    _tableView.backgroundColor = ColorFromRGA(0xedf0f3, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(getNumOfSectionForIssueAmendView)]) {
        return [self.delegate getNumOfSectionForIssueAmendView];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *issueDecoCellId = @"MPIssueDemand";
    _cell = [tableView dequeueReusableCellWithIdentifier:issueDecoCellId forIndexPath:indexPath];
    _cell.delegate = (id)self.delegate;
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 628.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        _cell.contentView.frame = CGRectMake(0, 0, _cell.contentView.frame.size.width, _cell.contentView.frame.size.height);
        
    }];
    if ([self.delegate respondsToSelector:@selector(hidePickerInIssueAmendWhenScroll)]) {
        [self.delegate hidePickerInIssueAmendWhenScroll];
    }
}

#pragma mark- Public interface methods
- (void)refreshIssueDemandUI {
    [_tableView reloadData];
}

- (void)getPickerInfoInIssueAmendViewWithType:(NSString *)type componet1:(NSString *)componet1 componet2:(NSString *)componet2 componet3:(NSString *)componet3 {
    [_cell getInfoForIssueDemandWithType:type componet1:componet1 componet2:componet2 componet3:componet3];
}

- (void)updateDecorationDetailUI:(MPDecorationNeedModel *)model {
    [_cell updateCellForDecorationDetail:model];
}

@end
