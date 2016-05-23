//
//  MPImageGridView.m
//  MarketPlace
//
//  Created by Arnav Jain on 08/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPImageGridView.h"
#import "MPImageCell.h"
#import "MPPhotoBrowserLocalPhotosModel.h"
#import "MPPhotoBrowserCloudPhotosModel.h"
#import "MPPhotoUtility.h"

@interface MPImageGridView() <MPImageCellDelegate>
{

}

@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (nonatomic, strong) MPPhotoBrowserLocalPhotosModel *localModel;
@property (nonatomic, strong) MPPhotoBrowserCloudPhotosModel *cloudModel;
@property (nonatomic) NSUInteger totalImageCount;

- (UIImage *)getImageWithPage:(NSUInteger)page;
- (void)fetchImageForImageCellWithIndex:(NSUInteger)index withCell:(MPImageCell *)cell;
- (void)imageCellTappedAtIndex:(NSUInteger)index;
- (void)setupView;
- (void)unloadViewsFromCollectionView;

@end

@implementation MPImageGridView

static const int numberOfColumns = 3;

#pragma mark - CollectionView methods

- (void)initCollectionViewWithCloudPhotos:(MPPhotoBrowserCloudPhotosModel *)model
{
    assert(model != nil);

    assert(model.thumbnailURLArray != nil || model.imageURLArray != nil);

    assert(model.thumbnailURLArray.count == model.imageURLArray.count);

    self.cloudModel = model;
    NSUInteger numberOfPhotos = self.cloudModel.imageURLArray.count;
    self.totalImageCount = numberOfPhotos;

    [self setupView];

    [self.gridView reloadData];
}

- (void)initCollectionViewWithLocalPhotos:(MPPhotoBrowserLocalPhotosModel *)model
{
    assert(model != nil);

    assert(model.imagePaths != nil);

    self.localModel = model;
    NSUInteger numberOfPhotos = self.localModel.imagePaths.count;
    self.totalImageCount = numberOfPhotos;

    [self setupView];

    [self.gridView reloadData];
}

- (void)setupView
{
    // This is the cell we are using for the grid view
    [self.gridView registerNib:[UINib nibWithNibName:@"MPImageCell" bundle:nil] forCellWithReuseIdentifier:@"ImageCell"];

    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.gridView.collectionViewLayout;
    CGFloat screenWidthInPoints = [UIScreen mainScreen].bounds.size.width;
    CGFloat cellWidth = screenWidthInPoints / numberOfColumns;

    // We have square cells, so cell height = width
    CGSize thumbnailCellSize = CGSizeMake(cellWidth, cellWidth);
    flowLayout.itemSize = thumbnailCellSize;
    NSLog(@"Thumbnail cell size width is: %f", thumbnailCellSize.width);
}

- (void)unloadViewsFromCollectionView
{
    NSLog(@"Deleting all cells from the grid view");

    self.cloudModel = nil;
    self.localModel = nil;
    self.totalImageCount = 0;

    // We had only one section
    [self.gridView deleteSections:[NSIndexSet indexSetWithIndex:0]];
}

- (UIImage *)getImageWithPage:(NSUInteger)page
{
    // Can load the image from URL here, going with local images for now
    return [UIImage imageNamed:self.localModel.thumbnailPaths[page]];
}

- (void)fetchImageForImageCellWithIndex:(NSUInteger)index withCell:(MPImageCell *)cell
{
    NSURL *imageLink = self.cloudModel.imageURLArray[index];

    __weak MPImageCell *weakImageCell = cell;
    __weak NSURL *weakURL = imageLink;
    SDWebImageCompletionWithFinishedBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        MPImageCell *strongInnerImageCell = weakImageCell;

        if (!strongInnerImageCell)
            return;

        // Verify that this is the same cell (might have been reused)
        if (weakURL == imageURL)
        {
            if (image)
            {
                [strongInnerImageCell updateImageCellWithImage:image];
                //NSLog(@"Image obtained for URL: %@", imageURL);
            }
            else
                NSLog(@"Image not obtained for URL: %@", imageURL);
        }
        else
            NSLog(@"Image not obtained for URL, verification failed: %@", imageURL);
    };

    [MPPhotoUtility downloadThumbnailFromURL:imageLink withCompletionBlock:completionBlock];
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalImageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPImageCell* cell = (MPImageCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell updateImageCellForIndex:indexPath.item];

    if (self.localModel != nil)
        [cell updateImageCellWithImage:[self getImageWithPage:indexPath.item]];
    else if (self.cloudModel != nil)
        [self fetchImageForImageCellWithIndex:indexPath.item withCell:cell];

    NSLog(@"Loaded page %lu from grid view", (unsigned long)indexPath.item);

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.totalImageCount != 0)
        return 1;
    else
        return 0;
}


#pragma mark UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark MPImageCellDelegate

- (void)imageCellTappedAtIndex:(NSUInteger)index
{
    // Do something, the cell was tapped
    if ([self.delegate respondsToSelector:@selector(cellTappedAtIndex:)])
        [self.delegate cellTappedAtIndex:index];
}

@end
