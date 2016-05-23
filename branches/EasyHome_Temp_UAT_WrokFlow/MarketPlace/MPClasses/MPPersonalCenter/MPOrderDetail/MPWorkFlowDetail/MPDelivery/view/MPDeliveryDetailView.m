//
//  MPDeliveryDetail.m
//  MarketPlace
//
//  Created by Jiao on 16/3/24.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryDetailView.h"

#define MPDELIVERYCELL @"MPDeliveryDetailCell"
@interface MPDeliveryDetailView() <UICollectionViewDelegate, UICollectionViewDataSource>

@end
@implementation MPDeliveryDetailView
{
    UICollectionView *_collectionView;
    NSInteger _cType;
}
- (instancetype)initWithFrame:(CGRect)frame withcType:(NSInteger)cType {
    self = [super initWithFrame:frame];
    if (self) {
        _cType = cType;
        [self createCollectionView];
    }
    return self;
}

- (void)createCollectionView {
    self.backgroundColor = COLOR(234, 238, 241, 1);
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5 );
    
    CGFloat bottomH = ([AppController AppGlobal_GetIsDesignerMode] && (_cType == 1 || _cType == 2)) ? 75 : 0;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height - bottomH) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.bounces = YES;
    [_collectionView registerNib:[UINib nibWithNibName:@"MPDeliveryDetailCell" bundle:nil] forCellWithReuseIdentifier:MPDELIVERYCELL];
    [self addSubview:_collectionView];
    
    flowLayout.minimumInteritemSpacing = 0;
    
    [_collectionView setCollectionViewLayout:flowLayout];
    _collectionView.backgroundColor = COLOR(234, 238, 241, 1);
    
    if ([AppController AppGlobal_GetIsDesignerMode] && (_cType == 1 || _cType == 2)) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(16, self.frame.size.height - 60, SCREEN_WIDTH - 32, 45)];
        button.layer.cornerRadius = 8.0;
        button.backgroundColor = COLOR(0, 132, 255, 1);
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTintColor:COLOR(255, 255, 255, 1)];
        [button addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}

- (void)confirmBtnClick:(id)sender {
    [self.delegate confirmDelivery];
}

- (void)refreshDetailView {
    [_collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return [self.delegate getFilesArray].count;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MPDeliveryDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MPDELIVERYCELL forIndexPath:indexPath];
    cell.delegate = (id)self.delegate;
    [cell updateCellForIndex:indexPath.row withcType:_cType];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH-25)/4, (SCREEN_WIDTH-25)/4 + 22);
}

- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}
@end
