//
//  MPIncomingMessageListener.h
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/3/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPWebSocketManager.h"

#define MPCHATNEWMESSAGENOTIFICATION @"MPChatReceiveNewMessaage"
#define MPCHATCLOSECONNECTIONNOTIFICATION @"MPChatCloseChatConnection"
#define MPCHATDISCONNECTNOTIFICATION @"MPChatDisconnected"
#define MPCHATCONNECTNOTIFICATION @"MPChatConnected"

// This class is implementing MPWebSocketManagerDelegate methods
// It will send notifications mentioned in this header file
// The client needs to register/unregister these notifications

@interface MPWebSocketManagerBroadcaster : NSObject<MPWebSocketManagerDelegate>

@end
