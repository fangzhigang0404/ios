
#import "MPChatHttpManager.h"
#import "JSONKit.h"
#import "MPMarketplaceSettings.h"
#import "MPChatThreads.h"
#import "MPChatThread.h"
#import "MPChatMessages.h"
#import "MPChatEntities.h"
#import "MPChatTestUser.h"


@interface MPChatHttpManager()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation MPChatHttpManager

#pragma mark - SharedInstance
+ (instancetype)sharedInstance
{
    static MPChatHttpManager *s_request = nil;
    static dispatch_once_t s_predicate;
    dispatch_once(&s_predicate, ^{
        s_request = [[super allocWithZone:NULL]init];
    });
    
    return s_request;
}


///override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [MPChatHttpManager sharedInstance];
}


///override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return [MPChatHttpManager sharedInstance];
}

- (AFHTTPSessionManager *)manager
{
    if (_manager == nil)
    {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 600;
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"audio/mpeg", @"*/*", nil];
    }
    return _manager;
}


+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                           withHeaderField:(NSDictionary *)header
                                andSuccess:(void (^)(NSData *responseData))success
                                andFailure:(void (^)(NSError* error))failure
{
    NSLog(@"%@_%@_%@",url,parameters,header);
    
    [[MPChatHttpManager sharedInstance] requestMethod:@"Get" withURL:url
                                       withParameters:parameters
                                      withHeaderField:header
                                           andSuccess:^(NSURLSessionDataTask * _Nonnull task, NSData *responseData)
                                            {
                                                 if (success)
                                                     success(responseData);
                                            }
                                           andFailure:^(NSURLSessionDataTask * _Nonnull task, NSError *error)
                                            {
                                                 if (failure)
                                                     failure(error);
                                            }];
}


+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                            withHeaderField:(NSDictionary *)header
                                 andSuccess:(void (^)(NSData *responseData))success
                                 andFailure:(void (^)(NSError* error))failure
{
    [[MPChatHttpManager sharedInstance] requestMethod:@"Post"
                                              withURL:url
                                       withParameters:parameters
                                      withHeaderField:header
                                           andSuccess:^(NSURLSessionDataTask * _Nonnull task, NSData *responseData)
                                             {
                                                 if (success)
                                                     success(responseData);
                                             }
                                           andFailure:^(NSURLSessionDataTask * _Nonnull task, NSError *error)
                                             {
                                                 if (failure)
                                                     failure(error);
                                             }];
}


+ (NSURLSessionDataTask *)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withFiles:(NSArray <NSDictionary *>*)files
                            withHeaderField:(NSDictionary *)header
                                 andSuccess:(void (^)(NSData *responseData))success
                                 andFailure:(void (^)(NSError* error))failure
{
    if (header)
    {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
        {
            if ([@"ENOUGH" isEqualToString:key])
                *stop = YES;

            [[MPChatHttpManager sharedInstance].manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
     return [[MPChatHttpManager sharedInstance].manager
                          POST:url
                    parameters:parameters
     constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
        {
            [files enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
             {

//                 [formData appendPartWithFileURL:obj[@"url"] name:obj[@"name"] error:nil];
                 
                 [formData appendPartWithFileURL:obj[@"filename"] name:obj[@"name"] error:nil];
                 
                 
//                                 [formData appendPartWithFileData:obj[@"data"] name:obj[@"name"] fileName:obj[@"fileName"] mimeType:obj[@"type"]];
                }];
        }
     
                    progress:nil
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
                        {
                          if (success)
                              success(responseObject);
                        }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
                        {
                          if (failure)
                              failure(error);
                        }];
}


+ (void)Put:(NSString *)url  withParameters:(NSDictionary *)parameters
                            withHeaderField:(NSDictionary *)header
                                 andSuccess:(void (^)(NSData *responseData))success
                                 andFailure:(void (^)(NSError* error))failure
{
    [[MPChatHttpManager sharedInstance] requestMethod:@"Put"
                                              withURL:url
                                       withParameters:parameters
                                      withHeaderField:header
                                           andSuccess:^(NSURLSessionDataTask * _Nonnull task, NSData *responseData)
                                             {
                                                 if (success)
                                                     success(responseData);
                                             }
                                           andFailure:^(NSURLSessionDataTask * _Nonnull task, NSError *error)
                                             {
                                                 if (failure)
                                                     failure(error);
                                             }];
}


+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeaderField:(NSDictionary *)header
                                andSuccess:(void (^)(NSData *responseData))success
                                andFailure:(void (^)(NSError* error))failure
{
    [[MPChatHttpManager sharedInstance] requestMethod:@"Delete"
                                              withURL:url
                                       withParameters:parameters
                                      withHeaderField:header
                                           andSuccess:^(NSURLSessionDataTask * _Nonnull task, NSData *responseData)
     {
         if (success)
             success(responseData);
     }
                                           andFailure:^(NSURLSessionDataTask * _Nonnull task, NSError *error)
     {
         if (failure)
             failure(error);
     }];
}



+ (NSURLSessionDownloadTask*)DownloadFile:(NSString *)url
                          withHeaderField:(NSDictionary *)header
                             atTargetPath:(NSURL *)path
                                 progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                  success:(void (^)(NSURL *filePath, id responseObject))success
                                  failure:(void (^)(NSError* error))failure
{
    // populate the headers
    if (header)
    {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
         {
             if ([@"ENOUGH" isEqualToString:key])
                 *stop = YES;
             
             [[MPChatHttpManager sharedInstance].manager.requestSerializer setValue:obj forHTTPHeaderField:key];
         }];
    }
    
    // prepare the request
    NSError *serializationError = nil;
    NSMutableURLRequest *request =
    [[MPChatHttpManager sharedInstance].manager.requestSerializer
                requestWithMethod:@"GET"
                        URLString:[[NSURL URLWithString:url relativeToURL:[MPChatHttpManager sharedInstance].manager.baseURL] absoluteString]
                       parameters:nil
                            error:&serializationError];
    if (serializationError)
    {
        if (failure)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"FAILED: MPChatHttpManager DownloadFile");
                failure(serializationError);
            });
#pragma clang diagnostic pop
        }
    }
    
    __block NSURLSessionDownloadTask *dataTask = nil;
    dataTask =
    [[MPChatHttpManager sharedInstance].manager
            downloadTaskWithRequest:request
                           progress:^(NSProgress * _Nonnull downloadProgress) {
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             if (downloadProgressBlock)
                                                 downloadProgressBlock(downloadProgress);
                                         });
                                        }
                        destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response)
                             {
                                 return path;
                             }
                 completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error)
                     {
                         if (error)
                         {              
                             if (failure)
                             {
                                 NSLog(@"FAILED: MPChatHttpManager DownloadFile");
                                 failure(error);
                             }
                         }
                         else if (success)
                             success(filePath, response);
                     }];
    
    [dataTask resume];
    
    return dataTask;
}


