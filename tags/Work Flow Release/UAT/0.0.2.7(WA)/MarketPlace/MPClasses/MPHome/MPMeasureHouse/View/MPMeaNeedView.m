/**
 * @file    MPMeaNeedView.m
 * @brief   the view of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-25
 */

#import "MPMeaNeedView.h"
#import "MPAlertView.h"
#import "MJRefresh.h"
#import "MPMeasureTool.h"
#import "MPMeaInfoHeader.h"
#import "MPMeaNeedInfoCell.h"

@interface MPMeaNeedView ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UILabel *measureDateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *measureDateStatus;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *measurePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@end

@implementation MPMeaNeedView
{
    NSInteger _seleted;
    NSString *_measureDate;
}

- (void)awakeFromNib {
    self.bgView.clipsToBounds = YES;
    self.bgView.layer.borderColor = ColorFromRGA(0xd7d7d7, 1).CGColor;
    self.bgView.layer.borderWidth = 1.0f;
    
    self.sendBtn.clipsToBounds = YES;
    self.sendBtn.layer.cornerRadius = 8.0f;
    
    [self.measureDateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                                 initWithTarget:self
                                                 action:@selector(chooseMeasureDateAction)]];
    
    [self.actionView addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(hidePickView)]];
    self.actionView.hidden = YES;
    self.tableView.hidden = YES;
    [self createIssueDemandTableView];
}

- (void)hidePickView {
    if ([self.delegate respondsToSelector:@selector(hidePopupUI)]) {
        [self.delegate hidePopupUI];
    }
}

- (IBAction)sendBtnAction:(id)sender {
    [self setSendButtonUnenable:sender];
    
    if ([self.delegate respondsToSelector:@selector(hidePopupUI)]) {
        [self.delegate hidePopupUI];
    }
    
    if (_measureDate.length == 0) {
        [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_check_measure_time", nil)
                                  sureKey:nil];
        
        [self setSendButtonEnable:sender];
        return;
    }
    WS(weakSelf);
    if ([self.delegate respondsToSelector:@selector(sendMeasureNeedWithDate:complete:)]) {
        [self.delegate sendMeasureNeedWithDate:_measureDate complete:^{
            [weakSelf setSendButtonEnable:sender];
        }];
    }
}

- (void)chooseMeasureDateAction {
    if ([self.delegate respondsToSelector:@selector(chooseMeasureDateInPicker)]) {
        [self.delegate chooseMeasureDateInPicker];
    }
}

- (void)initData {
    _seleted = 0;
}

- (void)createIssueDemandTableView {
    [_tableView registerNib:[UINib nibWithNibName:@"MPMeaInfoCell" bundle:nil] forCellReuseIdentifier:@"MPMeaInfoCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"MPMeaNeedInfoCell" bundle:nil] forCellReuseIdentifier:@"MPMeaNeedInfoCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    WS(weakSelf);
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if ([weakSelf.delegate respondsToSelector:@selector(loadMoreDataComplete:)]) {
            [weakSelf.delegate loadMoreDataComplete:^{
                [_tableView.mj_footer endRefreshing];
            }];
        }
    }];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.delegate respondsToSelector:@selector(getSectionInMeaNeedTableView)]) {
        return [self.delegate getSectionInMeaNeedTableView];
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(getRowsInMeaNeedTableView:)]) {
        return [self.delegate getRowsInMeaNeedTableView:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *measureInfoCellID = @"MPMeaNeedInfoCell";
    MPMeaNeedInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:measureInfoCellID forIndexPath:indexPath];
    cell.delegate = (id)self.delegate;
    [cell updateMeaNeedInfoCell];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MPMeaInfoHeader *header = [[[NSBundle mainBundle] loadNibNamed:@"MPMeaInfoHeader" owner:self options:nil] lastObject];
    header.delegate = (id)self.delegate;
    [header updateMeaInfoHeaderViewAtIndex:section seleted:_seleted];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 258.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 64.0f;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(hidePopupUI)]) {
        [self.delegate hidePopupUI];
    }
}

#pragma mark- Public interface methods
- (void)refreshMeaInfoUIWithSeletedIndex:(NSInteger)seleted {
    _seleted = seleted;
    [_tableView reloadData];
    self.actionView.hidden = NO;
    self.tableView.hidden = NO;

    if ([self.delegate respondsToSelector:@selector(getMeasurePriceForMeaNeedView)]) {
        NSString *measurePrice = [self.delegate getMeasurePriceForMeaNeedView];
        self.measurePriceLabel.text = [NSString stringWithFormat:@"%@%@",
                                       measurePrice,
                                       NSLocalizedString(@"just_yuan_", nil)];
    }
}

- (void)getMeaDateWithComponet1:(NSString *)componet1
                      componet2:(NSString *)componet2
                      componet3:(NSString *)componet3
                           nian:(NSString *)nian {
    if ([self transformationMeasureTime:componet1 day:componet2 hour:componet3 nian:nian]) {
        self.measureDateStatus.hidden = YES;
        self.measureDateLabel.text = [NSString stringWithFormat:@"%@%@ %@ %@ %@",
                                      nian,
                                      NSLocalizedString(@"nian", nil),
                                      componet1,
                                      componet2,
                                      componet3];
    }
}
    
    
- (BOOL)transformationMeasureTime:(NSString *)month day:(NSString *)day hour:(NSString *)hour nian:(NSString *)nian{
    month = [month substringToIndex:month.length - 1];
    day   = [day substringToIndex:day.length - 1];
    hour  = [hour substringToIndex:hour.length - 1];
    if (![MPMeasureTool isCurrentDataOverMeasure:[nian integerValue]
                                           month:[month integerValue]
                                             day:[day integerValue]
                                            hour:[hour integerValue]]) {
        _measureDate = [NSString stringWithFormat:@"%@-%@-%@ %@:00:00",nian, month, day, hour];
        return YES;
    } else {
        [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_seleted_time", nil)
                                  sureKey:nil];
        return NO;
    }
}

- (void)setSendButtonUnenable:(UIButton *)button {
    button.enabled = NO;
    button.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSendButtonEnable:(UIButton *)button {
    button.enabled = YES;
    button.backgroundColor = ColorFromRGA(0x0084ff, 1);
}

@end
