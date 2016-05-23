//
//  MPIncomingMessageListener.m
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/3/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPWebSocketManagerBroadcaster.h"
#import "MPChatMessage.h"

@implementation MPWebSocketManagerBroadcaster

#pragma mark - SharedInstance

#pragma mark- MPWebSocketManagerDelegate methods

-(void) didReceiveMessage:(id)message
{
    NSLog(@"Posting socket notification %@", MPCHATNEWMESSAGENOTIFICATION);
    
    NSError *error;
    id array = [NSJSONSerialization JSONObjectWithData:[message dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
    
    if (array)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:MPCHATNEWMESSAGENOTIFICATION
                                                            object:[MPChatMessage fromFoundationObj:array[0]]];
    }
}


-(void) didCloseConnectionWithStatus:(NSInteger)closeCode
                       closeNormally:(BOOL)bNormally
{
    NSLog(@"Posting socket notification %@", MPCHATCLOSECONNECTIONNOTIFICATION);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MPCHATCLOSECONNECTIONNOTIFICATION
                                                        object:nil];
    
}


-(void) didDisconnectWithServer:(NSError *)error
{
    NSLog(@"Posting socket notification %@", MPCHATDISCONNECTNOTIFICATION);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MPCHATDISCONNECTNOTIFICATION
                                                        object:nil];
    
}


-(void) didConnectWithServer
{
    NSLog(@"Posting socket notification %@", MPCHATCONNECTNOTIFICATION);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MPCHATCONNECTNOTIFICATION
                                                        object:nil];
}



@end
