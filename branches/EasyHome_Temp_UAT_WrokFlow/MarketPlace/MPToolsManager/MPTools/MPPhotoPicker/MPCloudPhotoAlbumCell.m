//
//  MPCloudPhotoAlbumCell.m
//  MarketPlace
//
//  Created by Arnav Jain on 09/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPCloudPhotoAlbumCell.h"
#import "MPCloudPhotoAlbumModel.h"

@interface MPCloudPhotoAlbumCell()
{

}

@property (weak, nonatomic) IBOutlet UIImageView *photoSourceThumbnail;
@property (weak, nonatomic) IBOutlet UILabel *sourceTitle;
@property (weak, nonatomic) IBOutlet UIImageView *cloudBadge;
@property (weak, nonatomic) IBOutlet UIImageView *selectedIndicator;

@property (nonatomic) BOOL isSelected;

@end

@implementation MPCloudPhotoAlbumCell

@synthesize index = _index;

- (void)awakeFromNib {
    _index = -1;

    self.selectedIndicator.hidden = NO;
    [self setAlbumCellSelected:NO];

    self.cloudBadge.image = [UIImage imageNamed:@"cloud_album_badge"];
    self.photoSourceThumbnail.image = [UIImage imageNamed:@"photopicker_thumbnail_placeholder"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    [super setSelected:selected animated:animated];
}

- (void)updateAlbumCellForIndex:(NSUInteger)index withModel:(MPCloudPhotoAlbumModel *)model
{
    _index = index;

    // Set the title
    self.sourceTitle.text = model.name;
}

- (void)clearAllData
{
    [self setAlbumCellSelected:NO];

    _index = -1;

    self.photoSourceThumbnail.image = nil;
    self.sourceTitle.text = @"";

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
