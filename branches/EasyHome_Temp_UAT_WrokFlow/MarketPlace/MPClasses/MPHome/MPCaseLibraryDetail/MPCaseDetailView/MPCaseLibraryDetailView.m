/**
 * @file    MPCaseLibraryDetailView.h
 * @brief   MPCaseLibraryDetailView.
 * @author  Xue.
 * @version 1.0
 * @date    2016-02-20
 */

#import "MPCaseLibraryDetailView.h"
#import "MPCaseDetailCollectionViewCell.h"
#import "MPCaseModel.h"
#import "UIImageView+WebCache.h"

@interface MPCaseLibraryDetailView()<UICollectionViewDataSource,UICollectionViewDelegate>

@end
@implementation MPCaseLibraryDetailView
{
    UICollectionView *_caseDetailCollectionView;
    UIImageView *_icon;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self createCaseDetailCollectionView];
    [self createDesignerView];
}

/// Create case detail view.
- (void)createCaseDetailCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    layout.sectionInset = UIEdgeInsetsZero;
    _caseDetailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame) - NAVBAR_HEIGHT) collectionViewLayout:layout];
    _caseDetailCollectionView.backgroundColor = [UIColor whiteColor];
    
    [_caseDetailCollectionView registerNib:[UINib nibWithNibName:@"MPCaseDetailCollectionViewCell" bundle: nil]
              forCellWithReuseIdentifier:@"MPCaseDetailCell"];

    _caseDetailCollectionView.showsHorizontalScrollIndicator = NO;
    _caseDetailCollectionView.delegate = self;
    _caseDetailCollectionView.dataSource = self;
    _caseDetailCollectionView.pagingEnabled = YES;
//    _caseDetailCollectionView.contentOffset = CGPointMake(CGRectGetWidth(self.frame), 0);
    
    [self addSubview:_caseDetailCollectionView];
}

- (void)createDesignerView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - NAVBAR_HEIGHT, SCREEN_WIDTH, NAVBAR_HEIGHT)];
    view.backgroundColor = COLOR(248, 249, 250, 1);
    [self addSubview:view];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = ColorFromRGA(0xd7d7d7, 1);
    [view addSubview:lineView];
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 32, 32)];
    _icon.layer.masksToBounds = YES;
    _icon.image = [UIImage imageNamed:WORK_INTRODUCTS];
    //_icon.layer.cornerRadius = 20;
    [view addSubview:_icon];
    
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 12, SCREEN_WIDTH-90, 40)];
    detailLabel.text = NSLocalizedString(@"View_the_work_details", nil);
    [view addSubview:detailLabel];
    
    UIButton *designerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    designerButton.frame = CGRectMake(0, 0, SCREEN_WIDTH, NAVBAR_HEIGHT);
    [designerButton addTarget:self action:@selector(designerButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:designerButton];
}

#pragma mark - ButtonClick
- (void)designerButtonClick {
    
    if ([self.delegate respondsToSelector:@selector(viewCaseDetail)]) {
        [self.delegate viewCaseDetail];
    }
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(getCaseDetailCellCount)])
        return [self.delegate getCaseDetailCellCount];
    
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MPCaseDetailCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MPCaseDetailCell" forIndexPath:indexPath];
    cell.delegate = (id)self.delegate;
    [cell updateCellForIndex:indexPath.row];
    return cell;

 }

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(draggingWithContentOffsetX:)]) {
        [self.delegate draggingWithContentOffsetX:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(deceleratingWithContentOffsetX:)]) {
        [self.delegate deceleratingWithContentOffsetX:scrollView.contentOffset.x];
    }
}

#pragma mark- Public interface methods
- (void)refreshCaseLibraryDetailUI:(NSString *)avatar {
    [_caseDetailCollectionView reloadData];
//    [_icon sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:ICON_HEADER_DEFAULT]];
}


@end
