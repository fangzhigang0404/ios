//
//  MPPhotoAlbumPickerViewController.m
//  MarketPlace
//
//  Created by Arnav Jain on 09/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

@import Photos;
#import "MPPhotoAlbumPickerViewController.h"
#import "MPCloudPhotoAlbumCell.h"
#import "MPCloudPhotoAlbumModel.h"
#import "MPUserLibraryPhotoAlbumCell.h"
#import "MPUserLibraryPhotoAlbumModel.h"
#import "MPPhotoUtility.h"
#import "MPPhotoAlbumUtility.h"
#import "MPFileUtility.h"
#import "MPMember.h"

@interface MPPhotoAlbumPickerViewController () <UITableViewDelegate>
{
    NSString* _cloudCellIdentifier;
    NSString* _userLibraryCellIdentifier;
    int _cloudAlbumPosition;
}

@property (weak, nonatomic) IBOutlet UITableView *sourceListView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sourceListViewBottomConstraint;

@property (nonatomic, strong) NSMutableArray *photoSourceArray;
@property (nonatomic) NSUInteger currentlySelectedRow;
@property (nonatomic, strong) NSString *assetID;

@property (nonatomic) BOOL isCloudModelReady;

- (void)fetchCloudImageForAlbumCellWithIndex:(NSUInteger)index;
- (void)fetchLocalImageForAlbumCellWithIndex:(NSUInteger)index;
- (void)initSourceModels;
- (void)setSelectedStateForAlbumCell:(UITableViewCell *)tableViewCell withIndexPath:(NSIndexPath *)indexPath withSelectedState:(BOOL)selected;

@end

@implementation MPPhotoAlbumPickerViewController

