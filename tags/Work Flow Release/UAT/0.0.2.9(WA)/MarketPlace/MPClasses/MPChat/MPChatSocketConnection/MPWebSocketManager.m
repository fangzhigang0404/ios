/**
 * @file    MPWebSocketManager.m
 * @brief   the manager of Web Socket.
 * @author  Jiao
 * @version 1.0
 * @date    2015-12-10
 */

#import "MPWebSocketManager.h"
#import "SRWebSocket.h"
#import "MPMarketplaceSettings.h"
#import "MPChatTestUser.h"
#import "MPWebSocketManagerBroadcaster.h"

@interface MPWebSocketManager()<SRWebSocketDelegate>
{
    SRWebSocket *_webSocket;
    MPWebSocketManagerBroadcaster *_messageListener;
    double _delayInSeconds;
}

@property (nonatomic, assign) double delayInSeconds;


@end

@implementation MPWebSocketManager

@synthesize delayInSeconds = _delayInSeconds;

#pragma mark - SharedInstance

+ (instancetype)sharedInstance {
    
    static MPWebSocketManager *request = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        request = [[super allocWithZone:NULL]init];
        request.delayInSeconds = 0.5;
    });
    
    return request;
}

///override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [MPWebSocketManager sharedInstance];
}

///override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return [MPWebSocketManager sharedInstance];
}

- (void)closeWebSocket
{
    if (_webSocket)
    {
        _webSocket.delegate = nil;
        [_webSocket close];
        _webSocket = nil;
    }

    _messageListener = nil;
}


#pragma mark - public interface methods

- (void)openChatConnectionForUser:(NSString *)memberId
                      withSession:(NSString *)sessionId
                        delegate:(MPWebSocketManagerBroadcaster *)listener
{
    // 1. close socket incase previously opened
    [self closeWebSocket];
    
    //2. Form web URL for socket connection
    NSString *socketURL = [self getChatServerURLWithMemberId:memberId session:sessionId];
    NSURL *serverURL = [NSURL URLWithString:socketURL];
    
    NSLog(@"*******Websocket Message-- Opening socket connection with URL = %@", serverURL);

    //3. Create Socket Object and set this class as its delegate
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:serverURL]];
    _webSocket.delegate = self;
    
    //4. Set listener object as delegate for websoket manager's delegate
    _messageListener = listener;
    
    
    
    //5. Open Socket for communication
    [_webSocket open];
}


- (void)closeChatConnection
{
    NSInteger code = SRStatusCodeNormal;
    NSLog(@"*******Websocket Message-- Disconnected with server closecode = %ld",(long)code);
    
    [(id<MPWebSocketManagerDelegate>)_messageListener didCloseConnectionWithStatus:code
                                                                     closeNormally:YES];

    [self closeWebSocket];
}


-(BOOL) isConnected
{
    return (_webSocket && (_webSocket.readyState == SR_OPEN));
}


#pragma mark - private method

-(NSString *) getChatServerURLWithMemberId:(NSString *)memberId
                                   session:(NSString *)sessionId
{
    NSMutableString *chatServerURL = [NSMutableString stringWithFormat:@"%@", [MPMarketplaceSettings sharedInstance].webSocketURL];
    
    //assuming session id and memberid received
    assert(sessionId != nil);
    assert(memberId != nil);
    
    // add session and member ids
    [chatServerURL appendFormat:@"?sessionId=%@&memberId=%@",sessionId,memberId];
    
    //add app id
    if ([MPMarketplaceSettings sharedInstance].appID)
        [chatServerURL appendFormat:@"&appId=%@",[MPMarketplaceSettings sharedInstance].appID];
    
    //add device type
    if ([MPMarketplaceSettings sharedInstance].deviceType)
        [chatServerURL appendFormat:@"&deviceType=%@",[MPMarketplaceSettings sharedInstance].deviceType];

    //add device id
    if ([MPMarketplaceSettings sharedInstance].deviceId)
        [chatServerURL appendFormat:@"&deviceId=%@",[MPMarketplaceSettings sharedInstance].deviceId];
    
    //add API version
    if ([MPMarketplaceSettings sharedInstance].messageVersion)
        [chatServerURL appendFormat:@"&messageVersion=%@",[MPMarketplaceSettings sharedInstance].messageVersion];

    return chatServerURL;
}


-(void) retryConnection
{
    //do not do anything if websocket is created eariler
    //case may not hit just safeguard
    if ([self isConnected])
    {
        self.delayInSeconds = 0.5;
        return;
    }

    if (self.delayInSeconds > 30)
        self.delayInSeconds = 0.5;
    
    NSLog(@"socket reconnection will be attempted after %0.2f seconds", self.delayInSeconds);
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

        //do not do anything if websocket is created eariler
        //case may not hit just safeguard
        if ([self isConnected])
        {
            self.delayInSeconds = 0.5;
            return;
        }
        else
        {
            self.delayInSeconds *= 2;

            MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
            
            if (member)
            {
                BOOL bStatus = [member MemberGetLoginStatus];
                
                if (bStatus)
                {
                    [self openChatConnectionForUser:member.acs_member_id
                                                  withSession:member.acs_x_session
                                                     delegate:[[MPWebSocketManagerBroadcaster alloc] init]];
                }
            }

        }
    });
}


#pragma mark - SRWebSocketDelegate methods

// message will either be an NSString if the server is using text
// or NSData if the server is using binary.
- (void)webSocket:(SRWebSocket *)webSocket
didReceiveMessage:(id)message
{
    NSLog(@"*******Websocket Message-- Received message ");//%@",message);
   
    [(id<MPWebSocketManagerDelegate>)_messageListener didReceiveMessage:message];
}


- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"*******Websocket Message-- Connected with server");

    if ([(id<MPWebSocketManagerDelegate>)_messageListener respondsToSelector:@selector(didConnectWithServer)])
        [(id<MPWebSocketManagerDelegate>)_messageListener didConnectWithServer];
}


- (void)webSocket:(SRWebSocket *)webSocket
 didFailWithError:(NSError *)error
{
    NSLog(@"*******Websocket Message-- Failed with server error = %@",error);

    [(id<MPWebSocketManagerDelegate>)_messageListener didDisconnectWithServer:error];
    [self closeWebSocket];
    [self retryConnection];
}


- (void)webSocket:(SRWebSocket *)webSocket
 didCloseWithCode:(NSInteger)code
           reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"*******Websocket Message-- Disconnected with server closecode = %ld",(long)code);

    [(id<MPWebSocketManagerDelegate>)_messageListener didCloseConnectionWithStatus:code
                                                                     closeNormally:wasClean];
    [self closeWebSocket];
    [self retryConnection];
}

@end