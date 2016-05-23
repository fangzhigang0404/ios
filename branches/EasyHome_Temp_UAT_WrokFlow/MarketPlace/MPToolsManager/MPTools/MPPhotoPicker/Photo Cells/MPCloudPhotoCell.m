//
//  MPCloudPhotoCell.m
//  MarketPlace
//
//  Created by Arnav Jain on 10/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPCloudPhotoCell.h"

@interface MPCloudPhotoCell()
{

}

@property (weak, nonatomic) IBOutlet UIImageView *photoSelectedIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailImage;

@property (nonatomic) BOOL isSelected;

@end

@implementation MPCloudPhotoCell

@synthesize index = _index;

- (void)awakeFromNib
{
    self.isSelected = NO;

    _index = -1;

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
        if ([self.delegate respondsToSelector:@selector(cloudCellTappedAtIndex:isSelected:)])
        {
            if (self.isSelected)
                [self.delegate cloudCellTappedAtIndex:self.index isSelected:NO];
            else
                [self.delegate cloudCellTappedAtIndex:self.index isSelected:YES];
        }
    }
}

- (void)setPhotoCellSelected:(BOOL)selected
{
    self.isSelected = selected;

    if (self.isSelected)
        [self.photoSelectedIndicator setImage:[UIImage imageNamed:@"photopicker_checked"]];
    else
        [self.photoSelectedIndicator setImage:[UIImage imageNamed:@"photopicker_unchecked"]];
}

@end
