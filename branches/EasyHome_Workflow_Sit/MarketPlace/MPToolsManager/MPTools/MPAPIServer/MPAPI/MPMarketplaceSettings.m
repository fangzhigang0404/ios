//
//  MPMarketplaceSettings.m
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/1/16.
//
//

#import "MPMarketplaceSettings.h"

@interface MPMarketplaceSettings()

@property (nonatomic, readwrite) NSString *webSocketURL;
@property (nonatomic, readwrite) NSString *acsDomain;
@property (nonatomic, readwrite) NSString *appDomain;

@property (nonatomic, readwrite) NSString *afc;
@property (nonatomic, readwrite) NSString *appID; //aka software id
@property (nonatomic, readwrite) NSString *mediaIdProject;
@property (nonatomic, readwrite) NSString *mediaIdCase;
@property (nonatomic, readwrite) NSString *deviceType;
@property (nonatomic, readwrite) NSString *deviceId;
@property (nonatomic, readwrite) NSString *messageVersion;

@property (nonatomic, readwrite) BOOL isStaging;
@property (nonatomic, readwrite) BOOL useChinaServer;


@end

@implementation MPMarketplaceSettings

+ (MPMarketplaceSettings *)sharedInstance
{
    static MPMarketplaceSettings *sharedInstance = nil;
    static dispatch_once_t onceToken; // onceToken = 0
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MPMarketplaceSettings alloc] init];
    });
    
    return sharedInstance;
}

-(instancetype) init
{
    self = [super init];
    
    if (self)
    {
        
    }
    
    return self;
}


- (void) initializeMarketplaceWithAFC:(NSString *)afc
                                appID:(NSString *)appID
                       mediaIdProject:(NSString *)mediaIdProject
                          mediaIdCase:(NSString *)mediaIdCase
                            isStaging:(BOOL)isStaging
                       useChinaServer:(BOOL)useChinaServer
{
    self.afc = afc;
    self.appID = appID;
    self.mediaIdProject = mediaIdProject;
    self.mediaIdCase = mediaIdCase;
    self.messageVersion = @"v1";
    self.deviceType = @"IOS";
    self.deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    self.isStaging = isStaging;
    self.useChinaServer = useChinaServer;
    
    if (self.isStaging)
    {
        if (self.useChinaServer)
        {
            self.webSocketURL = @"ws://beta-chat.acgcn.autodesk.com:80/api/v2/connect";
            self.acsDomain = @"http://beta-api.acgcn.autodesk.com/API/v2/";
            self.appDomain = @"";
        }
        else
        {
            self.webSocketURL = @"ws://api.beta.squidplatform.com:80/api/v2/connect";
            self.acsDomain = @"https://beta-api.acg.autodesk.com/api/v2/";
            self.appDomain = @"";
        }
    }
    else
    {
        if (self.useChinaServer)
        {
            self.webSocketURL = @"ws://chat.acgcn.autodesk.com:80/api/v2/connect";
            self.acsDomain = @"http://api.acgcn.autodesk.com/API/v2/";
            self.appDomain = @"";
        }
        else
        {
            self.webSocketURL = @"";
            self.acsDomain = @"";
            self.appDomain = @"";
        }
    }
}


@end
