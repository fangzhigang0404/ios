//
//  MPMemberUnreadMsgCountManager.m
//  MarketPlace
//
//  Created by Avinash Mishra on 24/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPMemberUnreadMsgCountManager.h"
#import "MPWebSocketManagerBroadcaster.h"
#import "MPBaseChatRoomViewController.h"
#import "MPChatHttpManager.h"
#import "MPChatTestUser.h"


@interface MPMemberUnreadMsgCountManager ()
{

}


@end


@implementation MPMemberUnreadMsgCountManager


+ (instancetype)sharedInstance
{
    static MPMemberUnreadMsgCountManager *s_request = nil;
    static dispatch_once_t s_predicate;
    dispatch_once(&s_predicate, ^{
        s_request = [[super allocWithZone:NULL]init];
    });
    
    return s_request;
}


///override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [MPMemberUnreadMsgCountManager sharedInstance];
}


///override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone
{
    return [MPMemberUnreadMsgCountManager sharedInstance];
}


- (void) registerForMessageUpdate
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLoginNotification:)
                                                 name:MPNotiForLoginIn
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveLogoutNotification:)
                                                 name:MPNotiForLoginOut
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageGotFromNotification:) name:MPCHATNEWMESSAGENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadMessageCount:) name:MP_ON_USER_LEFT_CHATROOM object:nil];
}


- (void) unregisterForMessageUpdate
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) messageGotFromNotification:(NSNotification*) notification
{
    [self getMemberThreadUnreadCount];
}


- (void) refreshUnreadMessageCount:(NSNotification*) notification
{
    [self getMemberThreadUnreadCount];
}


#pragma mark - login related notification receivers

- (void) receiveLoginNotification:(NSNotification*)notification
{
    [self setMemberId:[AppController AppGlobal_GetMemberInfoObj].acs_member_id];
    [self getMemberThreadUnreadCount];
}


- (void) receiveLogoutNotification:(NSNotification*)notification
{
    UITabBarItem* item = [self.delegate tabBarItemForUnreadCount];
    item.badgeValue = nil;
}



#pragma - ------UnreadCountMessageHandler---------

- (void) getMemberThreadUnreadCount
{
    if ([AppController AppGlobal_GetLoginStatus]) {
        if (self.memberId)
        {
            [[MPChatHttpManager sharedInstance] retrieveMemberUnreadMessageCount:self.memberId needAllMessages:YES success:^(NSInteger count)
             {
                 UITabBarItem* item = [self.delegate tabBarItemForUnreadCount];
                 if (count > 0)
                     item.badgeValue = [NSString stringWithFormat:@"%ld%@", count > 99 ? 99 : (long)count,  count > 99 ? @"+" : @""];
                 else
                     item.badgeValue = nil;
             }
                                                                         failure:^(NSError *error)
             {
                 
             }];
        }

    }
}



@end
