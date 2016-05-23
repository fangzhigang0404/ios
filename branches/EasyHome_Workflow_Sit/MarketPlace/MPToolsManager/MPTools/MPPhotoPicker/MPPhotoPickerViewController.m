//
//  MPPhotoPickerViewController.m
//  MarketPlace
//
//  Created by Arnav Jain on 03/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

@import Photos;
#import <SDWebImage/UIImageView+WebCache.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "MPPhotoPickerViewController.h"

#import "MPUserLibraryPhotoAlbumModel.h"
#import "MPCloudPhotoAlbumModel.h"

#import "MPUserLibraryPhotoModel.h"
#import "MPCloudPhotoModel.h"

#import "MPUserLibraryPhotoCell.h"
#import "MPCloudPhotoCell.h"

#import "MPPhotoAlbumPickerViewController.h"
#import "MPPhotoUtility.h"
#import "MPPhotoAlbumUtility.h"
#import "MPUIUtility.h"
#import "MPFileUtility.h"
#import "MPAPI.h"
#import "MPChatHomeStylerCloudfile.h"
#import "MPChatHttpManager.h"
#import "MPMember.h"

@interface MPPhotoPickerViewController ()<UICollectionViewDelegate, MPCloudPhotoCellDelegate, MPUserLibraryPhotoCellDelegate, MPPhotoAlbumPickerDelegate>
{
    NSString* _cloudPhotoCollectionCellIdentifier;
    NSString* _userLibraryPhotoCollectionCellIdentifier;
    int _numberOfColumns;
    BOOL _isMultipleSelectionAllowed;
    NSUInteger _numberOfModelsToFetch;
    NSUInteger _albumPickerPaddingFromTop;
    MPPhotoAlbumType _defaultAlbumType;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *blurViewTopConstraint;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *switchSourceTriangle;
@property (weak, nonatomic) IBOutlet UIButton *switchSourceButton;
@property (weak, nonatomic) IBOutlet UIView *bottomBar;
@property (weak, nonatomic) IBOutlet UIView *blurView;
@property (weak, nonatomic) IBOutlet UIView *cloudPlaceholderView;
@property (weak, nonatomic) IBOutlet UILabel *cloudPlaceholderViewLabel;
@property (weak, nonatomic) IBOutlet UIView *downloaderBlurView;

// Flags which modify state of UI
@property (nonatomic) BOOL isCurrentViewCollectionView;
@property (nonatomic) BOOL isGoingForFirstLoad;

// Datamodel properties
@property (nonatomic) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *selectedCellArray;
@property (nonatomic, strong) NSMutableArray *photoModels;
@property (nonatomic, strong) MPPhotoAlbumModel *currentAlbum;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, id<SDWebImageOperation>> *imageWebRequests;
@property (nonatomic, strong) NSString *assetID;

// Properties related to UI
@property (nonatomic, strong) MPPhotoAlbumPickerViewController *photoAlbumPickerController;
@property (nonatomic, strong) UIView *photoAlbumPickerView;
@property (nonatomic) CGSize thumbnailCellSize;

// Properties related to local photos
@property (nonatomic, strong) PHCachingImageManager *imageCacheManager;
@property CGRect previousPreheatRect;


// Actions
- (IBAction)switchSourceTapped:(id)sender;
- (void)blurViewTapped:(UIGestureRecognizer *)sender;
- (void)goBack;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)submitButtonTapped;

// Methods which change state of controller based on actions
- (void)loadAlbumPicker;
- (void)loadCollectionViewWithPage:(NSUInteger)page;
- (void)proceedToNextScreenWithURLArray:(NSArray<NSURL *> *)imageURLs;
- (void)reloadCollectionView;
- (void)setSelectedStateForCellWithIndex:(NSUInteger)index withSelectedState:(BOOL)selected;
- (void)unloadAlbumPickerWithReload:(BOOL)reloadRequired;

/* Internal methods */

// Internal pagination methods
- (void)loadCloudPhotosWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;
- (void)loadHomestylerCloudPhotosWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;
- (void)loadLocalPhotosWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;

// Internal image download
- (void)fetchCloudImageForPhotoCell:(MPCloudPhotoCell *)cell withIndex:(NSUInteger)index;
- (void)fetchLocalImageForPhotoCell:(MPUserLibraryPhotoCell *)cell withIndex:(NSUInteger)index;

// Web requests that fetch datamodel data
- (NSArray *)getImageURLArrayWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;
- (NSArray *)getThumbnailURLArrayWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit;

// UI methods
- (void)createPermissionDeniedAlertWithHandler:(MPAlertHandler)actionHandler;
- (void)createGenericAlert;
- (void)handleSelectionForIndex:(NSUInteger)index isSelected:(BOOL)selected;
- (void)setBlurViewEnabled:(BOOL)enabled;
- (void)setNextEnabled:(BOOL)enabled;

// Rest are delegate methods

@end

@implementation MPPhotoPickerViewController