#pragma mark - Public Method
- (void)requestMethod:(NSString*)method withURL:(NSString *)url
       withParameters:(NSDictionary *)parameters
      withHeaderField:(NSDictionary *)header
           andSuccess:(void (^)(NSURLSessionDataTask * _Nonnull task, NSData *responseData))success
           andFailure:(void (^)(NSURLSessionDataTask * _Nonnull task, NSError* error))failure
{
    if (header)
    {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
         {
             if ([@"ENOUGH" isEqualToString:key])
                 *stop = YES;
             
             [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
         }];
    }
    
    if ([@"Get" isEqualToString:method]) {
        
        [self.manager GET:url
               parameters:parameters
                 progress:nil
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (success) {
                          success(task,responseObject);
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failure) {
                          failure(task,error);
                      }
                  }];
    }else if ([@"Post" isEqualToString:method]) {
        
        [self.manager POST:url
                parameters:parameters
                  progress:nil
                   success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                       if (success) {
                           success(task,responseObject);
                       }
                   }
                   failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                       if (failure) {
                           failure(task,error);
                       }
                   }];
    }else if ([@"Put" isEqualToString:method]) {
        
        [self.manager PUT:url
               parameters:parameters
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      if (success) {
                          success(task,responseObject);
                      }
                  }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      if (failure) {
                          failure(task,error);
                      }
                  }];
    }else if ([@"Delete" isEqualToString:method]) {
        
        [self.manager DELETE:url
                  parameters:parameters
                     success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                         if (success) {
                             success(task,responseObject);
                         }
                     }
                     failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                         if (failure) {
                             failure(task,error);
                         }
                     }];
    }
    
    
}

#pragma mark - Custom method

+ (NSDate*) acsDateToNSDate:(NSString*)acsDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    
    NSDate *date = [dateFormat dateFromString:acsDate];
    
    return date;
}


+ (NSString*) nsDateToAcsDate:(NSDate*)acsDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMMM dd, yyyy HH:mm:ss"];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];

    NSString *date = [dateFormat stringFromDate:acsDate];
    return date;
}


- (NSDictionary*) getDefaultHeaders
{
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    NSDictionary* headers = [[NSMutableDictionary alloc] init];
    [headers setValue:[MPMarketplaceSettings sharedInstance].afc forKey:@"X-AFC"];
    [headers setValue:member.acs_x_session forKey:@"X-SESSION"];
    
    return headers;
}

- (NSMutableDictionary*) loadUser1
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:@"20735661" forKey:@"acs_member_id"];
//    [dict setObject:@"E3972923-B0BF-4A81-AA96-6376D2E89868" forKey:@"acs_x_session"];

    [dict setObject:@"20735683" forKey:@"acs_member_id"];
    [dict setObject:@"9BA9B369-6AB0-4007-9842-F52F2F4B3E17" forKey:@"acs_x_session"];

    return dict;
}

- (NSMutableDictionary*) loadUser2
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:@"20735662" forKey:@"acs_member_id"];
//    [dict setObject:@"7F46E314-8A58-4B32-BB94-42840F021F6D" forKey:@"acs_x_session"];
    
    [dict setObject:@"20735684" forKey:@"acs_member_id"];
    [dict setObject:@"DF3EF08E-8692-4EE5-B41B-31EB3C06A5BF" forKey:@"acs_x_session"];

    return dict;
}

