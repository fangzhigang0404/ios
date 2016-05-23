//
//  MPMemberUnreadMsgCountManager.h
//  MarketPlace
//
//  Created by Avinash Mishra on 24/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPMemberUnreadMsgCountManagerDelegate <NSObject>
/**
 *  @brief tabbar item for unread count.
 *
 *  @return UITabBarItem.
 */
- (UITabBarItem*) tabBarItemForUnreadCount;

@end


@interface MPMemberUnreadMsgCountManager : NSObject


/// memberId The memberId is member id.
@property (nonatomic, strong) NSString*                                  memberId;
/// delegate The delegate object observe MPMemberUnreadMsgCountManagerDelegate protocol.
@property (nonatomic, weak) id <MPMemberUnreadMsgCountManagerDelegate>   delegate;
/**
 *  @brief Singleton of MPMemberUnreadMsgCountManager.
 *
 *  @return instancetype MPMemberUnreadMsgCountManager.
 */
+ (instancetype)sharedInstance;
/**
 *  @brief register for message update.
 *
 *  @return void nil.
 */
- (void) registerForMessageUpdate;
/**
 *  @brief unregister for message update.
 *
 *  @return void nil.
 */
- (void) unregisterForMessageUpdate;
/**
 *  @brief get member thread unread count.
 *
 *  @return void nil.
 */
- (void) getMemberThreadUnreadCount;

@end