- (instancetype)initWithDefaultAlbumType:(MPPhotoAlbumType)defaultAlbumType withAssetID:(NSString *)assetID
{
    self = [super init];

    if (self)
    {
        self.isCurrentViewCollectionView = YES;
        self.currentPage = 0; // We're on the first page
        self.assetID = assetID;

        // Can't have the cloud album without an asset ID
        if (!self.assetID)
            assert(defaultAlbumType == MPPhotoAlbumTypeUserLibrary);

        if (defaultAlbumType == MPPhotoAlbumTypeCloud)
            assert([[MPMember shareMember] MemberIsDesignerMode]);

        // We set some "constants" here
        _cloudPhotoCollectionCellIdentifier = @"CloudPhotoCell";
        _userLibraryPhotoCollectionCellIdentifier = @"UserLibraryPhotoCell";
        _numberOfColumns = 3;
        _isMultipleSelectionAllowed = NO;
        _numberOfModelsToFetch = 20;
        _defaultAlbumType = defaultAlbumType;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // This is the cell we are using for the grid view
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"MPCloudPhotoCell" bundle:nil] forCellWithReuseIdentifier:_cloudPhotoCollectionCellIdentifier];
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"MPUserLibraryPhotoCell" bundle:nil] forCellWithReuseIdentifier:_userLibraryPhotoCollectionCellIdentifier];

    NSString *sourceButtonTitle = NSLocalizedString(@"photo_picker_source_button_label", nil);
    [self.switchSourceButton setTitle:sourceButtonTitle forState:UIControlStateNormal];

    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.photoCollectionView.collectionViewLayout;
    CGFloat screenWidthInPoints = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeightInPoints = [UIScreen mainScreen].bounds.size.height;
    CGFloat cellWidth = screenWidthInPoints / _numberOfColumns;

    // We have square cells, so cell height = width
    self.thumbnailCellSize = CGSizeMake(cellWidth, cellWidth);
    flowLayout.itemSize = self.thumbnailCellSize;
    //NSLog(@"MPPhotoPicker: Thumbnail cell size width is: %f", self.thumbnailCellSize.width);

    self.downloaderBlurView.backgroundColor = [UIColor darkGrayColor];
    self.blurView.backgroundColor = [UIColor darkGrayColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blurViewTapped:)];
    tapGesture.numberOfTapsRequired = 1;

    [self.blurView addGestureRecognizer:tapGesture];

    _albumPickerPaddingFromTop = screenHeightInPoints / 4.0;

    NSString *cloudPlaceholderDescription = NSLocalizedString(@"photo_picker_cloud_placeholder_text", nil);
    self.cloudPlaceholderViewLabel.text = cloudPlaceholderDescription;

    [self checkForAuthorizationAndProceed];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //Account for space taken by navigation bar
    CGFloat navBarHeight = self.navgationImageview.frame.size.height;
    self.photoCollectionViewTopConstraint.constant = navBarHeight;
    self.blurViewTopConstraint.constant = -navBarHeight;
    //self.tabBarController.tabBar.hidden = YES;

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchSourceTapped:)];
    tapRecognizer.numberOfTapsRequired = 1;
    [self.switchSourceTriangle addGestureRecognizer:tapRecognizer];

    [self setupNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    // TODO: This is temporary as we want to see the thumbnails
    // loading properly right now on each app run. After this
    // testing is over, the following lines will be removed.
//    [SDWebImageManager.sharedManager.imageCache clearMemory];
//    [SDWebImageManager.sharedManager.imageCache clearDisk];

    [super viewDidAppear:animated];

    // TODO: Set the proper appname?
    [SDWebImageManager.sharedManager.imageDownloader setValue:@"Test Demo" forHTTPHeaderField:@"AppName"];
    SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
}

- (void)checkForAuthorizationAndProceed
{
    MPPhotoAlbumType albumType;

    // We are checking for the first launch
    if (!self.currentAlbum)
        albumType = _defaultAlbumType;
    else
        albumType = self.currentAlbum.albumType;

    if (albumType == MPPhotoAlbumTypeUserLibrary)
    {
        // We want to access the user's photos, check authorization status
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];

        if (status == PHAuthorizationStatusAuthorized)
        {
            // We are authorized, let's move on
            if (!self.currentAlbum)
            {
                self.imageCacheManager = [[PHCachingImageManager alloc] init];
                [self resetCachedAssets];

                self.currentAlbum = [MPPhotoAlbumUtility getDefaultAlbumModelForAlbumType:_defaultAlbumType];
            }
            [self reloadCollectionView];
        }
        else
        {
            __weak MPPhotoPickerViewController *weakSelf = self;
            // Ask the user to grant permission to access their photos
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
            {
                MPPhotoPickerViewController *strongInnerSelf = weakSelf;

                dispatch_async(dispatch_get_main_queue(), ^(void)
                {
                    if (status == PHAuthorizationStatusAuthorized)
                    {
                        // We are authorized, let's move on
                        if (!strongInnerSelf.currentAlbum)
                        {
                            strongInnerSelf.imageCacheManager = [[PHCachingImageManager alloc] init];
                            [strongInnerSelf resetCachedAssets];

                            strongInnerSelf.currentAlbum = [MPPhotoAlbumUtility getDefaultAlbumModelForAlbumType:_defaultAlbumType];
                        }
                        [strongInnerSelf reloadCollectionView];
                    }
                    else
                    {
                        // The user did not authorize us, present an error message and get out
                        // open setting Privacy.
                        [MPAlertView showAlertWithTitle:NSLocalizedString(@"photo_picker_photos", nil)
                                                message:NSLocalizedString(@"photo_picker_photos_setting", nil)
                                         cancelKeyTitle:NSLocalizedString(@"cancel_Key", nil)
                                          rightKeyTitle:NSLocalizedString(@"go_setting", nil)
                                               rightKey:^{
                                                   [AppController openSettingPrivacy];
                                                   [strongInnerSelf performSelector:@selector(popToChatRoom) withObject:nil afterDelay:0.5];
                                               } cancelKey:^{
                                                   [strongInnerSelf.delegate userDeniedPhotoLibraryAccess];

                                               }];
//                        MPAlertHandler actionHandler = ^(UIAlertAction *action)
//                        {
//                            // Tell the delegate that the user has denied access to their
//                            // photo library
//                            [strongInnerSelf.delegate userDeniedPhotoLibraryAccess];
//                        };
//
//                        [strongInnerSelf createPermissionDeniedAlertWithHandler:actionHandler];
                    }
                });
            }];
        }
    }
    else if (albumType == MPPhotoAlbumTypeCloud)
        [self checkHomestylerPhotos];
}

- (void)popToChatRoom {
    [self.delegate userDeniedPhotoLibraryAccess];
}

- (void)setPlaceholderViewEnabled:(BOOL)enabled
{
    if (enabled)
    {
        self.photoCollectionView.hidden = YES;
        self.cloudPlaceholderView.hidden = NO;
    }
    else
    {
        self.photoCollectionView.hidden = NO;
        self.cloudPlaceholderView.hidden = YES;
    }
}

- (void)setupNavigationBar
{
    // Set the next button string
    NSString *uploadText = NSLocalizedString(@"photo_picker_next_label", nil);
    [self.rightButton setTitle:uploadText forState:UIControlStateNormal];
    [self.rightButton setImage:nil forState:UIControlStateNormal];
}

- (void)setNavigationBarTitle:(NSString *)text
{
    self.titleLabel.text = text;
}

- (void)tapOnLeftButton:(id)sender
{
    [self goBack];
}

- (void)tapOnRightButton:(id)sender
{
    [self submitButtonTapped];
}

