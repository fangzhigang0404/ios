//
//  MPPhotoBrowserViewController.m
//  MarketPlace
//
//  Created by Arnav Jain on 08/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPPhotoBrowserViewController.h"
#import "MPImageGridView.h"
#import "MPImageZoomView.h"

@interface MPPhotoBrowserViewController () <MPImageGridDelegate>

@property (nonatomic, strong) MPImageGridView *imageGridView;
@property (nonatomic, strong) MPImageZoomView *imageZoomView;

@property (nonatomic) BOOL isCurrentViewScrollView;
@property (nonatomic, strong) MPPhotoBrowserLocalPhotosModel *localModel;
@property (nonatomic, strong) MPPhotoBrowserCloudPhotosModel *cloudModel;

- (void)cellTappedAtIndex:(NSUInteger)index;
- (void)initCollectionView;
- (void)initScrollView;
- (void)initScrollViewWithPage:(NSUInteger)page;
- (void)loadNibs;
- (void)setupConstraints;
- (void)switchViews;

@end

@implementation MPPhotoBrowserViewController

- (instancetype)initWithCloudImages:(MPPhotoBrowserCloudPhotosModel *)model
{
    self = [super init];

    if (self)
    {
        // Set the scroll view as default
        self.isCurrentViewScrollView = YES;

        self.cloudModel = model;

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

- (instancetype)initWithLocalImages:(MPPhotoBrowserLocalPhotosModel *)model
{
    self = [super init];

    if (self)
    {
        // Set the scroll view as default
        self.isCurrentViewScrollView = YES;

        self.localModel = model;

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

    // Customize the navigation bar
    //self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.975
                                                                           green:0.975
                                                                            blue:0.975
                                                                           alpha:1];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.241
                                                                        green:0.241
                                                                         blue:0.241
                                                                        alpha:1];

    [self loadNibs];
    [self setupConstraints];
}

- (void)loadNibs
{
    NSArray *topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"MPImageGridView" owner:self options:nil];

    self.imageGridView = topLevelObjs[0];
    self.imageGridView.delegate = self;

    [self.view addSubview:self.imageGridView];

    topLevelObjs = [[NSBundle mainBundle] loadNibNamed:@"MPImageZoomView" owner:self options:nil];

    self.imageZoomView = topLevelObjs[0];

    [self.view addSubview:self.imageZoomView];
}

- (void)setupConstraints
{
    //Account for space taken by navigation bar
    CGFloat navBarHeight = self.navigationController.navigationBar.frame.size.height;

    self.imageGridView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageZoomView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.imageGridView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:navBarHeight].active = true;
    [self.imageGridView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [self.imageGridView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.imageGridView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;

    [self.imageZoomView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:navBarHeight].active = true;
    [self.imageZoomView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = true;
    [self.imageZoomView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
    [self.imageZoomView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.isCurrentViewScrollView)
        [self initScrollView];
    else
        [self initCollectionView];
}

- (void)initCollectionView
{
    if (self.cloudModel != nil)
        [self.imageGridView initCollectionViewWithCloudPhotos:self.cloudModel];
    else if (self.localModel != nil)
        [self.imageGridView initCollectionViewWithLocalPhotos:self.localModel];
}

- (void)initScrollView
{
    if (self.cloudModel != nil)
        [self.imageZoomView initScrollViewWithCloudPhotos:self.cloudModel];
    else if (self.localModel != nil)
        [self.imageZoomView initScrollViewWithLocalPhotos:self.localModel];
}

- (void)initScrollViewWithPage:(NSUInteger)page
{
    if (self.cloudModel != nil)
        [self.imageZoomView initScrollViewWithCloudPhotos:self.cloudModel gotoPage:page];
    else if (self.localModel != nil)
        [self.imageZoomView initScrollViewWithLocalPhotos:self.localModel gotoPage:page];
}

- (void)switchViews
{
    if (self.isCurrentViewScrollView)
    {
        // Show the grid view
        [self.imageZoomView unloadViewsFromScrollView];
        self.imageZoomView.hidden = YES;
        self.imageGridView.hidden = NO;

        self.isCurrentViewScrollView = NO;

        [self initCollectionView];
    }
    else
    {
        // Show the scroll view
        [self.imageGridView unloadViewsFromCollectionView];
        self.imageZoomView.hidden = NO;
        self.imageGridView.hidden = YES;

        self.isCurrentViewScrollView = YES;

        [self initScrollView];
    }
}

- (void)cellTappedAtIndex:(NSUInteger)index
{
    [self.imageGridView unloadViewsFromCollectionView];
    self.imageZoomView.hidden = NO;
    self.imageGridView.hidden = YES;

    self.isCurrentViewScrollView = YES;

    [self initScrollViewWithPage:index];
}

@end
