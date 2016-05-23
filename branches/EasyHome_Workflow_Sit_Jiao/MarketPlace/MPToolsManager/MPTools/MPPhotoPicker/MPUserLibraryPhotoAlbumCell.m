//
//  MPPhotoSourceCell.m
//  MarketPlace
//
//  Created by Arnav Jain on 04/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

@import Photos;
#import "MPUserLibraryPhotoAlbumCell.h"
#import "MPUserLibraryPhotoAlbumModel.h"

@interface MPUserLibraryPhotoAlbumCell()
{

}

@property (weak, nonatomic) IBOutlet UIImageView *photoSourceThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *photoSourceTitle;
@property (weak, nonatomic) IBOutlet UILabel *photoSourceSubtitle;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIndicator;

@property (nonatomic) BOOL isSelected;

@end


@implementation MPUserLibraryPhotoAlbumCell

@synthesize index = _index;


- (void)awakeFromNib {
    _index = -1;

    self.selectedIndicator.hidden = NO;
    [self setAlbumCellSelected:NO];

    self.photoSourceThumbnail.image = [UIImage imageNamed:@"photopicker_thumbnail_placeholder"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

- (void)updateAlbumCellForIndex:(NSUInteger)index withModel:(MPUserLibraryPhotoAlbumModel *)model
{
    _index = index;

    // Set the title
    self.photoSourceTitle.text = model.name;

    // Set the subtitle
    NSString *photosText = NSLocalizedString(@"album_cell_number_of_photos", nil);
    self.photoSourceSubtitle.text = [[@(model.numberOfPhotos) stringValue] stringByAppendingString:photosText];
}

- (void)clearAllData
{
    [self setAlbumCellSelected:NO];

    _index = -1;
    self.photoSourceTitle.text = @"";
    self.photoSourceSubtitle.text = @"";
    self.photoSourceThumbnail.image = nil;

    self.photoSourceThumbnail.image = [UIImage imageNamed:@"photopicker_thumbnail_placeholder"];
}

- (void)setThumbnailForAlbumCell:(UIImage *)image;
{
    self.photoSourceThumbnail.image = image;
}

- (void)setAlbumCellSelected:(BOOL)selected
{
    self.isSelected = selected;

    if (self.isSelected)
        [self.selectedIndicator setImage:[UIImage imageNamed:@"photopicker_checked"]];
    else
        [self.selectedIndicator setImage:[UIImage imageNamed:@"photopicker_unchecked"]];
}

@end
