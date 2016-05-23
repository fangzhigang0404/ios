//
//  MPImageSetViewController.m
//  MarketPlace
//
//  Created by Arnav Jain on 29/01/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPImageSetViewController.h"
#import "MPImageSetCell.h"

@interface MPImageSetViewController ()<UIScrollViewDelegate, UICollectionViewDelegate,
    MPImageSetCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *gridView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gridViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewTopConstraint;

@property (nonatomic, strong) NSArray *imagePathList; // the images to display
@property (nonatomic, strong) NSMutableArray *imageViewList; // used by the scroll view
@property (nonatomic) BOOL isCurrentViewScrollView; // used when switching between grid/scroll views
@property (nonatomic) NSUInteger numberOfCells; // used by the grid view
@property (nonatomic) NSInteger numberOfSections; // used by the grid view

- (instancetype)initWithImageList:(NSArray *)imagePathList; // The designated initializer
- (void)switchViews;
- (UIImage *)getImageWithPage:(NSUInteger)page;
- (void)initScrollViewWithNumberOfPages:(NSUInteger)numberOfPages;
- (void)loadScrollViewWithPage:(NSUInteger)page;
- (void)unloadInvisibleViewsFromScrollView:(NSUInteger)currentPage;
- (void)unloadViewsFromScrollView;
- (void)gotoPage:(NSUInteger)page;
- (void)initCollectionViewWithNumberOfCells:(NSUInteger)numberOfCells withNumberOfSections:(NSInteger)numberOfSections;
- (void)unloadViewsFromCollectionView;

// Rest are delegate methods

@end

@implementation MPImageSetViewController

static int const numberOfColumns = 3;

- (instancetype)initWithImageList:(NSArray *)imagePathList
{
    self = [super init];

    if (self)
    {
        // Set the scroll view as default
        self.isCurrentViewScrollView = YES;

        self.imagePathList = imagePathList;

        // Populate the navigation bar
        UINavigationItem *navItem = self.navigationItem;

        UIBarButtonItem *viewSwitchButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                             target:self
                                             action:@selector(switchViews)];
        navItem.rightBarButtonItem = viewSwitchButton;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // This is the cell we are using for the grid view
    [self.gridView registerNib:[UINib nibWithNibName:@"MPImageSetCell" bundle:nil] forCellWithReuseIdentifier:@"ImageSetCell"];

    // Customize the navigation bar
    //self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.332
                                                                           green:0.332
                                                                            blue:0.332
                                                                           alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.99
                                                                        green:0.99
                                                                         blue:0.99
                                                                        alpha:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    //Account for space taken by navigation bar
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;
    self.gridViewTopConstraint.constant = navBarHeight;
    self.scrollViewTopConstraint.constant = navBarHeight;

    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.gridView.collectionViewLayout;
    CGFloat screenWidthInPoints = [UIScreen mainScreen].bounds.size.width;
    CGFloat cellWidth = screenWidthInPoints / numberOfColumns;

    // We have square cells, so cell height = width
    CGSize thumbnailCellSize = CGSizeMake(cellWidth, cellWidth);
    flowLayout.itemSize = thumbnailCellSize;
    NSLog(@"Thumbnail cell size width is: %f", thumbnailCellSize.width);

    NSUInteger numberOfPages = self.imagePathList.count;

    // Initialize and populate the list of image views
    self.imageViewList = [[NSMutableArray alloc] init];
    for (int i = 0; i < numberOfPages; ++i)
    {
        [self.imageViewList addObject:[NSNull null]];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    NSUInteger numberOfPages = self.imagePathList.count;

    if (self.isCurrentViewScrollView)
        [self initScrollViewWithNumberOfPages:numberOfPages];
    else
        [self initCollectionViewWithNumberOfCells:numberOfPages withNumberOfSections:1];
}

- (void)switchViews
{
    if (self.isCurrentViewScrollView)
    {
        // Show the grid view
        [self unloadViewsFromScrollView];
        self.scrollView.hidden = YES;
        self.gridView.hidden = NO;
        self.pageControl.hidden = YES;

        self.isCurrentViewScrollView = NO;

        [self initCollectionViewWithNumberOfCells:self.imagePathList.count withNumberOfSections:1];
    }
    else
    {
        // Show the scroll view
        [self unloadViewsFromCollectionView];
        self.gridView.hidden = YES;
        self.scrollView.hidden = NO;
        self.pageControl.hidden = NO;

        self.isCurrentViewScrollView = YES;

        [self initScrollViewWithNumberOfPages:self.imagePathList.count];
    }
}

- (UIImage *)getImageWithPage:(NSUInteger)page
{
    // Can load the image from URL here, going with local images for now
    return [UIImage imageNamed:self.imagePathList[page]];
}


#pragma mark - ScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Seems like this is the grid view, don't do anything
    if (scrollView != self.scrollView)
        return;

    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSUInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;

    // Load the current page and the pages on either side
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];

    // Unload all the views which are not currently visible
    [self unloadInvisibleViewsFromScrollView:page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Seems like this is the grid view, don't do anything
    if (scrollView != self.scrollView)
        return;

    // Only allow horizontal scrolling
    self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
}


