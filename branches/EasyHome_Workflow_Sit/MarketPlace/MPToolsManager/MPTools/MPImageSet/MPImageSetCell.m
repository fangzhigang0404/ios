//
//  MPImageSetCell.m
//  MarketPlace
//
//  Created by Arnav Jain on 01/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPImageSetCell.h"

@interface MPImageSetCell()
{

}

@property (weak, nonatomic) IBOutlet UIImageView *imageSelectedIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (nonatomic) BOOL isImageSelected;

@end

@implementation MPImageSetCell

- (void)awakeFromNib
{
    self.imageSelectedIndicatorView.image = [UIImage imageNamed:@"photopicker_checked"];
    self.isImageSelected = NO;
}


- (void)updateImageCellForIndex:(NSUInteger)index
{
    self.index = index;

    if ([self.delegate respondsToSelector:@selector(getImageForIndex:)])
    {
        UIImage *image = [self.delegate getImageForIndex:self.index];
        [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"Please implement getImageForIndex: to display the image, or use setImage: instead");
    }
}

- (void)clearAllData
{
    self.thumbnailURL = nil;
    self.index = -1;
    [self setSelected:NO];
    UIImage *placeholderImage = [UIImage imageNamed:@"photopicker_thumbnail_placeholder"];
    [self.imageButton setBackgroundImage:placeholderImage forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected
{
    self.imageSelectedIndicatorView.hidden = !selected;
    self.isImageSelected = selected;
}

- (IBAction)imageCellTapped:(id)sender
{
    if ([self.delegate isSelectionAllowed])
    {
        // Toggle the selection
        [self setSelected:!self.isImageSelected];

        [self.delegate imageTappedAtIndex:self.index isSelected:self.isImageSelected];
    }
    else
    {
        // Selection not allowed
        [self.delegate imageTappedAtIndex:self.index isSelected:NO];
    }
}


@end
