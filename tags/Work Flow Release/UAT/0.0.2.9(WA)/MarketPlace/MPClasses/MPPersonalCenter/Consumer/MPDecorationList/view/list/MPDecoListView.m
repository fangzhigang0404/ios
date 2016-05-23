/**
 * @file    MPDecoListView.m
 * @brief   the view for cell.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPDecoListView.h"
#import "MPDecoListCollectionViewCell.h"
#import "MPDecoBeishuCell.h"

@interface MPDecoListView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation MPDecoListView
{
    UICollectionView *_decoListCollectionView; //!< _decoListCollectionView the view of CollectionView.
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createFindDesignersCollectionView];
    }
    return self;
}

/// Create find designers view.
- (void)createFindDesignersCollectionView
{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    layout.sectionInset = UIEdgeInsetsZero;
    _decoListCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame),CGRectGetHeight(self.frame)) collectionViewLayout:layout];
    _decoListCollectionView.backgroundColor = COLOR(236, 239, 242, 1);
    
    [_decoListCollectionView registerNib:[UINib nibWithNibName:@"MPDecoListCollectionViewCell" bundle: nil]
                     forCellWithReuseIdentifier:@"MPDecoListCollectionViewCell"];
    [_decoListCollectionView registerNib:[UINib nibWithNibName:@"MPDecoBeishuCell" bundle: nil]
              forCellWithReuseIdentifier:@"MPDecoBeishuCell"];
    
    _decoListCollectionView.showsHorizontalScrollIndicator = NO;
    _decoListCollectionView.delegate = self;
    _decoListCollectionView.dataSource = self;
    _decoListCollectionView.pagingEnabled = YES;
    
    [self addSubview:_decoListCollectionView];
}

#pragma mark -UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if([self.delegate respondsToSelector:@selector(getDecoListCount)])
        return [self.delegate getDecoListCount];
    
    return 0;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(isBeishu:)]) {
        if ([self.delegate isBeishu:indexPath.row]) {
            static NSString * beishuCellIdentifier = @"MPDecoBeishuCell";
            MPDecoBeishuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:beishuCellIdentifier forIndexPath:indexPath];
            cell.delegate = (id)self.delegate;
            [cell updateCellForIndex:indexPath.row];
            return cell;
        }
        static NSString * CellIdentifier = @"MPDecoListCollectionViewCell";
        MPDecoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.delegate = (id)self.delegate;
        [cell updateCellForIndex:indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark- Public interface methods
-(void)refreshDecoListUI {
    [_decoListCollectionView reloadData];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(draggingWithContentOffsetX:)]) {
        [self.delegate draggingWithContentOffsetX:[[NSString stringWithFormat:@"%lf",scrollView.contentOffset.x] integerValue]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(deceleratingWithContentOffsetX:)]) {
        [self.delegate deceleratingWithContentOffsetX:[[NSString stringWithFormat:@"%lf",scrollView.contentOffset.x] integerValue]];
    }
}

@end
