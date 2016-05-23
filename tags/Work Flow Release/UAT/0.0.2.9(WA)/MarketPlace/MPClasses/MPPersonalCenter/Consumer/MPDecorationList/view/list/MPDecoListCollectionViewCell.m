/**
 * @file    MPDecoListCollectionViewCell.m
 * @brief   the view for cell.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPDecoListCollectionViewCell.h"
#import "MPDecoDesiView.h"
#import "MPDecoTopView.h"
#import "MPDecoInfoCell.h"

@interface MPDecoListCollectionViewCell ()<UITableViewDataSource,UITableViewDelegate>

/// tableView.
@property (weak, nonatomic) IBOutlet UITableView *designerTableView;
@end

@implementation MPDecoListCollectionViewCell
{
    NSInteger _designerCount;   //!< _designerCount count for designers.
    NSInteger _index;           //!< _index the index for model in datasource.
    NSString *_showBtnImage;    //!< _showBtnImage the string for button.
}

- (void)awakeFromNib {
    [self initDesignerTableView];
}

- (void)initDesignerTableView {
    [self.designerTableView registerNib:[UINib nibWithNibName:@"MPDecoInfoCell" bundle:nil] forCellReuseIdentifier:@"MPDecoInfoCell"];
    self.designerTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateCellForIndex:(NSUInteger)index {

    if ([self.delegate respondsToSelector:@selector(getDecoListHeaderCountForIndex:)]) {
        
        _designerCount = [self.delegate getDecoListHeaderCountForIndex:index];
        
        _index = index;
        
        [self.designerTableView reloadData];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _designerCount + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        if ([self.delegate respondsToSelector:@selector(showDecoInfoWithSection:)]) {
            NSInteger rows = [self.delegate showDecoInfoWithSection:_index];
            if (rows)
                _showBtnImage = DECORATION_NEED_CLOSE;
            else
                _showBtnImage = DECORATION_NEED_OPEN;
            return rows;
        }
    }
    return 0;
} 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 200.0f;
    }
    return 67.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        MPDecoTopView *topView = [[[NSBundle mainBundle] loadNibNamed:@"MPDecoTopView" owner:self options:nil] lastObject];
        topView.frame = CGRectMake(0, 0, CGRectGetWidth(self.designerTableView.frame), 134);
        topView.delegate = (id)self.delegate;
        [topView.showButton setImage:[UIImage imageNamed:_showBtnImage] forState:UIControlStateNormal];
        [topView updateViewAtIndex:section collectionRow:_index];
        return topView;
    }
    
    MPDecoDesiView *desiView = [[[NSBundle mainBundle] loadNibNamed:@"MPDecoDesiView" owner:self options:nil] lastObject];
    desiView.frame = CGRectMake(0, 0, CGRectGetWidth(self.designerTableView.frame), 67);
    desiView.delegate = (id)self.delegate;
    [desiView updateViewAtIndex:section];
    return desiView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *decoInfoCellId = @"MPDecoInfoCell";
    MPDecoInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:decoInfoCellId forIndexPath:indexPath];
    cell.delegate = (id)self.delegate;
    [cell updateCellAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 215.0f;
}

@end
