/**
 * @file    MPWebSocketManager.h
 * @brief   the manager of Web Socket.
 * @author  Jiao
 * @version 1.0
 * @date    2015-12-10
 */

#import <Foundation/Foundation.h>

@class MPWebSocketManagerBroadcaster;

///the protocol of MPWebSocketManager.
@protocol MPWebSocketManagerDelegate <NSObject>

@required
/**
 *  @brief did receive message.
 *
 *  @param message.
 *
 *  @return void nil.
 */
-(void) didReceiveMessage:(id)message;
/**
 *  @brief did close connection.
 *
 *  @param closeCode The closeCode is SRStatusCode.
 *  @param bNormally The bNormally is analyzing close normally or not.
 *
 *  @return void nil.
 */
-(void) didCloseConnectionWithStatus:(NSInteger)closeCode
                            closeNormally:(BOOL)bNormally;
/**
 *  @brief did disconnect with server.
 *
 *  @param error
 *
 *  @return void nil.
 */
-(void) didDisconnectWithServer:(NSError *)error;

@optional
/**
 *  @brief did connect with server.
 *
 *  @return void nil.
 */
-(void) didConnectWithServer;



@end

/// the manager of Web Socket.
@interface MPWebSocketManager : NSObject

/**
 *  @brief Singleton of MPWebSocketManager.
 *
 *  @return instancetype MPWebSocketManager.
 */
+ (instancetype)sharedInstance;

/**
 *  @brief open chat connection for user.
 *
 *  @param memberId
 *  @param sessionId
 *  @param listener The listener is a broad caster
 *
 *  @return void nil.
 */
- (void)openChatConnectionForUser:(NSString *)memberId
                      withSession:(NSString *)sessionId
                         delegate:(MPWebSocketManagerBroadcaster *)listener;
/**
 *  @brief close chat connection.
 *
 *  @return void nil.
 */
- (void)closeChatConnection;
/**
 *  @brief get connect status with server.
 *
 *  @return BOOL.
 */
- (BOOL) isConnected;

@end