- (void)goBack
{
    [self cancelAllRequestsForCurrentAlbum];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility methods

- (void)setNextEnabled:(BOOL)enabled
{
    if (enabled)
        self.rightButton.enabled = YES;
    else
        self.rightButton.enabled = NO;
}

- (void)handleSelectionForIndex:(NSUInteger)index isSelected:(BOOL)selected
{
    if (_isMultipleSelectionAllowed)
    {
        if (selected)
            [self.selectedCellArray addObject:[NSNumber numberWithInteger:index]];
        else
            [self.selectedCellArray removeObject:[NSNumber numberWithInteger:index]];

        // Select/unselect this cell
        [self setSelectedStateForCellWithIndex:index withSelectedState:selected];
    }
    else
    {
        if (selected)
        {
            if (self.selectedCellArray.count == 0)
                [self.selectedCellArray addObject:[NSNumber numberWithInteger:index]];
            else
            {
                // Unselect previously selected cell
                NSUInteger previousIndex = [[self.selectedCellArray objectAtIndex:0] integerValue];
                [self setSelectedStateForCellWithIndex:previousIndex withSelectedState:NO];

                [self.selectedCellArray replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:index]];
            }
        }
        else
            [self.selectedCellArray removeObject:[NSNumber numberWithInteger:index]];

        // Select/Unselect this cell
        [self setSelectedStateForCellWithIndex:index withSelectedState:selected];
    }

    if (self.selectedCellArray.count != 0)
        [self setNextEnabled:YES];
    else
        [self setNextEnabled:NO];
}

- (void)setSelectedStateForCellWithIndex:(NSUInteger)index withSelectedState:(BOOL)selected
{
    if (self.currentAlbum.albumType == MPPhotoAlbumTypeUserLibrary)
    {
        MPUserLibraryPhotoCell *cell = (MPUserLibraryPhotoCell *)[self.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [cell setPhotoCellSelected:selected];
    }
    else if (self.currentAlbum.albumType == MPPhotoAlbumTypeCloud)
    {
        MPCloudPhotoCell *cell = (MPCloudPhotoCell *)[self.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        [cell setPhotoCellSelected:selected];
    }
}

- (void)createAlertViewWithTitle:(NSString *)title withMessage:(NSString *)message withActionHandler:(void (^ __nullable)(UIAlertAction *action))actionHandler
{
    assert(title);

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    NSString *localizedOK = NSLocalizedString(@"photo_picker_alert_view_ok", nil);

    UIAlertAction* defaultAction;

    if (!actionHandler)
    {
        // Go with the default action handler
        defaultAction = [UIAlertAction actionWithTitle:localizedOK
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {}];
    }
    else
    {
        // Go with the provided action handler
        defaultAction = [UIAlertAction actionWithTitle:localizedOK
                                                 style:UIAlertActionStyleDefault
                                               handler:actionHandler];
    }

    [alert addAction:defaultAction];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createGenericAlert
{
    NSString *localizedTitle = NSLocalizedString(@"photo_picker_alert_view_title", nil);
    NSString *localizedMessage = NSLocalizedString(@"photo_picker_alert_view_message", nil);

    UIAlertController *alert = [MPUIUtility createSimpleAlertWithTitle:localizedTitle withMessage:localizedMessage withActionTitle:nil];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)createPermissionDeniedAlertWithHandler:(MPAlertHandler)actionHandler
{
    NSString *localizedTitle = NSLocalizedString(@"photo_picker_permission_alert_title", nil);
    NSString *localizedMessage = NSLocalizedString(@"photo_picker_permission_alert_message", nil);

    UIAlertController *alert = [MPUIUtility createSimpleAlertWithTitle:localizedTitle withMessage:localizedMessage withActionTitle:nil withActionHandler:actionHandler];

    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setBlurViewEnabled:(BOOL)enabled
{
    if (enabled)
    {
        [self.view bringSubviewToFront:self.blurView];
        self.blurView.hidden = NO;
    }
    else
    {
        [self.view sendSubviewToBack:self.blurView];
        self.blurView.hidden = YES;
    }
}

- (void)setDownloaderBlurViewEnabled:(BOOL)enabled
{
    if (enabled)
    {
        [self.view bringSubviewToFront:self.downloaderBlurView];
        self.downloaderBlurView.hidden = NO;
    }
    else
    {
        [self.view sendSubviewToBack:self.downloaderBlurView];
        self.downloaderBlurView.hidden = YES;
    }
}

- (void)cancelAllRequestsForCurrentAlbum
{
    if (self.currentAlbum.albumType == MPPhotoAlbumTypeUserLibrary)
    {
        [self resetCachedAssets];
    }
    else if (self.currentAlbum.albumType == MPPhotoAlbumTypeCloud)
    {
        NSLog(@"MPPhotoPicker: Cancelling all web requests (%lu)", (unsigned long)self.imageWebRequests.count);
        for (int i = 0; i < self.imageWebRequests.count; ++i)
        {
            id<SDWebImageOperation> downloadOperation = [self.imageWebRequests objectForKey:[NSNumber numberWithInt:i]];

            if (downloadOperation)
            {
                [downloadOperation cancel];
            }
        }
    }
}

- (void)cancelRequestForIndex:(NSUInteger)index
{
    id<SDWebImageOperation> downloadOperation = [self.imageWebRequests objectForKey:[NSNumber numberWithInteger:index]];

    if (downloadOperation)
    {
//        NSLog(@"MPPhotoPicker: Cancelling web request for index: %lu", index);
        [downloadOperation cancel];
        downloadOperation = nil;
        [self.imageWebRequests removeObjectForKey:[NSNumber numberWithInteger:index]];
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);

        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }

        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }

        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }

        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }

    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths)
    {
        MPUserLibraryPhotoModel *model = (MPUserLibraryPhotoModel *)self.photoModels[indexPath.item];
        PHAsset *asset = model.asset;
        [assets addObject:asset];
    }

    return assets;
}

- (NSArray *)indexPathsForElementsInRect:(CGRect)rect
{
    NSArray *allLayoutAttributes = [self.photoCollectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

#pragma mark - Photo loading and caching methods
- (void)fetchCloudImageForPhotoCell:(MPCloudPhotoCell *)cell withIndex:(NSUInteger)index
{
    assert(self.currentAlbum.albumType == MPPhotoAlbumTypeCloud);

    MPCloudPhotoModel *model = (MPCloudPhotoModel *)self.photoModels[index];

    __weak MPPhotoPickerViewController *weakSelf = self;
    __weak MPCloudPhotoModel *weakModel = model;
    __weak MPCloudPhotoCell *weakCell = cell;
    SDWebImageCompletionWithFinishedBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        if (!weakSelf || !weakModel)
            return;

        NSUInteger innerIndex = [weakSelf.photoModels indexOfObject:weakModel];

        if (image)
        {
            if (weakCell && (weakCell.index == innerIndex))
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakCell setThumbnailForPhotoCell:image];
                });
            }
        }
        else
            NSLog(@"MPPhotoPicker: Image not obtained for URL: %@", imageURL);

        if (error)
            NSLog(@"MPPhotoPicker: Error while downloading image: %@", error.description);
    };

    if (model.linkToThumbnail)
    {
        id<SDWebImageOperation> downloadOperation = [MPPhotoUtility downloadThumbnailFromURL:model.linkToThumbnail withCompletionBlock:completionBlock];
        [self.imageWebRequests setObject:downloadOperation forKey:[NSNumber numberWithInteger:index]];
    }
}

