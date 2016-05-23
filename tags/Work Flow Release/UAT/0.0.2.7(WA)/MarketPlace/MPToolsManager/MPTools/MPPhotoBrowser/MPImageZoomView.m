//
//  MPImageZoomView.m
//  MarketPlace
//
//  Created by Arnav Jain on 08/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPImageZoomView.h"
#import "MPPhotoBrowserLocalPhotosModel.h"
#import "MPPhotoBrowserCloudPhotosModel.h"
#import "MPPhotoUtility.h"

@interface MPImageZoomView() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSMutableArray *imageViewList;
@property (nonatomic, strong) MPPhotoBrowserLocalPhotosModel *localModel;
@property (nonatomic, strong) MPPhotoBrowserCloudPhotosModel *cloudModel;
@property (nonatomic) NSUInteger totalImageCount;

- (UIImage *)getImageFromPath:(NSString *)path;
- (UIImage *)getImageWithPage:(NSUInteger)page;
- (void)gotoPage:(NSUInteger)page;
- (void)loadScrollViewWithCloudPage:(NSUInteger)page;
- (void)loadScrollViewWithLocalPage:(NSUInteger)page;
- (void)loadScrollViewWithPage:(NSUInteger)page;
- (void)setupScrollView:(NSUInteger)numberOfPages;
- (void)unloadInvisibleViewsFromScrollView:(NSUInteger)currentPage;
- (void)unloadViewsFromScrollView;

@end

@implementation MPImageZoomView

#pragma mark - init methods

- (void)initScrollViewWithCloudPhotos:(MPPhotoBrowserCloudPhotosModel *)model
{
    [self initScrollViewWithCloudPhotos:model gotoPage:0];
}

- (void)initScrollViewWithCloudPhotos:(MPPhotoBrowserCloudPhotosModel *)model gotoPage:(NSUInteger)page
{
    assert(model != nil);

    assert(model.thumbnailURLArray != nil || model.imageURLArray != nil);

    assert(model.thumbnailURLArray.count == model.imageURLArray.count);

    self.cloudModel = model;
    NSUInteger numberOfPhotos = self.cloudModel.imageURLArray.count;
    self.totalImageCount = numberOfPhotos;

    [self setupScrollView:numberOfPhotos];

    [self gotoPage:page];
}

- (void)initScrollViewWithLocalPhotos:(MPPhotoBrowserLocalPhotosModel *)model
{
    [self initScrollViewWithLocalPhotos:model gotoPage:0];
}

- (void)initScrollViewWithLocalPhotos:(MPPhotoBrowserLocalPhotosModel *)model gotoPage:(NSUInteger)page
{
    assert(model != nil);

    assert(model.imagePaths != nil);

    self.localModel = model;
    NSUInteger numberOfPhotos = self.localModel.imagePaths.count;
    self.totalImageCount = numberOfPhotos;

    [self setupScrollView:numberOfPhotos];

    [self gotoPage:page];
}

- (void)setupScrollView:(NSUInteger)numberOfPages
{
    self.scrollView.contentSize = CGSizeMake
    (CGRectGetWidth(self.scrollView.frame) * numberOfPages, CGRectGetHeight(self.scrollView.frame));

    self.scrollView.scrollsToTop = NO;

    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage = 0;

    self.imageViewList = [[NSMutableArray alloc] init];

    for (int i = 0; i < numberOfPages; ++i)
        [self.imageViewList addObject:[NSNull null]];
}

- (UIImage *)getImageWithPage:(NSUInteger)page
{
    assert (self.localModel != nil);

    return [self getImageFromPath:self.localModel.imagePaths[page]];
}

- (UIImage *)getImageFromPath:(NSString *)path
{
    UIImage *image = [UIImage imageNamed:path];

    assert(image);

    return image;
}

#pragma mark - ScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView)
        return;

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView != self.scrollView)
        return;

    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

    if (page == self.pageControl.currentPage)
        return;

    self.pageControl.currentPage = page;

    // Load the current page and the pages on either side
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

    // Unload all the views which are not currently visible
    [self unloadInvisibleViewsFromScrollView:page];

    // Only allow horizontal scrolling
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
}


