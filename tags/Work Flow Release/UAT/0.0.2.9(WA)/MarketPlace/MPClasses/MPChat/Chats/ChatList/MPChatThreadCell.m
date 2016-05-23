//
//  MPChatThreadCellTableViewCell.m
//  MarketPlace
//
//  Created by Avinash Mishra on 12/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPChatThreadCell.h"
#import "MPChatThread.h"
#import "MPChatUser.h"
#import "MPChatMessage.h"
#import "MPChatHttpManager.h"
#import "MPDateUtility.h"
#import "SDWebImageDownloader.h"
#import "UIImageView+WebCache.h"
#import "MPChatUtility.h"
#import "MPChatCommandInfo.h"

#define NAMELENGTH          8
#define ASSETNAMELENGTH     6
#define TOTALNAMELENGTH     12



@interface MPChatThreadCell ()
{
    __strong id <SDWebImageOperation>   _downloadOperation;
}

@end

@implementation MPChatThreadCell

- (NSString*) getTextForLastmessage:(MPChatMessage*) message
{
    switch (message.message_media_type)
    {
        case eAUDIO:
            return [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"Audio", @"Audio")];
            
        case eCOMMAND:
        {
            MPChatCommandInfo* info = [MPChatMessage getCommandInfoFromMessage:message];
            return [self.delegate isLoggedInUserIsDesigner] ? info.for_designer : info.for_consumer;
        }
            
        case eIMAGE:
            return [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"Image", @"Image")];
            
        case eTEXT:
        default:
            return message.body;
    }
}

- (void) updateImageForCell
{
    if (_downloadOperation)
        [_downloadOperation cancel];

    MPChatUser* user = [self.delegate getReciepientUserserForIndex:_index];

    _chatImage.image = [UIImage imageNamed:@"icon_default_new"];
    if (![MPChatUtility isAvatarImageIsDefaultForUser:user.profile_image])
    {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        _downloadOperation = [manager downloadImageWithURL:[NSURL URLWithString:user.profile_image]
                              options:0
                             progress:nil
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL)
         {
             MPChatUser* user = [self.delegate getReciepientUserserForIndex:_index];
             if ([[imageURL absoluteString] isEqualToString:user.profile_image])
             {
                 _chatImage.image = image;
                 _downloadOperation = nil;
             }
        }];
    }
}

- (void) updateName
{
    MPChatUser* user = [self.delegate getReciepientUserserForIndex:_index];
    NSString* displayName = [MPChatUtility getUserDisplayNameFromUser:user.name];
    NSString* name = displayName.length > NAMELENGTH ? [NSString stringWithFormat:@"%@...", [displayName substringWithRange:NSMakeRange(0, NAMELENGTH)]] : displayName;
    _name.text = name;
    MPChatThread* chatThread = [self.delegate getChatThreadForIndex:_index];
    NSString* assetName = [MPChatUtility getAssetNameFromThread:chatThread];
//
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    NSString * thread_Id = chatThread.thread_id;
    
    if ([self.delegate isLoggedInUserIsDesigner] && !(assetName==nil)&& ![assetName isEqualToString:@"null"])
    {
        assetName = assetName.length > ASSETNAMELENGTH ? [NSString stringWithFormat:@"%@...", [assetName substringWithRange:NSMakeRange(0, ASSETNAMELENGTH)]] : assetName;
        NSString* nameText = [NSString stringWithFormat:@"%@/%@", name, assetName];
        _name.text = nameText;
    }
    else
    {
        name = displayName.length > TOTALNAMELENGTH ? [NSString stringWithFormat:@"%@...", [displayName substringWithRange:NSMakeRange(0, TOTALNAMELENGTH)]] : displayName;
        
        //if ([MPChatUtility isSystemThread:thread_Id])
            //name =[MPChatUtility getSystemThreaduserName:thread_Id withDefault:name];
        
        _name.text = name;
    }
}
       


- (void) updateUIWithIndex:(NSUInteger) index
{
    _index = index;
    
    MPChatThread* chatThread = [self.delegate getChatThreadForIndex:index];
    
    [self updateName];
    _description.text = [self getTextForLastmessage:chatThread.lastMessage];
    _messageUnreadCount.text = [chatThread.unread_message_count stringValue];
    
    MPChatMessage* message = chatThread.lastMessage;
    NSDate* sendDate = [MPChatHttpManager acsDateToNSDate:message.sent_time];
    NSString* timeString = [MPDateUtility formattedStringFromDateForChatList:sendDate];

    _timeStamp.text = timeString;

    _messageUnreadCount.layer.cornerRadius = (_messageUnreadCount.frame.size.width / 2);

    _chatImage.image = nil;
    _messageUnreadCount.hidden = YES;
    
    if ([chatThread.unread_message_count integerValue] > 0)
        _messageUnreadCount.hidden = NO;
    [self updateImageForCell];

//    _assetStepLabel.text = @"";
//    _assetStepLabel.hidden = YES;
//    NSString* stepName = [MPChatUtility getWorkflowStepNameFromThread:chatThread];
//    NSArray* stepNames = [stepName componentsSeparatedByString:@"_"];
//    if (stepName && stepNames.count == 2)
//    {
//        _assetStepLabel.hidden = NO;
//        _assetStepLabel.text = [self.delegate isLoggedInUserIsDesigner] ? stepNames[0] : stepNames[1];
//    }
//    if (stepName) {
//        _assetStepLabel.hidden = NO;
//        if ([stepName isEqualToString:@"start_node"]) {
//            _assetStepLabel.text = @"沟通";
//        }else if ([stepName isEqualToString:@"measure"]) {
//            _assetStepLabel.text = @"确认量房";
//        }else if ([stepName isEqualToString:@"payment_of_measure"]) {
//            _assetStepLabel.text = [self.delegate isLoggedInUserIsDesigner] ? @"接收量房费用" : @"支付量房费用";
//        }else if ([stepName isEqualToString:@"confirm_contract"]) {
//            _assetStepLabel.text = [self.delegate isLoggedInUserIsDesigner] ? @"创建设计合同" : @"接收设计合同";
//        }else if ([stepName isEqualToString:@"payment_of_first_fee"]) {
//            _assetStepLabel.text = [self.delegate isLoggedInUserIsDesigner] ? @"接收设计首款" : @"支付设计首款";
//        }else if ([stepName isEqualToString:@"payment_of_last_fee"]) {
//            _assetStepLabel.text = [self.delegate isLoggedInUserIsDesigner] ? @"接收设计尾款" : @"支付设计尾款";
//        }else if ([stepName isEqualToString:@"delivery"]) {
//            _assetStepLabel.text = [self.delegate isLoggedInUserIsDesigner] ? @"上传设计交付物" : @"接收设计交付物";
//        }else {
//            _assetStepLabel.text = @"";
//        }
//    }
}

@end