#pragma mark - ScrollView methods

- (void)initScrollViewWithNumberOfPages:(NSUInteger)numberOfPages
{
    self.scrollView.contentSize = CGSizeMake
    (CGRectGetWidth(self.scrollView.frame) * numberOfPages, CGRectGetHeight(self.scrollView.frame));

    self.scrollView.scrollsToTop = NO;

    self.pageControl.numberOfPages = numberOfPages;
    self.pageControl.currentPage = 0;

    // Load the first two images by default
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.imagePathList.count)
        return;

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


#pragma mark - CollectionView methods

- (void)initCollectionViewWithNumberOfCells:(NSUInteger)numberOfCells withNumberOfSections:(NSInteger)numberOfSections
{
    self.numberOfCells = numberOfCells;
    self.numberOfSections = numberOfSections;

    [self.gridView reloadData];
}

- (void)unloadViewsFromCollectionView
{
    NSLog(@"Deleting all cells from the grid view");

    if (self.numberOfSections == 1)
    {
        self.numberOfCells = 0;
        self.numberOfSections = 0;

        // We had only one section
        [self.gridView deleteSections:[NSIndexSet indexSetWithIndex:0]];
    }
    else
    {
        // We had multiple sections
        NSRange range = NSMakeRange(0, self.numberOfSections);

        self.numberOfCells = 0;
        self.numberOfSections = 0;

        [self.gridView deleteSections:[NSIndexSet indexSetWithIndexesInRange:range]];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Don't populate the collection view when the scroll view is active
    if (self.isCurrentViewScrollView)
        return 0;

    return self.numberOfCells;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MPImageSetCell* cell = (MPImageSetCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"ImageSetCell" forIndexPath:indexPath];
    cell.delegate = self;
    [cell updateImageCellForIndex:indexPath.item];

    NSLog(@"Loaded page %lu from grid view", (unsigned long)indexPath.item);

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberOfSections;
}


#pragma mark UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark MPImageSetCellDelegate

- (UIImage *)getImageForIndex:(NSUInteger)index
{
    UIImage *image = [self getImageWithPage:index];

    return image;
}

- (void)imageTappedAtIndex:(NSUInteger)index isSelected:(BOOL)selected
{
    if (selected)
    {
        // Store the selection
    }
    else
    {
        // Update the selection data structure if multiple selection was allowed
        // Else do something, the cell was tapped
        [self switchViews];
        [self gotoPage:index];
    }
}

- (BOOL)isSelectionAllowed
{
    // This boolean indicates whether multiple selection of images is allowed or not
    return NO;
}

@end