#pragma mark - ScrollView methods

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    // TODO: Review image loading logic
    if (page >= self.totalImageCount)
    {
        NSLog(@"Page number greater than number of images");
        return;
    }

    if (self.localModel != nil)
        [self loadScrollViewWithLocalPage:page];
    else if (self.cloudModel != nil)
        [self loadScrollViewWithCloudPage:page];
}

- (void)loadScrollViewWithCloudPage:(NSUInteger)page
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageViewList replaceObjectAtIndex:page withObject:imageView];

    CGRect frame = self.scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;
    imageView.frame = frame;
    NSLog(@"Frame for page %lu: %@", (unsigned long)page, NSStringFromCGRect(frame));

    [self.scrollView addSubview:imageView];

    NSURL *imageLink = self.cloudModel.imageURLArray[page];

    __weak UIImageView *weakImageView = imageView;
    __weak NSURL *weakURL = imageLink;
    NSUInteger copyPage = page;
    SDWebImageCompletionWithFinishedBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        UIImageView *strongInnerImageView = weakImageView;

        if (!strongInnerImageView)
            return;

        // Verify that this is the same cell (might have been reused)
        if (weakURL == imageURL)
        {
            if (image)
            {
                strongInnerImageView.image = image;
                NSLog(@"Loaded page %lu from scroll view", (unsigned long)copyPage);
                //NSLog(@"Image obtained for URL: %@", imageURL);
            }
            else
                NSLog(@"Image not obtained for URL: %@", imageURL);
        }
        else
            NSLog(@"Image not obtained for URL, verification failed: %@", imageURL);
    };

    [MPPhotoUtility downloadFullImageFromURL:imageLink withCompletionBlock:completionBlock];
}

- (void)loadScrollViewWithLocalPage:(NSUInteger)page
{
    UIImage *image = [self getImageWithPage:page];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageViewList replaceObjectAtIndex:page withObject:imageView];

    CGRect frame = self.scrollView.frame;
    frame.origin.x = CGRectGetWidth(frame) * page;
    frame.origin.y = 0;
    imageView.frame = frame;
    NSLog(@"Frame for page %lu: %@", (unsigned long)page, NSStringFromCGRect(frame));

    [self.scrollView addSubview:imageView];

    NSLog(@"Loaded page %lu from scroll view", (unsigned long)page);
}

// This method only removes image views which are not currently visible
- (void)unloadInvisibleViewsFromScrollView:(NSUInteger)currentPage
{
    for (NSUInteger i = 0; i < self.imageViewList.count; ++i)
    {
        // Don't unload pages adjacent to or the same as the current page
        if ((currentPage - i == 1) || (currentPage - i == -1) || (currentPage == i))
        {
            NSLog(@"Not unloading visible page %lu in scroll view", (unsigned long)i);
            continue;
        }

        // Unload image views from the scroll view
        if (![self.imageViewList[i] isEqual:[NSNull null]])
        {
            [self.imageViewList[i] removeFromSuperview];
            NSLog(@"Unloaded invisible page %lu from scroll view", (unsigned long)i);

            // Put a hole in the array instead of the removed image view
            [self.imageViewList replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
}

// This method unloads all the image views from the scroll view
- (void)unloadViewsFromScrollView
{
    for (NSUInteger i = 0; i < self.imageViewList.count; ++i)
    {
        if (![self.imageViewList[i] isEqual:[NSNull null]])
        {
            [self.imageViewList[i] removeFromSuperview];
            NSLog(@"Unloaded page %lu from scroll view", (unsigned long)i);

            [self.imageViewList replaceObjectAtIndex:i withObject:[NSNull null]];
        }
    }
}

- (void)gotoPage:(NSUInteger)page
{
    if (page >= self.totalImageCount)
    {
        NSLog(@"Page number greater than number of images");
        return;
    }

    // Load the current page and the adjacent pages
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

    self.pageControl.currentPage = page;

    // Scroll to the current page
    CGRect bounds = self.scrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 0;
    [self.scrollView scrollRectToVisible:bounds animated:NO];
}

@end
