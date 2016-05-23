//
//  MPImageCell.m
//  MarketPlace
//
//  Created by Arnav Jain on 08/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPImageCell.h"

@interface MPImageCell()
{

}

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

@implementation MPImageCell

@synthesize index = _index;

- (void)awakeFromNib
{
    // Set a placeholder color
    self.imageButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)updateImageCellForIndex:(NSUInteger)index
{
    // Set the identifier
    _index = index;

    self.imageButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)clearAllData
{
    // Set a sentinel value for the identifier
    _index = -1;

    // Set a placeholder color
    self.imageButton.backgroundColor = [UIColor lightGrayColor];
}

- (void)updateImageCellWithImage:(UIImage *)image
{
    // Set the image
    [self.imageButton setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)imageTapped:(id)sender
{
    [self.delegate imageCellTappedAtIndex:self.index];
}

@end