- (instancetype)initWithCurrentAlbum:(MPPhotoAlbumModel *)model withAssetID:(NSString *)assetID
{
    self = [super init];

    if (self)
    {
        self.assetID = assetID;
        [self initSourceModels];

        if (!model)
            self.currentlySelectedRow = 0;
        else
        {
            NSInteger targetRow = [self getRowForModel:model];
            assert(targetRow != -1);

            self.currentlySelectedRow = targetRow;
        }

        self.isCloudModelReady = NO;

        _cloudCellIdentifier = @"CloudPhotoAlbumCell";
        _userLibraryCellIdentifier = @"UserLibraryPhotoAlbumCell";
        _cloudAlbumPosition = 0;
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.sourceListView registerNib:[UINib nibWithNibName:@"MPCloudPhotoAlbumCell" bundle:nil]
              forCellReuseIdentifier:_cloudCellIdentifier];
    [self.sourceListView registerNib:[UINib nibWithNibName:@"MPUserLibraryPhotoAlbumCell" bundle:nil]
              forCellReuseIdentifier:_userLibraryCellIdentifier];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - DataModel methods

- (void)initSourceModels
{
    self.photoSourceArray = [[NSMutableArray alloc] init];

    if (self.assetID && [[MPMember shareMember] MemberIsDesignerMode])
    {
        MPCloudPhotoAlbumModel *cloudModel = [[MPCloudPhotoAlbumModel alloc] init];

        cloudModel.name = NSLocalizedString(@"album_picker_cloud_storage_label", nil);
        cloudModel.albumType = MPPhotoAlbumTypeCloud;

        cloudModel.cloudFiles = nil;
        cloudModel.thumbnailURL = nil;

        [self.photoSourceArray insertObject:cloudModel atIndex:_cloudAlbumPosition];

        __weak MPPhotoAlbumPickerViewController *weakSelf = self;
        [MPPhotoAlbumUtility fetchHomestylerCloudAlbumWithAssetID:self.assetID
                                              withCompletionBlock:^(MPCloudPhotoAlbumModel *model)
         {
             MPPhotoAlbumPickerViewController *strongInnerSelf = weakSelf;
             MPCloudPhotoAlbumModel *cloudModel = strongInnerSelf.photoSourceArray[_cloudAlbumPosition];

             cloudModel.thumbnailURL = model.thumbnailURL;
             cloudModel.cloudFiles = model.cloudFiles;
             cloudModel.thumbnailID = model.thumbnailID;

             strongInnerSelf.isCloudModelReady = YES;

             [strongInnerSelf fetchCloudImageForAlbumCellWithIndex:_cloudAlbumPosition];
         }
                                                 withFailureBlock:^(NSError *error)
         {
             NSLog(@"Could not load homestyler albums: %@", error.localizedDescription);
         }];
    }

    // Get the models from local storage
    [self.photoSourceArray addObjectsFromArray:[MPPhotoAlbumUtility getLocalAlbums]];
}

- (NSInteger)getRowForModel:(MPPhotoAlbumModel *)targetModel
{
    NSUInteger i = 0;
    for (MPPhotoAlbumModel *model in self.photoSourceArray)
    {
        if ([model.name isEqualToString:targetModel.name] && (model.albumType == targetModel.albumType))
            return i;

        ++i;
    }

    return -1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Photo loading methods
- (void)fetchCloudImageForAlbumCellWithIndex:(NSUInteger)index
{
    MPPhotoAlbumModel *baseModel = self.photoSourceArray[index];

    assert(baseModel.albumType == MPPhotoAlbumTypeCloud);

    MPCloudPhotoAlbumModel *model = (MPCloudPhotoAlbumModel *)baseModel;
    NSURL *imageLink = model.thumbnailURL;

    // Now is not the time to load the image
    if (!imageLink)
        return;

    __weak MPPhotoAlbumPickerViewController *weakSelf = self;
    __weak MPCloudPhotoAlbumModel *weakModel = model;
    SDWebImageCompletionWithFinishedBlock completionBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
    {
        if (!weakSelf || !weakModel)
            return;

        NSUInteger innerIndex = [weakSelf.photoSourceArray indexOfObject:weakModel];

        if (image)
        {
            NSString *filePath = [MPFileUtility writeImage:image
                                                  withName:[MPFileUtility getUniqueFileName]
                                       isPNGRepresentation:NO];

            if (filePath)
            {
                weakModel.cachedFile = [NSURL fileURLWithPath:filePath];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:innerIndex inSection:0];

                [weakSelf.sourceListView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
               // [weakSelf.sourceListView reloadData];
            }
        }
        else
            NSLog(@"Image not obtained for URL: %@", imageURL);
    };

    if (imageLink)
        [MPPhotoUtility downloadThumbnailFromURL:imageLink withCompletionBlock:completionBlock];
}

- (void)fetchLocalImageForAlbumCellWithIndex:(NSUInteger)index
{
    MPPhotoAlbumModel *baseModel = self.photoSourceArray[index];

    assert(baseModel.albumType == MPPhotoAlbumTypeUserLibrary);

    MPUserLibraryPhotoAlbumModel *model = (MPUserLibraryPhotoAlbumModel *)baseModel;

    PHAsset *asset = model.thumbnailAsset;

    __weak MPPhotoAlbumPickerViewController *weakSelf = self;
    __weak MPUserLibraryPhotoAlbumModel *weakModel = model;
    MPImageFromPHAssetCompletionBlock completionBlock = ^(UIImage *image, NSDictionary *info)
    {
        if (!weakSelf || !weakModel)
            return;

        NSUInteger innerIndex = [weakSelf.photoSourceArray indexOfObject:weakModel];

        if (image)
        {
            NSString *filePath = [MPFileUtility writeImage:image
                withName:[MPFileUtility getUniqueFileName]
                isPNGRepresentation:NO];

            if (filePath)
            {
                
                weakModel.cachedFile = [NSURL fileURLWithPath:filePath];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:innerIndex inSection:0];
                
                //[weakSelf.sourceListView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.sourceListView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }
        else
            NSLog(@"Image not obtained for local asset with index: %lu", (unsigned long)innerIndex);
    };

    if (asset)
        [MPPhotoUtility fetchThumbnailImageFromAsset:asset withCompletionBlock:completionBlock];
}

#pragma mark - UITableView methods

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The first row, our cloud storage folder is the default selected row
    // 1. We do not allow the user to proceed with no selected rows
    // 2. We do not allow multiple selections
    // 3. We do not allow deselections
    if (self.currentlySelectedRow == indexPath.row)
        return;

    MPPhotoAlbumModel *baseModel = self.photoSourceArray[_cloudAlbumPosition];

    if (baseModel.albumType == MPPhotoAlbumTypeCloud)
    {
        // Don't let the user choose the cloud album until it is ready for use
        if (indexPath.row == _cloudAlbumPosition && !self.isCloudModelReady)
            return;
    }

    // Deselect the previously selected cell
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentlySelectedRow inSection:0];
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];

    [self setSelectedStateForAlbumCell:oldCell withIndexPath:oldIndexPath withSelectedState:NO];

    // Select the new cell
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];

    [self setSelectedStateForAlbumCell:selectedCell withIndexPath:indexPath withSelectedState:YES];

    self.currentlySelectedRow = indexPath.row;

    if ([self.delegate respondsToSelector:@selector(photoSourceChangedTo:)])
    {
        [self.delegate photoSourceChangedTo:self.photoSourceArray[self.currentlySelectedRow]];
    }
}

