//
//  ChatListCell.m
//  tests
//
//  Created by Avinash Mishra on 06/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPImageChatListCell.h"
#import "MPChatThreadCell.h"
#import "MPChatUser.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "MPChatThread.h"
#import "MPChatThumbnails.h"
#import "MPChatThumbnail.h"
#import "MPChatConversations.h"
#import "MPChatUtility.h"


@interface MPImageChatListCell ()
{
    __strong id <SDWebImageOperation>   _downloadOperation;
}

@end


@implementation MPImageChatListCell


- (void) updateImageForCell
{
    if (_downloadOperation)
        [_downloadOperation cancel];
    
    MPChatThread* chatThread = [self.delegate getChatThreadForIndex:_index];
    NSString* imageURL = [NSString stringWithFormat:@"%@Medium.jpg", [MPChatUtility getFileUrlFromThread:chatThread]];

    _chatImage.hidden = NO;
    _chatImage.image = [UIImage imageNamed:@"photopicker_thumbnail_placeholder"];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    _downloadOperation = [manager downloadImageWithURL:[NSURL URLWithString:imageURL]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
                          {
                              MPChatThread* chatThread = [self.delegate getChatThreadForIndex:_index];
                              NSString* inImageURL = [NSString stringWithFormat:@"%@Medium.jpg", [MPChatUtility getFileUrlFromThread:chatThread]];
                              if ([[imageURL absoluteString] isEqualToString:inImageURL])
                              {
                                  _chatImage.image = image;
                                  _downloadOperation = nil;
                              }
                          }];
}


- (void) updateUIWithIndex:(NSUInteger) index
{
    [super updateUIWithIndex:index];
}


+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}


@end
