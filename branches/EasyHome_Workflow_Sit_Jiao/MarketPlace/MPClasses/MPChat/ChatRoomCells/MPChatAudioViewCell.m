//
//  ChatImageViewCell.m
//  tests
//
//  Created by Avinash Mishra on 01/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatViewCell.h"
#import "MPChatAudioViewCell.h"
#import "MPChatMessage.h"
#import "MPChatTestUser.h"

@interface MPChatAudioViewCell ()
{
    __weak IBOutlet UILabel*                    _imageMessage;
    __weak IBOutlet UIImageView*                _audioImageView;

    __weak IBOutlet UIView*                     _leftParentView;
    __weak IBOutlet UIActivityIndicatorView*    _activityIndicator;

    __weak IBOutlet NSLayoutConstraint*         _audioImageViewLeftConstraint;
    __weak IBOutlet NSLayoutConstraint*         _audioImageViewRightConstraint;
    
    __weak IBOutlet NSLayoutConstraint*         _audiodurationlavelLeftConstraint;
    __weak IBOutlet NSLayoutConstraint*         _audiodurationlavelRightConstraint;
    
}

@end


@implementation MPChatAudioViewCell

- (void)awakeFromNib
{
    [self addTapOnImage];
}


- (void) addTapOnImage
{
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [_childView addGestureRecognizer:tap];
}

- (void) imageTapped:(UITapGestureRecognizer*)tapG
{
    [self.delegate onCellChildUIActionForIndex:_index];
}


- (void) animateImageView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([self.delegate isCellIsNotForCurrentLoggedInUser:_index])
            _audioImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"audio1R"], [UIImage imageNamed:@"audio2R"], [UIImage imageNamed:@"audio3R"], nil];
        else
            _audioImageView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"audio1"], [UIImage imageNamed:@"audio2"], [UIImage imageNamed:@"audio3"], nil];
        _audioImageView.animationDuration = 1;
        _audioImageView.animationRepeatCount = INFINITY;
        [_audioImageView startAnimating];
    });
}


- (void) updateActivityIndicatorForIndex:(NSUInteger)index
{
    _imageMessage.hidden = YES;
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
    if ([self.delegate respondsToSelector:@selector(getProgressForIndex:)])
    {
        NSInteger progress = [self.delegate getProgressForIndex:index];
        if (progress == 100)
        {
            _imageMessage.hidden = NO;
            _activityIndicator.hidden = YES;
            [_activityIndicator stopAnimating];

            _imageMessage.text = @"";
            NSInteger duration = [self.delegate getMessageDurationForIndex:index];
            if (duration)
                _imageMessage.text = [NSString stringWithFormat:@"%ld\"", (long)duration];
        }
        else
        {
            _imageMessage.hidden = YES;
            _activityIndicator.hidden = (progress == 0) ? YES : NO;
            [_activityIndicator startAnimating];
        }
    }
}

- (void) updateCellForIndex:(NSUInteger) index
{
    [super updateCellForIndex:index];
    [self updateActivityIndicatorForIndex:index];

    _audioImageView.animationImages = nil;
    if ([self.delegate isCellIsNotForCurrentLoggedInUser:index])
        _audioImageView.image = [UIImage imageNamed:@"audioR"];
    else
        _audioImageView.image = [UIImage imageNamed:@"audio"];

    if ([self.delegate isPlayingForIndex:_index])
        [self animateImageView];
    
    _imageMessage.textAlignment = NSTextAlignmentLeft;
    if (![self.delegate isCellIsNotForCurrentLoggedInUser:_index])
        _imageMessage.textAlignment = NSTextAlignmentRight;
//    _childView.layer.borderColor = [UIColor colorWithRed:0.28 green:0.45 blue:1.0 alpha:1.0].CGColor;
//    _childView.layer.borderWidth = borderWidth;
}

@end