- (void)setSelectedStateForAlbumCell:(UITableViewCell *)tableViewCell withIndexPath:(NSIndexPath *)indexPath withSelectedState:(BOOL)selected
{
    MPPhotoAlbumModel *baseModel = self.photoSourceArray[indexPath.row];

    if (baseModel.albumType == MPPhotoAlbumTypeCloud)
    {
        MPCloudPhotoAlbumCell *cell = (MPCloudPhotoAlbumCell *)tableViewCell;
        [cell setAlbumCellSelected:selected];
    }
    else if (baseModel.albumType == MPPhotoAlbumTypeUserLibrary)
    {
        MPUserLibraryPhotoAlbumCell *cell = (MPUserLibraryPhotoAlbumCell *)tableViewCell;
        [cell setAlbumCellSelected:selected];
    }
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photoSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPPhotoAlbumModel *baseModel = self.photoSourceArray[indexPath.row];

    if (baseModel.albumType == MPPhotoAlbumTypeCloud)
    {
        MPCloudPhotoAlbumModel *model = self.photoSourceArray[indexPath.row];

        MPCloudPhotoAlbumCell *cell = (MPCloudPhotoAlbumCell*)[tableView dequeueReusableCellWithIdentifier:_cloudCellIdentifier forIndexPath:indexPath];

        [cell clearAllData];

        [cell updateAlbumCellForIndex:indexPath.row withModel:model];

        if (indexPath.row == self.currentlySelectedRow)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentlySelectedRow inSection:0];
            [self setSelectedStateForAlbumCell:cell withIndexPath:indexPath withSelectedState:YES];
        }

        if (!model.cachedFile)
            [self fetchCloudImageForAlbumCellWithIndex:indexPath.row];
        else
            [cell setThumbnailForAlbumCell:[UIImage imageWithContentsOfFile:model.cachedFile.path]];

        return cell;
    }
    else if (baseModel.albumType == MPPhotoAlbumTypeUserLibrary)
    {
        MPUserLibraryPhotoAlbumModel *model = self.photoSourceArray[indexPath.row];

        MPUserLibraryPhotoAlbumCell *cell = (MPUserLibraryPhotoAlbumCell*)[tableView dequeueReusableCellWithIdentifier:_userLibraryCellIdentifier forIndexPath:indexPath];

        [cell clearAllData];

        [cell updateAlbumCellForIndex:indexPath.row withModel:model];

        if (indexPath.row == self.currentlySelectedRow)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentlySelectedRow inSection:0];
            [self setSelectedStateForAlbumCell:cell withIndexPath:indexPath withSelectedState:YES];
        }

        if (!model.cachedFile)
            [self fetchLocalImageForAlbumCellWithIndex:indexPath.row];
        else
            [cell setThumbnailForAlbumCell:[UIImage imageWithContentsOfFile:model.cachedFile.path]];

        return cell;
    }

    // Returning a base cell, would not reach this point if everything is correct
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"placeholderCell"];

    return cell;
}

@end