- (NSMutableDictionary*) loadUser3
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:@"20735663" forKey:@"acs_member_id"];
//    [dict setObject:@"74EF2CB2-5CC6-4283-9E30-4E9CC941A438" forKey:@"acs_x_session"];

    [dict setObject:@"20735686" forKey:@"acs_member_id"];
    [dict setObject:@"1C4FECF0-9D37-4F84-B5B7-C758745B96F4" forKey:@"acs_x_session"];

    return dict;
}

- (NSMutableDictionary*) loadUser4
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
//    [dict setObject:@"20735664" forKey:@"acs_member_id"];
//    [dict setObject:@"98741DB5-39A0-4A8F-8045-CDEBAE2677BB" forKey:@"acs_x_session"];

    [dict setObject:@"20735687" forKey:@"acs_member_id"];
    [dict setObject:@"0EC03E43-5463-45CC-8C67-572E2D38EA85" forKey:@"acs_x_session"];

    return dict;
}



- (void) doTest
{
//    MPMember* memberInfo=[[MPMember alloc]init];
//    NSMutableDictionary* dict2 = [self loadUser3];
//    [memberInfo SetWithDict:dict2];
//    [AppController AppGlobal_SetLoginStatus:YES];
//    
    
    //    [[MPChatHttpManager sharedInstance] retrieveMemberThreads:[MPChatTestUser sharedInstance].memberId
    //                                           onlyAttachedToFile:NO
    //                                                   withOffset:0
    //                                                     andLimit:20
    //                                                      success:nil
    //                                                      failure:nil];
    //
    //    [[MPChatHttpManager sharedInstance] retrieveThreadMessages:[MPChatTestUser sharedInstance].threadId
    //                                                     forMember:[MPChatTestUser sharedInstance].memberId
    //                                                    withOffset:0
    //                                                      andLimit:20
    //                                                       success:nil
    //                                                       failure:nil];
    
    //    [[MPChatHttpManager sharedInstance] replyToThread:TEST_USER1_THREAD1
    //                                             byMember:TEST_USER1_MEMBERID
    //                                             withText:@"Hey Man, You like this?"
    //                                              success:nil
    //                                              failure:nil];
    
    //    [[MPChatHttpManager sharedInstance] retrieveFileConversations:[MPChatTestUser sharedInstance].fileId
    //                                                          success:nil
    //                                                          failure:nil];
    
    
    //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    NSString *documentsDirectory = [paths objectAtIndex:0];
    //    NSString *fileName = @"default.png";
    //    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    //    NSURL *temp = [[NSURL alloc] initFileURLWithPath:filePath];
    //
    //        [[MPChatHttpManager sharedInstance] downloadFile:[MPChatTestUser sharedInstance].fileId
    //                                            atTargetPath:temp
    //                                                progress:^(NSProgress *downloadProgress)
    //                                                {
    //                                                        NSLog(@"InProgress");
    //                                                }
    //                                                 success:^(NSURL* filePath, id responseObject)
    //                                                {
    //                                                    NSLog(@"Success");
    //
    //                                                    [[MPChatHttpManager sharedInstance]
    //                                                      sendMediaMessage:[MPChatTestUser sharedInstance].memberId
    //                                                             toRecipient:@"20730110"
    //                                                                 subject:@"subject"
    //                                                      orInExistingThread:nil
    //                                                                withFile:filePath
    //                                                           mediaFileType:@"IMAGE"
    //                                                                 success:^(NSString *threadId)
    //                                                    {
    //                                                                     NSLog(@"Success");
    //
    //                                                    } failure:^(NSError *error) {
    //
    //                                                                     NSLog(@"Failure");
    //                                                    }];
    //
    ////                                                    [[MPChatHttpManager sharedInstance] uploadFile:filePath andSuccess:^(NSString *fileId) {
    ////                                                        NSLog(@"This is success");
    ////                                                    } andFailure:^(NSError *error) {
    ////                                                        NSLog(@"This is failure");
    ////                                                    }];
    //
    //                                                }
    //                                                 failure:^(NSError* error)
    //                                                {
    //                                                    NSLog(@"failure");
    //                                                }];
    //
    
//            [[MPChatHttpManager sharedInstance] sendNewThreadMessage:@"20735686"
//                                                         toRecipient:@"20735687"
//                                                         messageText:@"uiop 4"
//                                                             subject:@"Great house in HK"
//                                                             success:^(NSString *threadId)
//                                                            {
//                                                                NSLog(@"success ");
//                                                            }
//                                                     failure: ^(NSError* error)
//                                                              {
//                                                                  NSLog(@"failure");
//                                                              }];
//    
    //    [[MPChatHttpManager sharedInstance] addConversationToFile:@"17957793" withThread:@"TBLJR1TIKL49LMI" withXCoordinate:[NSNumber numberWithInt:30]withYCoordinate:[NSNumber numberWithInt:30] success:^(NSString * success) {
    //        NSLog(@"Success");
    //    } failure:^(NSError *error) {
    //         NSLog(@"Failure");
    //    }];
    
//    [[MPChatHttpManager sharedInstance] retrieveMemberUnreadMessageCount:@"20730109" needAllMessages:NO success:nil failure:nil];
}

