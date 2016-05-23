//
//  CustomTableViewCell.m
//  tests
//
//  Created by Avinash Mishra on 29/01/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatViewCell.h"
#import "MPChatImageViewCell.h"
#import "MPChatMessage.h"
#import "UIImageView+WebCache.h"

@interface MPChatImageViewCell ()
{
    __weak IBOutlet UILabel*        _imageTitle;
    __weak IBOutlet UILabel*        _imageMessage;
    __weak IBOutlet UIImageView*    _imageView;
    __weak IBOutlet UILabel*        _unreadMessageCount;
    __weak IBOutlet UIView*         _imageBackgroundView;

    __strong id <SDWebImageOperation>   _imageDownloadOperation;
}

@end


@implementation MPChatImageViewCell

- (void)awakeFromNib
{
    [self addTapOnImage];
}


- (void) addTapOnImage
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [_imageView addGestureRecognizer:tap];
}

- (void) imageTapped:(UITapGestureRecognizer*)tapG
{
    [self.delegate onCellChildUIActionForIndex:_index];
}

- (void) updateCellForIndex:(NSUInteger) index
{
    [super updateCellForIndex:index];
   
    
    _imageMessage.hidden = YES;
    _unreadMessageCount.hidden = YES;
    
    //    _unreadMessageCount.text = msg.unreadMessageCount;
    
    _imageView.image = nil;
    _imageView.hidden = YES;
    MPChatMessage* msg = [self.delegate getCellModelForIndex:index];
    NSString* imageURLString = [NSString stringWithFormat:@"%@Medium.jpg", msg.body];
    if (_imageDownloadOperation)
        [_imageDownloadOperation cancel];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    _imageDownloadOperation = [manager downloadImageWithURL:[NSURL URLWithString:imageURLString]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
                          {
                              MPChatMessage* msg = [self.delegate getCellModelForIndex:_index];
                              NSString* urlString = [NSString stringWithFormat:@"%@Medium.jpg", msg.body];
                              if ([[imageURL absoluteString] isEqualToString:urlString])
                              {
                                  _imageView.hidden = NO;
                                  _imageView.image = image;
                                  _imageDownloadOperation = nil;
                              }
                          }];
    
    
    
    CGFloat borderWidth = 2.0f;
    _imageView.layer.cornerRadius = 20.0;
    _unreadMessageCount.layer.cornerRadius = (_unreadMessageCount.frame.size.width / 2);
    _imageBackgroundView.layer.cornerRadius = (_imageBackgroundView.frame.size.height / 2);
    _childView.frame = CGRectInset(self.frame, -borderWidth, -borderWidth);
    _childView.layer.borderColor = [UIColor colorWithRed:0.28 green:0.45 blue:1.0 alpha:1.0].CGColor;
    _childView.layer.borderWidth = borderWidth;
}

@end