- (void)fetchLocalImageForPhotoCell:(MPUserLibraryPhotoCell *)cell withIndex:(NSUInteger)index
{
    assert(self.currentAlbum.albumType == MPPhotoAlbumTypeUserLibrary);

    MPUserLibraryPhotoModel *model = (MPUserLibraryPhotoModel *)self.photoModels[index];

    __weak MPPhotoPickerViewController *weakSelf = self;
    __weak MPUserLibraryPhotoModel *weakModel = model;
    __weak MPUserLibraryPhotoCell *weakCell = cell;
    MPImageFromPHAssetCompletionBlock completionBlock = ^(UIImage *image, NSDictionary *info)
    {
        if (!weakSelf || !weakModel)
            return;

        NSUInteger innerIndex = [weakSelf.photoModels indexOfObject:weakModel];

        if (image)
        {
            if (weakCell && (weakCell.index == innerIndex))
                [weakCell setThumbnailForPhotoCell:image];
        }
        else
            NSLog(@"MPPhotoPicker: Image not obtained for index: %lu", (unsigned long)index);
    };

//    [MPPhotoUtility fetchThumbnailImageFromAsset:model.asset withCompletionBlock:completionBlock];

    if (model.asset)
    {
        [MPPhotoUtility fetchCachedThumbnailImageFromAsset:model.asset
                                       withCompletionBlock:completionBlock
                                                 dimension:self.thumbnailCellSize.width
                                              cacheManager:self.imageCacheManager];
    }
}

- (void)resetCachedAssets
{
    NSLog(@"MPhotoPicker: Resetting cache");

    [self.imageCacheManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets
{
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) { return; }

    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.photoCollectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));

    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.photoCollectionView.bounds) / 3.0f)
    {
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];

        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect)
        {
            NSArray *indexPaths = [self indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        }
                              addedHandler:^(CGRect addedRect)
        {
            NSArray *indexPaths = [self indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];

        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];

        // Update the assets the PHCachingImageManager is caching.
        [self.imageCacheManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:self.thumbnailCellSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:nil];
        [self.imageCacheManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:self.thumbnailCellSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:nil];

        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}


#pragma mark - UI interaction methods
- (IBAction)switchSourceTapped:(id)sender
{
    if (self.isCurrentViewCollectionView)
    {
        self.isCurrentViewCollectionView = NO;

        self.photoCollectionView.userInteractionEnabled = NO;

        [self loadAlbumPicker];
    }
    else
    {
        [self dismissAlbumPickerWithAlbumChanged:@0];
    }
}

- (void)dismissAlbumPickerWithAlbumChanged:(NSNumber*)albumChanged
{
    self.isCurrentViewCollectionView = YES;

    self.photoCollectionView.userInteractionEnabled = YES;

    BOOL reloadRequired = ([albumChanged intValue] == 0) ? NO : YES;

    [self unloadAlbumPickerWithReload:reloadRequired];
}

- (void)loadAlbumPicker
{
    self.photoAlbumPickerController = [[MPPhotoAlbumPickerViewController alloc] initWithCurrentAlbum:self.currentAlbum withAssetID:self.assetID];
    self.photoAlbumPickerView = self.photoAlbumPickerController.view;
    self.photoAlbumPickerController.delegate = self;

    [self setBlurViewEnabled:YES];
    [self.view addSubview:self.photoAlbumPickerView];

    self.photoAlbumPickerView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.view
        addConstraint:[NSLayoutConstraint constraintWithItem:self.photoAlbumPickerView
                                                    attribute:NSLayoutAttributeTop
                                                    relatedBy:NSLayoutRelationEqual
                                                      toItem:self.view
                                                    attribute:NSLayoutAttributeTop
                                                   multiplier:1
                                                     constant:_albumPickerPaddingFromTop]];

    [self.view
     addConstraint:[NSLayoutConstraint constraintWithItem:self.photoAlbumPickerView
                                                attribute:NSLayoutAttributeLeading
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.view
                                                attribute:NSLayoutAttributeLeading
                                               multiplier:1
                                                 constant:0]];
    [self.view
     addConstraint:[NSLayoutConstraint constraintWithItem:self.photoAlbumPickerView
                                                attribute:NSLayoutAttributeTrailing
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.view
                                                attribute:NSLayoutAttributeTrailing
                                               multiplier:1
                                                 constant:0]];
    [self.view
     addConstraint:[NSLayoutConstraint constraintWithItem:self.photoAlbumPickerView
                                                attribute:NSLayoutAttributeBottom
                                                relatedBy:NSLayoutRelationEqual
                                                   toItem:self.bottomBar
                                                attribute:NSLayoutAttributeTop
                                               multiplier:1
                                                 constant:0]];

//    [self.photoAlbumPickerView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:_albumPickerPaddingFromTop].active = true;
//    [self.photoAlbumPickerView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = true;
//    [self.photoAlbumPickerView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = true;
//    [self.photoAlbumPickerView.bottomAnchor constraintEqualToAnchor:self.bottomBar.topAnchor constant:0].active = true;

    CGPoint originalCenter = self.photoAlbumPickerView.center;
    self.photoAlbumPickerView.center = CGPointMake(originalCenter.x, self.view.frame.size.height);

    MPPhotoPickerViewController *weakPVC = self;
    [UIView animateWithDuration:0.4f
                     animations:^
                     {
                         MPPhotoPickerViewController *strongInnerPVC = weakPVC;
                         strongInnerPVC.photoAlbumPickerView.center = originalCenter;
                     }
                     completion:^(BOOL finished)
                     {

                     }];
}

