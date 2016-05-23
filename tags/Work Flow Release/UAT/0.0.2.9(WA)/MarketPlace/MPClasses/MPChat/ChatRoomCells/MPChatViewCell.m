//
//  ChatViewCell.m
//  tests
//
//  Created by Avinash Mishra on 02/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatViewCell.h"
#import "UIImageView+WebCache.h"
#import "MPMarketplaceSettings.h"
#import "MPChatHttpManager.h"
#import "MPChatTestUser.h"
#import "SDWebImageDownloader.h"
#import "MPDateUtility.h"
#import "MPUIUtility.h"
#import "MPChatUtility.h"



@interface MPChatViewCell ()
{
    __strong id <SDWebImageOperation>   _downloadOperation;
}
@end

# pragma mark ----ChatViewCell----


@implementation MPChatViewCell


- (NSUInteger) index
{
    return _index;
}

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

/// do something you want in this method.
- (void) updateSenderImage
{
    MPChatMessage* msg = [self.delegate getCellModelForIndex:_index];
    _senderImageView.image = [UIImage imageNamed:@"icon_default_new"];
    if (![MPChatUtility isAvatarImageIsDefaultForUser:msg.sender_profile_image])
    {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
       
        _downloadOperation = [manager downloadImageWithURL:[NSURL URLWithString:msg.sender_profile_image]
                                                   options:0
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
                              {

                                  MPChatMessage* message = [self.delegate getCellModelForIndex:_index];
                                  if ([[imageURL absoluteString] isEqualToString:message.sender_profile_image])
                                  {
                                      _senderImageView.image = image;
                                      _downloadOperation = nil;
                                    }
                              }];
    }
}


- (void) updateCellForIndex:(NSUInteger) index
{
    _index = index;
    
    if (_downloadOperation)
        [_downloadOperation cancel];

    [self updateSenderImage];
    [MPUIUtility setSelectionColorForCell:self
                                    color:[UIColor clearColor]];
    MPChatMessage* msg = [self.delegate getCellModelForIndex:index];
    
    NSDate* sendDate = [MPChatHttpManager acsDateToNSDate:msg.sent_time];
    NSString* timeString = [MPDateUtility formattedTimeFromDateForMessageCell:sendDate];
    _msgSendTime.text = timeString;
    NSString* dateString = [MPDateUtility formattedStringFromDateForChatRoom:sendDate];
    _msgSendDate.text = dateString;
    
    _msgSendParent.hidden = YES;
    if ([self.delegate isDateChageForIndex:_index])
        _msgSendParent.hidden = NO;
    
    _childView.layer.cornerRadius = 10.0f;
    _msgSendParent.layer.cornerRadius = (_msgSendParent.frame.size.height / 2);
    _senderImageView.layer.cornerRadius = (_senderImageView.frame.size.width / 2);
}


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


- (void) dealloc
{
//    NSLog(@"MPChatViewCell Dealloc");
}

@end