- (void) retrieveMultipleMemberThreads:(NSArray*)recipient_ids
                              withOffset:(NSInteger)offset
                              andLimit:(NSInteger)limit
                               success:(void(^)(MPChatThreads* threads))success
                               failure:(void(^)(NSError *error))failure
{
    
    NSAssert(recipient_ids.count > 0, @"recipient_ids must be greater than 0");
    
    NSString* members=@"";
    
    for(int i=0;i<recipient_ids.count;i++)
        members=[NSString stringWithFormat:@"%@%@%@",members,recipient_ids[i],(recipient_ids.count==(i+1))?(@""):(@",")];
    
    
    NSString *entityTypes = @"NONE";
    
    NSString *url = [NSString stringWithFormat:@"%@members/threads?recipient_ids=%@&latest_message_info=true&sort_order=desc&offset=%ld&limit=%ld&entity_info=true&entity_types=%@", [MPMarketplaceSettings sharedInstance].acsDomain, members, offset, limit, entityTypes];
    NSLog(@"%@",url);
    [MPChatHttpManager Get:url
            withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
     {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         NSLog(@"%@",dict);
         MPChatThreads* threads = [MPChatThreads fromFoundationObj:dict];
         
         if (success)
             success(threads);
     }
                andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveMultipleMemberThreads");
             failure(error);
         }
     }];
}


// this is currently ignoring fileOnly
- (void) retrieveMemberThreads:(NSString*)memberId
            onlyAttachedToFile:(BOOL)fileOnly
                    withOffset:(NSInteger)offset
                      andLimit:(NSInteger)limit
                       success:(void(^)(MPChatThreads* threads))success
                       failure:(void(^)(NSError *error))failure
{
    NSAssert(memberId != nil, @"member id must be passed");
    
    NSString *entityTypes = @"ASSET,NONE";
    
    if (fileOnly)
        entityTypes = @"FILE";
    
    NSString *url = [NSString stringWithFormat:@"%@members/%@/threads?mailbox=CHAT&latest_message_info=true&sort_order=recent&offset=%ld&limit=%ld&entity_info=true&entity_types=%@", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, offset, limit, entityTypes];
    
    [MPChatHttpManager Get:url
               withParameters:nil
              withHeaderField:[self getDefaultHeaders]
                   andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         MPChatThreads* threads = [MPChatThreads fromFoundationObj:dict];
         
         if (success)
             success(threads);
     }
                   andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveMemberThreads");
             failure(error);
         }
     }];
}

- (void) retrieveThreadMessages:(NSString*)threadId
                      forMember:(NSString*)memberId
                     withOffset:(NSInteger)offset
                       andLimit:(NSInteger)limit
                        success:(void(^)(MPChatMessages*))success
                        failure:(void(^)(NSError* error))failure
{
    NSAssert(threadId != nil, @"thread id must be passed");
    NSAssert(memberId != nil, @"member id must be passed");
    
    NSString *url = [NSString stringWithFormat:@"%@members/%@/messages/%@?mailbox=IN&sort_order=desc&offset=%ld&limit=%ld", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, threadId, offset, limit];
    
    [MPChatHttpManager Get:url
               withParameters:nil
              withHeaderField:[self getDefaultHeaders]
                   andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         MPChatMessages* msgs = [MPChatMessages fromFoundationObj:dict];
         
         if (success)
             success(msgs);
     }
                   andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveThreadMessages");
             failure(error);
         }
     }];
    
}


- (void) retrieveMemberUnreadMessageCount:(NSString*)memberId
                          needAllMessages:(BOOL)needAll //if false will send only file based
                                  success:(void(^)(NSInteger))success
                                  failure:(void(^)(NSError* error))failure
{
    NSAssert(memberId != nil, @"memberId id must be passed");
    
    NSString* entityTypes = @"FILE";
    
    if (needAll)
        entityTypes = @"NONE,ASSET,FILE,WORKFLOW_STEP";


    NSString *url = [NSString stringWithFormat:@"%@members/%@/messages/counts?mailbox=CHAT&entity_types=%@", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, entityTypes];
    
    [MPChatHttpManager Get:url
            withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         NSInteger count = [[dict valueForKey:@"unread_message_count"] integerValue];
         
         if (success)
             success(count);
     }
                andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveMemberUnreadMessageCount");
             failure(error);
         }
     }];
}


- (void)  retrieveFileUnreadMessageCount:(NSString*)fileId
                               forMember:(NSString*)memberId
                                  success:(void(^)(NSInteger, NSString* fileId))success
                                  failure:(void(^)(NSError* error))failure
{
    NSAssert(fileId != nil, @"fileId id must be passed");
    NSAssert(memberId != nil, @"memberId id must be passed");
    
    NSString* entityTypes = @"FILE";
    
    NSString *url = [NSString stringWithFormat:@"%@members/%@/messages/counts?mailbox=CHAT&entity_types=%@&entity_ids=%@", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, entityTypes, fileId];
    
    [MPChatHttpManager Get:url
            withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         NSInteger count = [[dict valueForKey:@"unread_message_count"] integerValue];
         
         if (success)
             success(count, fileId);
     }
                andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveFileUnreadMessageCount");
             failure(error);
         }
     }];
}


