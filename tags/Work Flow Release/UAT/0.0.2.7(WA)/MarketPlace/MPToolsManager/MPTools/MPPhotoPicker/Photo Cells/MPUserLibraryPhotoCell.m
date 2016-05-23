//
//  MPUserLibraryPhotoCell.m
//  MarketPlace
//
//  Created by Arnav Jain on 10/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

@import Photos;
#import "MPUserLibraryPhotoCell.h"

@interface MPUserLibraryPhotoCell()
{

}

@property (weak, nonatomic) IBOutlet UIImageView *photoSelectedIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;

@property (nonatomic) BOOL isSelected;

@end

@implementation MPUserLibraryPhotoCell

@synthesize index = _index;

- (void)awakeFromNib
{
    self.isSelected = NO;

    self.photoSelectedIndicator.image = [UIImage imageNamed:@"photopicker_unchecked"];

    [self.thumbnailImage setContentMode:UIViewContentModeScaleAspectFill];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    tapGesture.numberOfTapsRequired = 1;

    [self addGestureRecognizer:tapGesture];
}

- (void)updatePhotoCellForIndex:(NSUInteger)index
{
    _index = index;
}

- (void)clearAllData
{
    _index = -1;

    [self setPhotoCellSelected:NO];

    UIImage *placeholderImage = [UIImage imageNamed:@"photopicker_thumbnail_placeholder"];
    [self.thumbnailImage setImage:placeholderImage];
}

- (void)setThumbnailForPhotoCell:(UIImage *)image
{
    [self.thumbnailImage setImage:image];
}

- (void)imageTapped:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        if ([self.delegate respondsToSelector:@selector(userLibraryCellTappedAtIndex:isSelected:)])
        {
            if (self.isSelected)
                [self.delegate userLibraryCellTappedAtIndex:self.index isSelected:NO];
            else
                [self.delegate userLibraryCellTappedAtIndex:self.index isSelected:YES];
        }
    }
}

- (void)setPhotoCellSelected:(BOOL)selected
{
    if (self.isSelected == selected)
        return;

    self.isSelected = selected;

    if (self.isSelected)
        [self.photoSelectedIndicator setImage:[UIImage imageNamed:@"photopicker_checked"]];
    else
        [self.photoSelectedIndicator setImage:[UIImage imageNamed:@"photopicker_unchecked"]];
}
@end