- (void)unloadAlbumPickerWithReload:(BOOL)reloadRequired
{
    CGPoint originalCenter = self.photoAlbumPickerView.center;

    __weak MPPhotoPickerViewController *weakPVC = self;
    [UIView animateWithDuration:0.4f
                     animations:^
                     {
                         MPPhotoPickerViewController *strongInnerPVC = weakPVC;

                         strongInnerPVC.photoAlbumPickerView.center = CGPointMake(originalCenter.x, strongInnerPVC.view.frame.size.height * 1.25);
                     }
                     completion:^(BOOL finished)
                     {
                         MPPhotoPickerViewController *strongInnerPVC = weakPVC;

                         [strongInnerPVC.photoAlbumPickerView removeFromSuperview];

                         strongInnerPVC.photoAlbumPickerView = nil;
                         strongInnerPVC.photoAlbumPickerController.delegate = nil;
                         strongInnerPVC.photoAlbumPickerController = nil;

                         [strongInnerPVC setBlurViewEnabled:NO];

                         if (reloadRequired)
                             [strongInnerPVC checkForAuthorizationAndProceed];
                     }];
}

- (void)submitButtonTapped
{
    // Show the spinner and block user interaction
    [self setDownloaderBlurViewEnabled:YES];

    __block NSMutableArray<NSURL *> *atomicLocalURLArray = [[NSMutableArray alloc] init];
    __block NSUInteger blockCounter = 0;

    if (self.currentAlbum.albumType == MPPhotoAlbumTypeCloud)
    {
        for(NSNumber *num in self.selectedCellArray)
        {
            MPCloudPhotoModel *model = self.photoModels[[num intValue]];

//            __weak MPCloudPhotoModel *weakModel = model;
            __weak MPPhotoPickerViewController *weakPVC = self;

//            SDWebImageCompletionWithFinishedBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
//            {
//                NSMutableArray<NSURL *> *strongInnerAtomicURLArray = atomicLocalURLArray;
//                MPCloudPhotoModel *strongModel = weakModel;
//                MPPhotoPickerViewController *strongInnerPVC = weakPVC;
//
//                // Verify that this is the same cell (might have been reused)
//                if (strongModel.linkToFullImage == imageURL)
//                {
//                    if (image)
//                    {
//                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
//                           {
//                               NSString *filePath = strongModel.linkToFullImage.path;
//                               NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
//
//                               // Save the image
//                               NSString *path = [MPFileUtility writeImage:image
//                                                                 withName:fileName
//                                                      isPNGRepresentation:NO];
//
//                               if (!path)
//                               {
//                                   [strongInnerPVC setDownloaderBlurViewEnabled:NO];
//                                   [strongInnerPVC createGenericAlert];
//                                   return;
//                               }
//
//                               NSURL *imageURL = [[NSURL alloc] initFileURLWithPath:path];
//
//                               [strongInnerAtomicURLArray addObject:imageURL];
//
//                               ++blockCounter;
//
//                               dispatch_async(dispatch_get_main_queue(), ^(void)
//                                  {
//                                      if (blockCounter == strongInnerPVC.selectedCellArray.count)
//                                      {
//                                          [strongInnerPVC proceedToNextScreenWithURLArray:strongInnerAtomicURLArray];
//                                      }
//                                      //NSLog(@"MPPhotoPicker: Image obtained for URL: %@", imageURL);
//                                  });
//                           });
//                    }
//                    else
//                    {
//                        [self setDownloaderBlurViewEnabled:NO];
//                        [strongInnerPVC createGenericAlert];
//                        NSLog(@"MPPhotoPicker: Image not obtained for URL: %@", imageURL);
//                    }
//                }
//                else
//                    NSLog(@"MPPhotoPicker: Image not obtained for URL, verification failed: %@", imageURL);
//            };
//
//            [MPPhotoUtility downloadFullImageFromURL:model.linkToFullImage withCompletionBlock:completionBlock];

            NSString *fileName = [model.fileID stringByAppendingPathExtension:@"jpg"];
            NSURL *absoluteCachedFile = [MPFileUtility generateCacheFileURL:fileName];

//            if ([MPFileUtility isFileExist:absoluteCachedFile.path])
//                [MPFileUtility removeFile:absoluteCachedFile.path];

            NSLog(@"MPPhotoPicker: File path: %@", absoluteCachedFile);

            if (!absoluteCachedFile)
            {
                [self setDownloaderBlurViewEnabled:NO];
                [self createGenericAlert];
                return;
            }
            else if ([MPFileUtility isFileExist:absoluteCachedFile.path])
            {
                NSLog(@"MPPhotoPicker: Found cached file, using that instead of downloading: %@", fileName);
                [atomicLocalURLArray addObject:absoluteCachedFile];

                ++blockCounter;

                dispatch_async(dispatch_get_main_queue(), ^(void)
                   {
                       if (blockCounter == self.selectedCellArray.count)
                       {
                           [self proceedToNextScreenWithURLArray:atomicLocalURLArray];
                       }
                       //NSLog(@"MPPhotoPicker: Image obtained for URL: %@", imageURL);
                   });

                continue;
            }
            else
            {
                if (!model.fileID)
                {
                    NSLog(@"MPPhotoPicker: Whoops, we don't have a valid fileID");

                    [self setDownloaderBlurViewEnabled:NO];
                    [self createGenericAlert];
                    return;
                }

                [[MPChatHttpManager sharedInstance] downloadFile:model.fileID
                                                    atTargetPath:absoluteCachedFile
                                                        progress:^(NSProgress *downloadProgress)
                 {
//                     NSLog(@"MPPhotoPicker: Image download in progress");
                 }
                                                         success:^(NSURL *file, id responseobject)
                 {
                     MPPhotoPickerViewController *strongInnerPVC = weakPVC;
                     NSMutableArray<NSURL *> *strongInnerAtomicURLArray = atomicLocalURLArray;

                     NSLog(@"MPPhotoPicker: Got file path: %@", file.path);
                     if(![MPFileUtility isFileExist:file.path])
                     {
                         [strongInnerPVC setDownloaderBlurViewEnabled:NO];
                         [strongInnerPVC createGenericAlert];
                         return;
                     }

                     [strongInnerAtomicURLArray addObject:file];

                     ++blockCounter;

                     dispatch_async(dispatch_get_main_queue(), ^(void)
                                    {
                                        if (blockCounter == strongInnerPVC.selectedCellArray.count)
                                        {
                                            [strongInnerPVC proceedToNextScreenWithURLArray:strongInnerAtomicURLArray];
                                        }
                                    });

                 }
                                                         failure:^(NSError *error)
                 {
                     MPPhotoPickerViewController *strongInnerPVC = weakPVC;

                     NSLog(@"MPPhotoPicker: Error while downloading homestyler file: %@", error.localizedDescription);

                     [strongInnerPVC setDownloaderBlurViewEnabled:NO];
                     [strongInnerPVC createGenericAlert];
                 }];
            }
        }
    }
    else if (self.currentAlbum.albumType == MPPhotoAlbumTypeUserLibrary)
    {
        for(NSNumber *num in self.selectedCellArray)
        {
            MPUserLibraryPhotoModel *model = self.photoModels[[num intValue]];

            PHAsset *asset = model.asset;

            __weak MPPhotoPickerViewController *weakPVC = self;

            MPImageFromPHAssetCompletionBlock completionBlock = ^(UIImage *result, NSDictionary *info)
              {
                  NSMutableArray<NSURL *> *strongInnerAtomicURLArray = atomicLocalURLArray;
                  MPPhotoPickerViewController *strongInnerPVC = weakPVC;

                  // TODO: Verification disabled because identifiers were coming the same
                  
                 
                  
                  if (result)
                  {
                      UIImage *rotatedImage = [strongInnerPVC normalizedImageForImage:result];

                      
                      
                      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                         {
                                                 
                             // Save the image
                             NSString *fileName = [[MPFileUtility getUniqueFileName] stringByAppendingPathExtension:@"jpg"];
                             NSString *path = [MPFileUtility writeImage:rotatedImage
                                                               withName:fileName
                                                    isPNGRepresentation:NO];
                             

                             if ([MPFileUtility getFilePath:fileName]) {
                                 
                                 float filesize =[self fileSizeAtPath:[MPFileUtility getFilePath:fileName]];
                                 
                                 NSLog(@"%lf",filesize);
                                 
                                 if (filesize > 1.00) {
                                     
                                     
                                 }

                             }
                             
                            
                             if (!path)
                             {
                                 [self setDownloaderBlurViewEnabled:NO];
                                 [strongInnerPVC createGenericAlert];
                                 return;
                             }

                             NSURL *imageURL = [[NSURL alloc] initFileURLWithPath:path];

                             [strongInnerAtomicURLArray addObject:imageURL];

                             ++blockCounter;

                             dispatch_async(dispatch_get_main_queue(), ^(void)
                                {
                                    if (blockCounter == strongInnerPVC.selectedCellArray.count)
                                    {
                                        [strongInnerPVC proceedToNextScreenWithURLArray:strongInnerAtomicURLArray];
                                    }
                                    //NSLog(@"MPPhotoPicker: Image obtained for identifier: %d", weakRequestID);
                                });
                         });
                  }
                  else
                  {
                      [self setDownloaderBlurViewEnabled:NO];
                      [strongInnerPVC createGenericAlert];
                      NSLog(@"MPPhotoPicker: Image not obtained for index: %d", [num intValue]);
                  }
              };

            if (!asset)
            {
                NSLog(@"MPPhotoPicker: Whoops, we don't have a valid PHAsset (dunno how it got selected)");

                [self setDownloaderBlurViewEnabled:NO];
                [self createGenericAlert];
                return;
            }

            [MPPhotoUtility fetchImageFromAsset:asset withCompletionBlock:completionBlock];
        }
    }
}