- (void) retrieveAllHotspotUnreadmessageCount:(NSString*)memberId
                                  forThreadId:(NSString*)threadId
                                      success:(void(^)(NSInteger))success
                                      failure:(void(^)(NSError* error))failure
{
    NSAssert(memberId != nil, @"memberId id must be passed");
    NSAssert(threadId != nil, @"threadId id must be passed");
    
    NSString *url = [NSString stringWithFormat:@"%@members/%@/messages/%@/media/counts", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, threadId];
    
    [MPChatHttpManager Get:url
            withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         NSInteger count = [[dict valueForKey:@"unread_message_count"] integerValue];
         
         if (success)
             success(count);
     }
                andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveAllHotspotUnreadmessageCount");
             failure(error);
         }
     }];
}


- (void)  retrieveMediaMessages:(NSString*)threadId
                      forMember:(NSString*)memberId
                     withOffset:(NSInteger)offset
                       andLimit:(NSInteger)limit
                        success:(void(^)(MPChatMessages*))success
                        failure:(void(^)(NSError* error))failure
{
    NSAssert(threadId != nil, @"threadId id must be passed");
    NSAssert(memberId != nil, @"memberId id must be passed");
    
    NSString *url = [NSString stringWithFormat:@"%@members/%@/messages/media?sort_order=desc&offset=%ld&limit=%ld&message_media_types=IMAGE&thread_ids=%@", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, offset, limit, threadId];
    
    [MPChatHttpManager Get:url
            withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         MPChatMessages* msgs = [MPChatMessages fromFoundationObj:dict];
         
         if (success)
             success(msgs);
     }
                andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveMediaMessages");
             failure(error);
         }
     }];
    
}


- (void) retrieveThreadDetails:(NSString*)threadId
                     forMember:(NSString*)memberId
                       success:(void(^)(MPChatThread*))success
                       failure:(void(^)(NSError* error))failure
{
    NSAssert(threadId != nil, @"threadId id must be passed");
    NSAssert(memberId != nil, @"memberId id must be passed");

    NSString *url = [NSString stringWithFormat:@"%@members/%@/threads/%@?latest_message_info=true&entity_info=true", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, threadId];
    
    [MPChatHttpManager Get:url
            withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         MPChatThread* thread = [MPChatThread fromFoundationObj:dict];
         
         if (success)
             success(thread);
     }
                andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveThreadDetails");
             failure(error);
         }
     }];

}


- (void) sendNewThreadMessage:(NSString*)byMemberId
                  toRecipient:(NSString*)recipient
                  messageText:(NSString*)text
                      subject:(NSString*)subject
                      success:(void (^)(NSString *threadId))success
                      failure:(void (^)(NSError* error))failure
{
    NSAssert(byMemberId != nil, @"byMemberId id must be passed");
    NSAssert(byMemberId != recipient, @"member and reciepent must be different");
    NSAssert(text != nil , @"text must be provided");
    NSAssert(subject != nil, @"subject must be provided");
    
    NSString *url = [NSString stringWithFormat:@"%@members/%@/messages", [MPMarketplaceSettings sharedInstance].acsDomain, byMemberId];
    //-----
    NSString *recipients = [NSString stringWithFormat:@"%@,%@",recipient,ADMIN_USER_ID];
    //-----
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:text forKey:@"body"];
    [params setValue:subject forKey:@"subject"];
    [params setValue:recipients forKey:@"recipient_ids"];
    [params setValue:@"CHAT" forKey:@"mailbox"];
    [params setValue:[MPMarketplaceSettings sharedInstance].appID forKey:@"app_id"];
    
    NSLog(@"%@%@",url,params);
    
    [MPChatHttpManager Post:url
                withParameters:params
               withHeaderField:[self getDefaultHeaders]
                    andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         NSString *thread_id = [dict objectForKey:@"thread_id"];
         NSLog(@"This is success");
         success(thread_id);
     }
                    andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager retrieveThreadDetails %@",error);
             failure(error);
         }
     }];
}


