//
//  MPMarketplaceSettings.h
//  MarketPlace
//
//  Created by Nilesh Kuber on 2/1/16.
//
//

#import <Foundation/Foundation.h>

@interface MPMarketplaceSettings : NSObject


@property (nonatomic, readonly) NSString *webSocketURL;
@property (nonatomic, readonly) NSString *acsDomain;
@property (nonatomic, readonly) NSString *appDomain;

@property (nonatomic, readonly) NSString *afc;
@property (nonatomic, readonly) NSString *appID; //aka software id
@property (nonatomic, readonly) NSString *mediaIdProject;
@property (nonatomic, readonly) NSString *mediaIdCase;
@property (nonatomic, readonly) NSString *deviceType;
@property (nonatomic, readonly) NSString *deviceId;
@property (nonatomic, readonly) NSString *messageVersion;

@property (nonatomic, readonly) BOOL isStaging;
@property (nonatomic, readonly) BOOL useChinaServer;


+ (MPMarketplaceSettings *)sharedInstance;

- (void) initializeMarketplaceWithAFC:(NSString *)afc
                                appID:(NSString *)appID
                       mediaIdProject:(NSString *)mediaIdProject
                          mediaIdCase:(NSString *)mediaIdCase
                            isStaging:(BOOL)isStaging
                       useChinaServer:(BOOL)useChinaServer;



@end