- (float) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        float fileSize = [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
        
        return fileSize/(1024.0 * 1024.0);
    }
    return 0;
}







- (void)proceedToNextScreenWithURLArray:(NSArray<NSURL *> *)imageURLs
{
    NSLog(@"MPPhotoPicker: Number of images for next screen: %lu", (unsigned long)imageURLs.count);

    for (NSURL *url in imageURLs)
    {
        if (!url)
        {
            [self setDownloaderBlurViewEnabled:NO];
            [self createGenericAlert];
            NSLog(@"MPPhotoPicker: No URL obtained for image");

            return;
        }

        NSLog(@"MPPhotoPicker: Path for file is: %@", url);

        UIImage *image = [UIImage imageWithContentsOfFile:url.path];

        if (!image)
        {
            [self setDownloaderBlurViewEnabled:NO];
            [self createGenericAlert];
            NSLog(@"MPPhotoPicker: Image could not be loaded from URL");

            return;
        }
    }

    [self.delegate userDidSelectPhotoWithURL:[imageURLs firstObject]];
}

- (void)blurViewTapped:(UIGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [self dismissAlbumPickerWithAlbumChanged:@0];
    }
}

#pragma mark - Pagination methods
- (void)loadCollectionViewWithPage:(NSUInteger)page
{
    NSUInteger offset = page * _numberOfModelsToFetch;
    NSUInteger limit = _numberOfModelsToFetch;

    // Do not load if offset is less than current position
    if (offset < self.photoModels.count)
        return;

    if (self.currentAlbum.albumType == MPPhotoAlbumTypeCloud)
    {
        // Load the page of cloud photos
//        [self loadCloudPhotosWithOffset:offset withLimit:limit];
        [self loadHomestylerCloudPhotosWithOffset:offset withLimit:limit];
    }
    else if (self.currentAlbum.albumType == MPPhotoAlbumTypeUserLibrary)
    {
        // Load the page of local photos
        NSLog(@"Loading photos with offset: %lu and limit: %lu", (unsigned long)offset, (unsigned long)limit);
        [self loadLocalPhotosWithOffset:offset withLimit:limit];
    }
}

- (void)loadCollectionViewWithFullAlbum
{
    NSUInteger offset = 0;

    if (self.currentAlbum.albumType == MPPhotoAlbumTypeCloud)
    {
        // Load the page of cloud photos
//        [self loadCloudPhotosWithOffset:offset withLimit:limit];
        MPCloudPhotoAlbumModel *model = (MPCloudPhotoAlbumModel *)self.currentAlbum;
        NSUInteger limit = model.cloudFiles.count;

        [self loadHomestylerCloudPhotosWithOffset:offset withLimit:limit];
    }
    else if (self.currentAlbum.albumType == MPPhotoAlbumTypeUserLibrary)
    {
        // Load the page of local photos
        MPUserLibraryPhotoAlbumModel *model = (MPUserLibraryPhotoAlbumModel *)self.currentAlbum;
        NSUInteger limit = model.numberOfPhotos;

//        NSLog(@"Loading photos with offset: %lu and limit: %lu", offset, limit);
        [self loadLocalPhotosWithOffset:offset withLimit:limit];

        [self resetCachedAssets];
        [self updateCachedAssets];
    }
}

- (void)loadHomestylerCloudPhotosWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit
{
    MPCloudPhotoAlbumModel *model = (MPCloudPhotoAlbumModel *)self.currentAlbum;

    // We need to be careful about not exceeding the total number of photos present
    // in the collection
    if (offset > (model.cloudFiles.count - 1))
        return;

    // There are less photos remaining than what we were told to get
    if ((offset + limit) > (model.cloudFiles.count))
        limit = model.cloudFiles.count - offset;

    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

    for (NSUInteger i = offset; i < offset + limit; ++i)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        MPChatHomeStylerCloudfile *cloudFile = [model.cloudFiles objectAtIndex:i];

        MPCloudPhotoModel *photoModel = [[MPCloudPhotoModel alloc] init];

        photoModel.linkToFullImage = [NSURL URLWithString:cloudFile.url];
        photoModel.linkToThumbnail = [NSURL URLWithString:cloudFile.thumbnail];
        photoModel.fileID = [cloudFile.uid stringValue];

        [self.photoModels addObject:photoModel];
        [indexPaths addObject:indexPath];
    }

    // Don't insert items when no cells are visible. When we tell the collection view to
    // reload its data, it starts creating cells. After this, it is safe to append new
    // items to the collection view.
    if (self.isGoingForFirstLoad)
    {
        [self.photoCollectionView reloadData];
        return;
    }

    @try
    {
        [self.photoCollectionView performBatchUpdates:^(void)
         {
             [self.photoCollectionView insertItemsAtIndexPaths:indexPaths];
         } completion:^(BOOL finished)
         {
             
         }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"MPPhotoPicker: Exception while inserting cells: %@", exception.description);
    }
    @finally
    {

    }
}

- (void)loadCloudPhotosWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit
{
    // We'll make a web request here going forward, which should ideally support
    // pagination and handle these checks by itself if it does not give the total
    // number of photos in advance.

    // No use going further if there are no remaining photos
    NSUInteger remainingPhotosInBatch = [self getCloudPhotosRemainingWithOffset:offset withLimit:limit];

    if (remainingPhotosInBatch == 0)
        return;
    else
        limit = remainingPhotosInBatch;

    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

    NSArray *thumbnailURLs = [self getThumbnailURLArrayWithOffset:offset withLimit:limit];
    NSArray *imageURLs = [self getImageURLArrayWithOffset:offset withLimit:limit];

    for (NSUInteger i = offset; i < offset + limit; ++i)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        MPCloudPhotoModel *model = [[MPCloudPhotoModel alloc] init];

        model.linkToFullImage = imageURLs[i - offset];

        // TODO: Change this to actual thumbnail URLs
        model.linkToThumbnail = thumbnailURLs[i - offset];

        [self.photoModels addObject:model];
        //NSLog(@"MPPhotoPicker: image model count is now: %lu", self.photoModels.count);
        [indexPaths addObject:indexPath];
    }

    // Don't insert items when no cells are visible. When we tell the collection view to
    // reload its data, it starts creating cells. After this, it is safe to append new
    // items to the collection view.
    if (self.isGoingForFirstLoad)
    {
        [self.photoCollectionView reloadData];
        return;
    }

    [self.photoCollectionView performBatchUpdates:^(void)
    {
        [self.photoCollectionView insertItemsAtIndexPaths:indexPaths];
    } completion:^(BOOL finished)
    {

    }];
}

- (NSArray *)getThumbnailURLArrayWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for (NSUInteger i = offset; i < offset + limit; ++i)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage%03lu.jpg", (unsigned long)i]];

        [array addObject:url];
    }

    return array;
}

- (NSArray *)getImageURLArrayWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit
{
    NSMutableArray *array = [[NSMutableArray alloc] init];

    for (NSUInteger i = offset; i < offset + limit; ++i)
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage%03lu.jpg", (unsigned long)i]];

        [array addObject:url];
    }

    return array;
}

- (NSUInteger)getCloudPhotosRemainingWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit
{
    // TODO: Change this
    const NSUInteger numberOfPhotos = 99;

    if (offset >= (numberOfPhotos - 1))
        return 0;

    // There are less photos remaining than what we were told to get
    if ((offset + limit) > numberOfPhotos)
        limit = numberOfPhotos - offset;

    return limit;
}

- (void)checkHomestylerPhotos
{
    if (!self.currentAlbum)
    {
        [self cleanup];

        // We do not have the album, let's get it
        __weak MPPhotoPickerViewController *weakSelf = self;

        [MPPhotoAlbumUtility fetchHomestylerCloudAlbumWithAssetID:self.assetID
                                              withCompletionBlock:^(MPCloudPhotoAlbumModel *model)
         {
             MPPhotoPickerViewController *strongInnerSelf = weakSelf;

             if (model.cloudFiles.count == 0)
             {
                 strongInnerSelf.currentAlbum = nil;

                 [strongInnerSelf setPlaceholderViewEnabled:YES];
             }
             else
             {
                 strongInnerSelf.currentAlbum = model;

                 [strongInnerSelf reloadCollectionView];
             }
         }
                                                 withFailureBlock:^(NSError *error)
         {
             MPPhotoPickerViewController *strongInnerSelf = weakSelf;
             NSLog(@"MPPhotoPicker: Error while getting homestyler cloud files: %@", error.localizedDescription);
             [strongInnerSelf cleanup];
             [strongInnerSelf setPlaceholderViewEnabled:YES];
         }];
    }
    else
    {
        // We have the album, fortunately
        MPCloudPhotoAlbumModel *cloudModel = (MPCloudPhotoAlbumModel *)self.currentAlbum;

        if (cloudModel.cloudFiles.count == 0)
        {
            [self cleanup];
            [self setPlaceholderViewEnabled:YES];
        }
        else
        {
            [self cleanup];
            [self reloadCollectionView];
        }
    }
}