- (void) sendMediaMessage:(NSString*)byMemberId
              toRecipient:(NSString*)recipient
                  subject:(NSString*)subject
       orInExistingThread:(NSString*)threadId
                 withFile:(NSURL*)filePath
            mediaFileType:(NSString*)type //AUDIO or IMAGE
                  success:(void (^)(NSString *threadId, NSString *fileId))success
                  failure:(void (^)(NSError* error))failure
{
    NSAssert(byMemberId != recipient, @"member and reciepent must be different");
    NSAssert(filePath != nil, @"filePath must be passed");
    
    [self getUploadServer:^(NSString *server)
     {
         NSString *urlString = [NSString stringWithFormat:@"http://%@/api/v2/members/%@/chat/media", server, byMemberId];
         
         NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
         
         if (threadId)
         {
             [params setObject:threadId forKey:@"thread_id"];
         }
         else if (recipient)
         {
             NSAssert(subject != nil, @"subject is missing");
             
             [params setValue:[NSNumber numberWithInteger:[recipient integerValue]] forKey:@"recipient_ids"];
             [params setValue:subject forKey:@"subject"];
             [params setValue:[MPMarketplaceSettings sharedInstance].appID forKey:@"app_id"];
         }
         
         [params setObject:type forKey:@"content_type"];
         
         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
         [dict setObject:filePath forKey:@"filename"];
         [dict setObject:@"file" forKey:@"name"];
         
         __block NSURLSessionDataTask *uploadTask = [MPChatHttpManager Post:urlString
                     withParameters:params
                          withFiles:[NSArray arrayWithObject:dict]
                    withHeaderField:[self getDefaultHeaders]
                         andSuccess:^(NSData *responseData)
          {
              NSDictionary *dict =
              [NSJSONSerialization JSONObjectWithData:responseData
                                              options:0
                                                error:nil];
              NSString *thread_id = [dict objectForKey:@"thread_id"];
              NSString *file_id = [dict objectForKey:@"file_id"];
              NSLog(@"sendMediaMessage This is success");
              success(thread_id, file_id);
          }
          andFailure:^(NSError *error)
          {
              [uploadTask cancel];
              if (failure)
              {
                  NSLog(@"FAILED: MPChatHttpManager sendMediaMessage,%@",error.debugDescription);
                  failure(error);
              }
          }];
     }
                  failure:^(NSError *error) {
                      if (failure)
                      {
                          NSLog(@"FAILED: MPChatHttpManager getUploadServer");
                          failure(error);
                      }
                  }];
}


- (void) replyToThread:(NSString*)threadId
              byMember:(NSString*)memberId
              withText:(NSString*)msgText
               success:(void(^)(NSString*))success
               failure:(void(^)(NSError* error))failure
{
    NSAssert(threadId != nil, @"threadId is missing");
    NSAssert(memberId != nil, @"memberId is missing");
    
    NSString *url = [NSString stringWithFormat:@"%@members/%@/messages/reply", [MPMarketplaceSettings sharedInstance].acsDomain, memberId];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:msgText forKey:@"body"];
    [params setValue:threadId forKey:@"thread_id"];
    [params setValue:[MPMarketplaceSettings sharedInstance].appID forKey:@"app_id"];
    
    
    [MPChatHttpManager Post:url
                withParameters:params
               withHeaderField:[self getDefaultHeaders]
                    andSuccess:^(NSData *responseData)
     {
         if (success)
             success(@"Success");
     }
                    andFailure:^(NSError *error)
     {
         if (failure)
         {
             NSLog(@"FAILED: MPChatHttpManager replyToThread");
             failure(error);
         }
     }];
}


- (void) markThreadAsRead:(NSString*)threadId
                 byMember:(NSString*)memberId
                  success:(void(^)(NSString*))success
                  failure:(void(^)(NSError* error))failure
{
    NSAssert(threadId != nil, @"threadId is missing");
    NSAssert(memberId != nil, @"memberId is missing");
    
     NSString *url = [NSString stringWithFormat:@"%@members/%@/messages?action=read&thread_id=%@", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, threadId];
    
    [MPChatHttpManager Put:url withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
                {
                    if (success)
                        success(@"Success");
                }
                andFailure:^(NSError *error)
                {
                    NSLog(@"FAILED: MPChatHttpManager markThreadAsRead");
                    
                    if (failure)
                        failure(error);
                }];
}


- (void) markMessageAsRead:(NSString*)msgId
                  byMember:(NSString*)memberId
                   success:(void(^)(NSString*))success
                   failure:(void(^)(NSError* error))failure
{
    NSAssert(msgId != nil, @"msgId is missing");
    NSAssert(memberId != nil, @"memberId is missing");

    NSString *url = [NSString stringWithFormat:@"%@members/%@/messages?action=read&message_id=%@", [MPMarketplaceSettings sharedInstance].acsDomain, memberId, msgId];
    
    [MPChatHttpManager Put:url withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
     {
         if (success)
             success(@"Success");
     }
                andFailure:^(NSError *error)
     {
         NSLog(@"FAILED: MPChatHttpManager markMessageAsRead");
         if (failure)
             failure(error);
     }];

}


- (void) retrieveFileConversations:(NSString*)fileId
                           success:(void(^)(MPChatEntities*))success
                           failure:(void(^)(NSError* error))failure
{
    NSAssert(fileId != nil, @"fileId is missing");
    
    NSString *url = [NSString stringWithFormat:@"%@entity/conversations?entity_types=FILE&entity_ids=%@&thread_info=true", [MPMarketplaceSettings sharedInstance].acsDomain, fileId];
    
    [MPChatHttpManager Get:url
               withParameters:nil
              withHeaderField:[self getDefaultHeaders]
                   andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         NSArray* array = [dict objectForKey:@"entity"];
         MPChatEntities* entities = [MPChatEntities fromFoundationObj:array];
         
         if (success)
             success(entities);
         
     }
                   andFailure:^(NSError *error)
     {
         NSLog(@"FAILED: MPChatHttpManager retrieveFileConversations");
     }];
}


