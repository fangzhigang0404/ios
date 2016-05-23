/**
 * @file    MPMeasureHouseView.h
 * @brief   the view of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-22
 */

#import "MPMeasureHouseView.h"
#import "MPMeasureHouseCell.h"

@interface MPMeasureHouseView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MPMeasureHouseView
{
    UITableView *_tableView;    //!< _tableView the view of table.
    MPMeasureHouseCell *_cell;  //!< _cell the cell of tableView.
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createIssueDemandTableView];
    }
    return self;
}

- (void)createIssueDemandTableView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"MPMeasureHouseCell" bundle:nil] forCellReuseIdentifier:@"MPMeasureHouseCell"];
    _tableView.backgroundColor = ColorFromRGA(0xe9eff2, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(getNumOfSectionForMeasureHouseView)]) {
        return [self.delegate getNumOfSectionForMeasureHouseView];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *measureHousCellID = @"MPMeasureHouseCell";
    _cell = [tableView dequeueReusableCellWithIdentifier:measureHousCellID forIndexPath:indexPath];
    _cell.delegate = (id)self.delegate;
    [_cell updateCell];
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 710.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        _cell.contentView.frame = CGRectMake(0, 0, _cell.contentView.frame.size.width, _cell.contentView.frame.size.height);
        
    }];
    if ([self.delegate respondsToSelector:@selector(hidePickerInMeasureHouseWhenScroll)]) {
        [self.delegate hidePickerInMeasureHouseWhenScroll];
    }
}

#pragma mark- Public interface methods
- (void)refreshIssueDemandUI {
    [_tableView reloadData];
}

- (void)getPickerInfoInIssueAmendViewWithType:(NSString *)type
                                    componet1:(NSString *)componet1
                                    componet2:(NSString *)componet2
                                    componet3:(NSString *)componet3
                                         nian:(NSString *)nian {
    
    [_cell getInfoForIssueDemandWithType:type
                               componet1:componet1
                               componet2:componet2
                               componet3:componet3
                                    nian:nian];
}

- (void)getKeyBoardHeight:(CGFloat)height {
//    [_cell getKeyBoardHeightForCell:height];
}

@end