- (void)loadLocalPhotosWithOffset:(NSUInteger)offset withLimit:(NSUInteger)limit
{
    MPUserLibraryPhotoAlbumModel *model = (MPUserLibraryPhotoAlbumModel *)self.currentAlbum;

    // We need to be careful about not exceeding the total number of photos present
    // in the collection
    if (offset > (model.numberOfPhotos - 1))
        return;

    // There are less photos remaining than what we were told to get
    if ((offset + limit) > (model.numberOfPhotos))
        limit = model.numberOfPhotos - offset;

    PHAssetCollection *assetCollection = model.assetCollection;

    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    fetchOptions.includeHiddenAssets = NO;
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *assets = [PHAsset fetchAssetsInAssetCollection:assetCollection options:fetchOptions];

    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];

    for (NSUInteger i = offset; i < offset + limit; ++i)
    {
        PHAsset *asset = [assets objectAtIndex:i];
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        MPUserLibraryPhotoModel *photoModel = [[MPUserLibraryPhotoModel alloc] init];

        // Store the PHAsset in the model for later reference
        photoModel.asset = asset;

        [self.photoModels addObject:photoModel];
        [indexPaths addObject:indexPath];
    }

    // Don't insert items when no cells are visible. When we tell the collection view to
    // reload its data, it starts creating cells. After this, it is safe to append new
    // items to the collection view.
    if (self.isGoingForFirstLoad)
    {
        [self.photoCollectionView reloadData];
        return;
    }

    @try
    {
        __weak MPPhotoPickerViewController *weakSelf = self;
        [self.photoCollectionView performBatchUpdates:^(void)
         {
             [weakSelf.photoCollectionView insertItemsAtIndexPaths:indexPaths];
         } completion:^(BOOL finished)
         {

         }];
    }
    @catch (NSException *exception)
    {
        NSLog(@"MPPhotoPicker: Exception when loading photos with %lu offset and %lu limit", (unsigned long)offset, (unsigned long)limit);
        NSLog(@"MPPhotoPicker: Exception while inserting cells: %@", exception.reason);
    }
    @finally
    {

    }
}

#pragma mark - UICollectionView methods

- (void)reloadCollectionView
{
    [self cleanup];

    self.isGoingForFirstLoad = YES;
    //[self loadCollectionViewWithPage:0];
    //[self loadCollectionViewWithPage:1];
    [self loadCollectionViewWithFullAlbum];

    // Scroll back to the top when reloading the collection view
    [self.photoCollectionView setContentOffset:CGPointZero];

    [self.photoCollectionView reloadData];

    self.isGoingForFirstLoad = NO;
}

- (void)cleanup
{
    // Disable the next button
    [self setNextEnabled:NO];

    // Hide the placeholder View
    [self setPlaceholderViewEnabled:NO];

    self.currentPage = 0;

    // Remove the old arrays
    self.photoModels = nil;
    self.selectedCellArray = nil;
    self.imageWebRequests = nil;

    self.photoModels = [[NSMutableArray alloc] init];
    self.selectedCellArray = [[NSMutableArray alloc] init];
    self.imageWebRequests = [[NSMutableDictionary alloc] init];

    [self setNavigationBarTitle:self.currentAlbum.name];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // We're only interested in events from our collection view
    if (scrollView != (UIScrollView *)(self.photoCollectionView))
        return;

    CGFloat pageHeight = CGRectGetHeight(self.photoCollectionView.frame);
    NSUInteger page = floor((self.photoCollectionView.contentOffset.y - pageHeight / 2) / pageHeight) + 1;

    // Don't load the current (and the previous) pages again
    if (page <= self.currentPage)
        return;

    self.currentPage = page;

    if (self.currentAlbum.albumType == MPPhotoAlbumTypeUserLibrary)
        [self updateCachedAssets];

    // Load the current page and the page below
    //[self loadCollectionViewWithPage:page];
    //[self loadCollectionViewWithPage:page + 1];
}

#pragma mark - UICollectionViewDelegate methods

- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photoModels.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentAlbum.albumType == MPPhotoAlbumTypeUserLibrary)
    {
        MPUserLibraryPhotoCell *cell = (MPUserLibraryPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_userLibraryPhotoCollectionCellIdentifier forIndexPath:indexPath];

        [cell clearAllData];

        cell.delegate = self;

        NSUInteger newIndex = indexPath.item;

        for (NSNumber *num in self.selectedCellArray)
        {
            if (newIndex == [num integerValue])
            {
                [cell setPhotoCellSelected:YES];
                break;
            }
        }

        [cell updatePhotoCellForIndex:newIndex];

        [self fetchLocalImageForPhotoCell:cell withIndex:newIndex];

        return cell;
    }
    else if (self.currentAlbum.albumType == MPPhotoAlbumTypeCloud)
    {
        MPCloudPhotoCell *cell = (MPCloudPhotoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:_cloudPhotoCollectionCellIdentifier forIndexPath:indexPath];

        // If this cell was reused, we need to cancel its download request
        NSUInteger oldIndex = cell.index;
        if (oldIndex != -1)
            [self cancelRequestForIndex:oldIndex];

        [cell clearAllData];

        cell.delegate = self;

        NSUInteger newIndex = indexPath.item;
        for (NSNumber *num in self.selectedCellArray)
        {
            if (newIndex == [num integerValue])
            {
                [cell setPhotoCellSelected:YES];
                break;
            }
        }

        [cell updatePhotoCellForIndex:newIndex];

        [self fetchCloudImageForPhotoCell:cell withIndex:newIndex];

        return cell;
    }

    // Returning a base cell, would not reach this point if everything is correct
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"placeholderCell" forIndexPath:indexPath];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

#pragma mark - MPCloudPhotoCellDelegate

- (void)cloudCellTappedAtIndex:(NSUInteger)index isSelected:(BOOL)selected
{
    [self handleSelectionForIndex:index isSelected:selected];
}

#pragma mark - MPUserLibraryCellDelegate

- (void)userLibraryCellTappedAtIndex:(NSUInteger)index isSelected:(BOOL)selected
{
    [self handleSelectionForIndex:index isSelected:selected];
}

#pragma mark - MPPhotoAlbumPickerDelegate

- (void)photoSourceChangedTo:(MPPhotoAlbumModel *)model
{
    self.currentAlbum = model;

    [self performSelector:@selector(dismissAlbumPickerWithAlbumChanged:) withObject:@1 afterDelay:0.01f];
}

- (UIImage *)normalizedImageForImage:(UIImage *)sourceImage
{
    if (!sourceImage.imageOrientation)
    {
        NSLog(@"MPPhotoPicker: No orientation metadata on image, returning original");
        return sourceImage;
    }

    if (sourceImage.imageOrientation == UIImageOrientationUp) return sourceImage;

    UIGraphicsBeginImageContextWithOptions(sourceImage.size, NO, sourceImage.scale);
    [sourceImage drawInRect:(CGRect){0, 0, sourceImage.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

@end