- (void) addConversationToFile:(NSString*)fileId
                    withThread:(NSString*)threadId
               withXCoordinate:(NSNumber*)xValue
               withYCoordinate:(NSNumber*)yValue
                       success:(void(^)(NSString*))success
                       failure:(void(^)(NSError* error))failure
{
    NSAssert(fileId != nil, @"fileId is missing");
    NSAssert(threadId != nil, @"threadId is missing");
    
    NSString *url = [NSString stringWithFormat:@"%@entity/%@/conversations", [MPMarketplaceSettings sharedInstance].acsDomain, fileId];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:threadId forKey:@"thread_id"];
    [params setValue:@"FILE" forKey:@"entity_type"];
    [params setValue:xValue forKey:@"x_coordinate"];
    [params setValue:yValue forKey:@"y_coordinate"];
    [params setValue:[NSNumber numberWithInt:0] forKey:@"z_coordinate"];
    
    [MPChatHttpManager Post:url
                withParameters:params
               withHeaderField:[self getDefaultHeaders]
                    andSuccess:^(NSData *responseData)
     {
         if (success)
             success(@"success");
     }
                    andFailure:^(NSError *error)
     {
         NSLog(@"FAILED: MPChatHttpManager addConversationToFile");
         if (failure)
             failure(error);
     }];
    
}

- (void) addFileToWorkflowStep:(NSString*)fileId
                     onAssetId:(NSString*)assetId
                    workflowId:(NSString*)workflowId
                workflowStepId:(NSString*)workflowStepId
                       success:(void(^)(NSString*))success
                       failure:(void(^)(NSError* error))failure
{
    NSAssert(fileId != nil, @"fileId is missing");
    NSAssert(assetId != nil, @"assetId is missing");
    NSAssert(workflowId != nil, @"workflowId is missing");
    NSAssert(workflowStepId != nil, @"workflowStepId is missing");
    
    
    NSString *url = [NSString stringWithFormat:@"%@assets/%@/workflows/%@/steps/%@?file_ids=%@", [MPMarketplaceSettings sharedInstance].acsDomain, assetId, workflowId, workflowStepId, fileId];
    
    [MPChatHttpManager Put:url withParameters:nil withHeaderField:[self getDefaultHeaders]
                 andSuccess:^(NSData *responseData)
     {
         id obj = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];

         if (success)
         {
             success ([obj description]);
             NSLog(@"success");
         }
     }
                 andFailure:^(NSError *error)
     {
         NSLog(@"%@",[[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:4]);
         NSLog(@"FAILED: MPChatHttpManager addFileToWorkflowStep");
         if (failure)
             failure(error);
     }];
}


- (void) addFileToAsset:(NSString*)fileId
              onAssetId:(NSString*)assetId
                success:(void(^)(NSString*))success
                failure:(void(^)(NSError* error))failure
{
    NSAssert(fileId != nil, @"fileId is missing");
    NSAssert(assetId != nil, @"assetId is missing");
    
    NSString *url = [NSString stringWithFormat:@"%@assets/%@/sources?file_ids=%@", [MPMarketplaceSettings sharedInstance].acsDomain, assetId, fileId];
    
    [MPChatHttpManager Post:url withParameters:nil withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData)
     {
         id obj = [NSJSONSerialization JSONObjectWithData:responseData
                                                  options:0
                                                    error:nil];
         
         if (success)
         {
             success ([obj description]);
             NSLog(@"success");
         }
     }
                andFailure:^(NSError *error)
     {
         NSLog(@"%@",[[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:4]);
         NSLog(@"FAILED: MPChatHttpManager addFileToWorkflowStep");
         if (failure)
             failure(error);
     }];
}


- (void) getDownloadServer:(void(^)(NSString*))success
                   failure:(void(^)(NSError* error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@server/download", [MPMarketplaceSettings sharedInstance].acsDomain];
    
    [MPChatHttpManager Get:url
               withParameters:nil
              withHeaderField:[self getDefaultHeaders]
                   andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         NSString* server = [dict objectForKey:@"server"];
         
         if (success)
             success(server);
     }
                   andFailure:^(NSError *error)
     {
         NSLog(@"FAILED: MPChatHttpManager getDownloadServer");
     }];
}


- (void) downloadFile:(NSString *)fileId
         atTargetPath:(NSURL *)path
             progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
              success:(void (^)(NSURL *file, id responseObject))success
              failure:(void (^)(NSError* error))failure
{
    NSAssert(fileId != nil, @"fileId is missing");
    //NSAssert(![[NSFileManager defaultManager] fileExistsAtPath:path.path], @"File already exist at path: %@", path.path);
    
    [self getDownloadServer:^(NSString * server)
     {
         NSString *urlString = [NSString stringWithFormat:@"http://%@/api/v2/files/download?file_ids=%@",server, fileId];

         NSDictionary* headers = [self getDefaultHeaders];
         //[headers setValue:[MPMarketplaceSettings sharedInstance].afc forKey:@"X-AFC"];
         //[headers setValue:@"7A7CFD00-CA02-444D-8E72-EC2640AA323E" forKey:@"X-SESSION"];

         [MPChatHttpManager DownloadFile:urlString
                            withHeaderField:headers
                               atTargetPath:path
                                   progress:downloadProgressBlock
                                    success:success
                                    failure:failure];
     }
                    failure:^(NSError *error) {
                        NSLog(@"FAILED: MPChatHttpManager downloadFile");
                        if (failure) {
                            failure (error);
                        }
                    }];
}


