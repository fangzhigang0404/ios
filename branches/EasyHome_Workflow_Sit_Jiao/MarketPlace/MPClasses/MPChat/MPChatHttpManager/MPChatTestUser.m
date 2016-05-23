//
//  MPChatTestUser.m
//  MarketPlace
//
//  Created by Manish Agrawal on 10/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPChatTestUser.h"
#import "MPMarketplaceSettings.h"

@implementation MPChatTestUser

+ (instancetype)sharedInstance
{
    static MPChatTestUser *s_request = nil;
    static dispatch_once_t s_predicate;
    dispatch_once(&s_predicate, ^{
        s_request = [[super allocWithZone:NULL]init];
        [s_request loadUserChina];
    });
    
    return s_request;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [MPChatTestUser sharedInstance];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return [MPChatTestUser sharedInstance];
}


- (void) loadUser1
{
    if ([MPMarketplaceSettings sharedInstance].useChinaServer)
    {
        self.memberId = @"20730109";
        self.session = @"C150B469-DEA3-40AE-82F3-827B7520BE26";
        self.secureSession = @"678C32398DF243F63C84863F0271285B";
        self.threadId = @"TKLXOS0IK8A39FD";
        self.fileId = /*@"17957539";*/@"17957735";
    }
    else
    {
        self.memberId = @"20704121";
        self.session = @"1E9F81F1-FAF6-4213-8FFB-231498F55ADE";
        self.secureSession = @"AB8A4532F0025872436E42ABCE4E1D72";
    }
}

- (void) loadUser2
{
    if ([MPMarketplaceSettings sharedInstance].useChinaServer)
    {
        self.memberId = @"20730110";
        self.session = @"8F6657D6-DA01-4E20-8F2D-44B445D887E3";
        self.secureSession = @"546DBF34E969201B3AD24D127486BB1D";
    }
    else
    {
        self.memberId = @"20709061";
        self.session = @"E3880D0B-8202-4479-BDF0-5F83095CC2E9";
        self.secureSession = @"CDDE940A9F4BB620C62B99ADCFBC85FE";
    }
}

- (void) loadUserChina {
    self.memberId = [AppController AppGlobal_GetMemberInfoObj].acs_member_id;
    self.session = [AppController AppGlobal_GetMemberInfoObj].acs_x_session;
    NSLog(@"session,%@",self.session);
    self.secureSession = @"CDDE940A9F4BB620C62B99ADCFBC85FE";
}
@end
