
/**
 * @file    MPWebSocketManagerBroadcaster.h
 * @brief   socket manager broadcaster.
 * @author  Nilesh Kuber
 * @version 1.0
 * @date    2016-03-16
 *
 */


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