- (NSURLSessionDownloadTask*) downloadFileFromURL:(NSString *)urlString
                                     atTargetPath:(NSURL *)path
                                         progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                          success:(void (^)(NSURL* file, id responseObject))success
                                          failure:(void (^)(NSError* error))failure
{
         return [MPChatHttpManager DownloadFile:urlString
                         withHeaderField:nil
                            atTargetPath:path
                                progress:downloadProgressBlock
                                 success:success
                                 failure:failure];
}


- (void) getUploadServer:(void(^)(NSString*))success
                 failure:(void(^)(NSError* error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@server/upload", [MPMarketplaceSettings sharedInstance].acsDomain];
    
    [MPChatHttpManager Get:url
               withParameters:nil
              withHeaderField:[self getDefaultHeaders]
                   andSuccess:^(NSData *responseData)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                              options:0
                                                                error:nil];
         NSString* server = [dict objectForKey:@"server"];
         
         if (success)
             success(server);
     }
                   andFailure:^(NSError *error)
     {
         if (failure)
             failure(error);
         NSLog(@"FAILED: MPChatHttpManager getUploadServer");
     }];
}


- (void) uploadFile:(NSURL*)filePath
         andSuccess:(void (^)(NSString* fileId))success
         andFailure:(void (^)(NSError* error))failure
{
    NSAssert(filePath != nil, @"filePath is missing");
    
    [self getUploadServer:^(NSString* server)
     {
         NSString *urlString = [NSString stringWithFormat:@"http://%@/api/v2/files/upload?", server];
         
         NSMutableDictionary *dict = [NSMutableDictionary dictionary];
         [dict setObject:filePath forKey:@"url"];
         [dict setObject:@"File" forKey:@"name"];
         
         [MPChatHttpManager Post:urlString
                     withParameters:nil
                          withFiles:[NSArray arrayWithObject:dict]
                    withHeaderField:[self getDefaultHeaders]
                         andSuccess:^(NSData *responseData)
          {
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                   options:0
                                                                     error:nil];
              
              NSString *fileId = [dict objectForKey:@"file_id"];
              
              if (success)
                  success(fileId);
          }
                         andFailure:^(NSError *error)
          {
              NSLog(@"FAILED: MPChatHttpManager uploadFile");
              if (failure)
                  failure(error);
          }];
     }
     
                  failure:^(NSError* error)
     {
         if (failure)
             failure(error);
     }];
}


#pragma mark - push notifications related APIs for register/unregister devices

- (void) registerDeviceForPushNotifications:(NSString *)deviceToken
                                    success:(void(^)(BOOL))success
                                    failure:(void(^)(NSError* error))failure;
{
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@devices?", [MPMarketplaceSettings sharedInstance].acsDomain];
    [url appendFormat:@"app_id=%@&", [MPMarketplaceSettings sharedInstance].appID];
    [url appendFormat:@"device_id=%@&", deviceToken];
    [url appendString:@"device_type=2&"]; //2 is for ios device
    [url appendFormat:@"message_version=%@", [MPMarketplaceSettings sharedInstance].messageVersion];

    NSLog(@"url for registering device = %@", url);
   
    [MPChatHttpManager Put:url withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData) {
                    
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:0
                                                                           error:nil];
                    
                    if (dict)
                    {
                        NSNumber *value = [dict objectForKey:@"registered"];
                        
                        // full_notification_registration key also there
                        // i think it does not matter as chatting will work only
                        // if user is logged in
                        // incase of push notification on logout, we will unregister it
                        // and this will be fine 
                        if (success)
                            success(value.boolValue);
                    }

    } andFailure:^(NSError *error) {
        
        NSLog(@"FAILED: MPChatHttpManager registerDeviceForPushNotifications");
        
        if (failure)
            failure(error);
    }];
}


- (void) unRegisterDeviceForPushNotifications:(NSString *)deviceToken
                                    success:(void(^)(BOOL))success
                                    failure:(void(^)(NSError* error))failure;
{
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@devices?", [MPMarketplaceSettings sharedInstance].acsDomain];
    [url appendFormat:@"app_id=%@&", [MPMarketplaceSettings sharedInstance].appID];
    [url appendFormat:@"device_id=%@", deviceToken];
    
    NSLog(@"url for unregistering device = %@", url);
    
    [MPChatHttpManager Delete:url withParameters:nil
           withHeaderField:[self getDefaultHeaders]
                andSuccess:^(NSData *responseData) {
                    
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                                         options:0
                                                                           error:nil];
                    
                    if (dict)
                    {
                        NSNumber *value = [dict objectForKey:@"registered"];
                        
                        if (success)
                            success(value.boolValue);
                    }
                    
                } andFailure:^(NSError *error) {
                    
                    NSLog(@"FAILED: MPChatHttpManager registerDeviceForPushNotifications");
                    
                    if (failure)
                        failure(error);
                }];
}


@end
