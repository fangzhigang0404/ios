/**
 * @file    MPHttpRequestManager.m
 * @brief   the manager of HTTP request.
 * @author  Jiao
 * @version 1.0
 * @date    2016-02-03
 *
 */

#import "MPHttpRequestManager.h"
#import "AFNetworking.h"
#import "MPRequestTool.h"

@interface MPHttpRequestManager()

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end
@implementation MPHttpRequestManager

#pragma mark -SharedInstance
+ (instancetype)sharedInstance {
    
    static MPHttpRequestManager *s_manager = nil;
    static dispatch_once_t s_predicate;
    dispatch_once(&s_predicate, ^{
        s_manager = [[super allocWithZone:NULL]init];
    });
    
    return s_manager;
}

///override the function of allocWithZone:.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    return [MPHttpRequestManager sharedInstance];
}

///override the function of copyWithZone:.
- (instancetype)copyWithZone:(struct _NSZone *)zone {
    
    return [MPHttpRequestManager sharedInstance];
}

#pragma mark -Lazy Loading
- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer.timeoutInterval = 20.0f;
    }
    
    return _manager;
}

#pragma mark - Get

+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                                andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [MPHttpRequestManager Get:url withParameters:parameters withHeader:nil withBody:nil andSuccess:success andFailure:failure];
}

+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [MPHttpRequestManager Get:url withParameters:parameters withHeader:header withBody:nil andSuccess:success andFailure:failure];
}

+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withBody:(NSDictionary *)body
                                andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [MPHttpRequestManager Get:url withParameters:parameters withHeader:nil withBody:body andSuccess:success andFailure:failure];
}

+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                  withBody:(NSDictionary *)body
                                andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSMutableString *newURL = [NSMutableString stringWithString:url];
    NSDictionary *newParameters;
    
    if (parameters) {
        [newURL appendString:@"?"];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([@"ENOUGH" isEqualToString:key]) {
                *stop = YES;
            }
            [newURL appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }];
        newURL = [NSMutableString stringWithString:[newURL substringToIndex:newURL.length - 1]];
    }
    
    if (body) {
        
        newParameters = body;
    }
    
    NSLog(@"\nurl-----%@\nbody-----%@\nheader-----%@\n",newURL, newParameters, header);
    
    [[MPHttpRequestManager sharedInstance] requestMethod:@"Get" withURL:newURL withParameters:newParameters withHeaderField:header withProgress:nil andSuccess:success andFailure:failure];
   
}

#pragma mark - Post
+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                 andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                 andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [MPHttpRequestManager Post:url withParameters:parameters withHeader:nil withBody:nil andSuccess:success andFailure:failure];
}

+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                 withHeader:(NSDictionary *)header
                                 andSuccess:(void (^)(NSURLSessionDataTask *, NSData *responseData))success
                                 andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [MPHttpRequestManager Post:url withParameters:parameters withHeader:header withBody:nil andSuccess:success andFailure:failure];
}

+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                   withBody:(NSDictionary *)body
                                 andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                 andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [MPHttpRequestManager Post:url withParameters:parameters withHeader:nil withBody:body andSuccess:success andFailure:failure];
}

+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                 withHeader:(NSDictionary *)header
                                   withBody:(NSDictionary *)body
                                 andSuccess:(void (^)(NSURLSessionDataTask *, NSData *responseData))success
                                 andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSMutableString *newURL = [NSMutableString stringWithString:url];
    NSDictionary *newParameters;
    
    if (parameters) {
        [newURL appendString:@"?"];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([@"ENOUGH" isEqualToString:key]) {
                *stop = YES;
            }
            [newURL appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }];
        newURL = [NSMutableString stringWithString:[newURL substringToIndex:newURL.length - 1]];
    }
    
    if (body) {
        
        newParameters = body;
    }

    NSLog(@"\nurl-----%@\nbody-----%@\nheader-----%@\n",newURL, newParameters, header);

    [[MPHttpRequestManager sharedInstance] requestMethod:@"Post" withURL:newURL withParameters:newParameters withHeaderField:header withProgress:nil andSuccess:success andFailure:failure];
}

/// upload.
+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withFiles:(NSArray <NSDictionary *>*)files
                                 andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                 andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [MPHttpRequestManager Post:url withParameters:parameters withFiles:files withHeader:nil andSuccess:success andFailure:failure];
}

+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withFiles:(NSArray <NSDictionary *>*)files
                                 withHeader:(NSDictionary *)header
                                 andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                 andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    AFHTTPSessionManager *manager = [MPHttpRequestManager sharedInstance].manager;
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    header = [MPRequestTool addAuthorizationForHeader:header];
    
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([@"ENOUGH" isEqualToString:key]) {
                *stop = YES;
            }
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [files enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [formData appendPartWithFileData:obj[@"data"] name:obj[@"name"] fileName:obj[@"fileName"] mimeType:obj[@"type"]];
        }];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(task, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (![MPRequestTool statueIsOverdue:((NSHTTPURLResponse *)task.response).statusCode]) {
            if (error) {
                if (failure) {
                    failure(task,error);
                }
            }
        }
    }];
}

#pragma mark - Put
+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [MPHttpRequestManager Put:url withParameters:parameters withHeader:nil withBody:nil andSuccess:success andFailure:failure];
}

+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [MPHttpRequestManager Put:url withParameters:parameters withHeader:header withBody:nil andSuccess:success andFailure:failure];
}

+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withBody:(NSDictionary *)body
                                andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    [MPHttpRequestManager Put:url withParameters:parameters withHeader:nil withBody:body andSuccess:success andFailure:failure];
}

+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                  withBody:(NSDictionary *)body
                                andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSMutableString *newURL = [NSMutableString stringWithString:url];
    NSDictionary *newParameters;
    
    if (parameters) {
        [newURL appendString:@"?"];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([@"ENOUGH" isEqualToString:key]) {
                *stop = YES;
            }
            [newURL appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }];
        newURL = [NSMutableString stringWithString:[newURL substringToIndex:newURL.length - 1]];
    }
    
    if (body) {
        
        newParameters = body;
    }
    
    NSLog(@"\nurl-----%@\nbody-----%@\nheader-----%@\n",newURL, newParameters, header);
    
    [[MPHttpRequestManager sharedInstance] requestMethod:@"Put" withURL:newURL withParameters:newParameters withHeaderField:header withProgress:nil andSuccess:success andFailure:failure];
}

+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                 withFiles:(NSArray <NSDictionary *>*)files
                                andSuccess:(void (^)(NSURLResponse *, NSData *))success
                                andFailure:(void (^)(NSError *))failure {
    
    header = [MPRequestTool addAuthorizationForHeader:header];

    if (header)
    {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
         {
             if ([@"ENOUGH" isEqualToString:key])
                 *stop = YES;
             
             [[MPHttpRequestManager sharedInstance].manager.requestSerializer setValue:obj forHTTPHeaderField:key];
         }];
    }
    
    // prepare the request
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [[MPHttpRequestManager sharedInstance].manager.requestSerializer multipartFormRequestWithMethod:@"PUT" URLString:[[NSURL URLWithString:url relativeToURL:[MPHttpRequestManager sharedInstance].manager.baseURL] absoluteString] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [files enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [formData appendPartWithFileData:obj[@"data"] name:obj[@"name"] fileName:obj[@"fileName"] mimeType:obj[@"type"]];
        }];
        
    } error:&serializationError];
//    NSMutableURLRequest *request = [
//                                    requestWithMethod:@"PUT"
//                                    URLString:
//                                    error:&serializationError];
    
    if (serializationError)
    {
        if (failure)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(serializationError);
            });
#pragma clang diagnostic pop
        }
    }
    
    __block NSURLSessionDataTask *task = [[MPHttpRequestManager sharedInstance].manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
        
        if (![MPRequestTool statueIsOverdue:((NSHTTPURLResponse *)response).statusCode]) {
            if (error) {
                if (failure) {
                    failure(error);
                }
            } else {
                if (success) {
                    success(response, responseObject);
                }
            }
        } else {
            NSLog(@"request %@ :401",url);
        }
    }];
    
    [task resume];
}
#pragma mark - Delete
+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                   andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                   andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [MPHttpRequestManager Delete:url withParameters:parameters withHeader:nil withBody:nil andSuccess:success andFailure:failure];
}

+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                   withHeader:(NSDictionary *)header
                                   andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                   andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    [MPHttpRequestManager Delete:url withParameters:parameters withHeader:header withBody:nil andSuccess:success andFailure:failure];
}

+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                     withBody:(NSDictionary *)body
                                   andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                   andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    [MPHttpRequestManager Delete:url withParameters:parameters withHeader:nil withBody:body andSuccess:success andFailure:failure];
}

+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                   withHeader:(NSDictionary *)header
                                     withBody:(NSDictionary *)body
                                   andSuccess:(void (^)(NSURLSessionDataTask *, NSData *))success
                                   andFailure:(void (^)(NSURLSessionDataTask *, NSError *))failure {
    
    NSMutableString *newURL = [NSMutableString stringWithString:url];
    NSDictionary *newParameters;
    
    if (parameters) {
        [newURL appendString:@"?"];
        [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([@"ENOUGH" isEqualToString:key]) {
                *stop = YES;
            }
            [newURL appendString:[NSString stringWithFormat:@"%@=%@&",key,obj]];
        }];
        newURL = [NSMutableString stringWithString:[newURL substringToIndex:newURL.length - 1]];
    }
    
    if (body) {
        
        newParameters = body;
    }
    
    NSLog(@"\nurl-----%@\nbody-----%@\nheader-----%@\n",newURL, newParameters, header);
    
    [[MPHttpRequestManager sharedInstance] requestMethod:@"Delete" withURL:newURL withParameters:newParameters withHeaderField:header withProgress:nil andSuccess:success andFailure:failure];
}

#pragma mark - download
+ (void)DownloadFile:(NSString *)url
     withHeaderField:(NSDictionary *)header
        atTargetPath:(NSURL *)path
            progress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
             success:(void (^)(NSURL *filePath, id responseObject))success
             failure:(void (^)(NSError* error))failure
{
    [MPHttpRequestManager sharedInstance].manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // populate the headers
    header = [MPRequestTool addAuthorizationForHeader:header];
    if (header)
    {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop)
         {
             if ([@"ENOUGH" isEqualToString:key])
                 *stop = YES;
             
             [[MPHttpRequestManager sharedInstance].manager.requestSerializer setValue:obj forHTTPHeaderField:key];
         }];
    }
    
    // prepare the request
    NSError *serializationError = nil;
    NSMutableURLRequest *request =
    [[MPHttpRequestManager sharedInstance].manager.requestSerializer
     requestWithMethod:@"GET"
     URLString:[[NSURL URLWithString:url relativeToURL:[MPHttpRequestManager sharedInstance].manager.baseURL] absoluteString]
     parameters:nil
     error:&serializationError];
    if (serializationError)
    {
        if (failure)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
            dispatch_async(dispatch_get_main_queue(), ^{
                failure(serializationError);
            });
#pragma clang diagnostic pop
        }
    }
    
    __block NSURLSessionDownloadTask *dataTask = nil;
    dataTask =
    [[MPHttpRequestManager sharedInstance].manager
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
         if (![MPRequestTool statueIsOverdue:((NSHTTPURLResponse *)response).statusCode]) {
             if (error)
             {
                 if (failure)
                     failure(error);
             }
             else if (success)
                 success(filePath, response);
         } else {
             NSLog(@"request %@ :401",url);
         }
     }];
    
    [dataTask resume];
}


#pragma mark - Public Method
- (void)requestMethod:(NSString*)method withURL:(NSString *)url
                                 withParameters:(NSDictionary *)parameters
                                withHeaderField:(NSDictionary *)header
                                   withProgress:(void (^)(NSProgress *progress))downloadProgress
                                     andSuccess:(void (^)(NSURLSessionDataTask * task, NSData *responseData))success
                                     andFailure:(void (^)(NSURLSessionDataTask * task, NSError* error))
failure {
    
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"audio/mpeg",@"text/plain", nil];
    
    header = [MPRequestTool addAuthorizationForHeader:header];
    if (header) {
        [header enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([@"ENOUGH" isEqualToString:key]) {
                *stop = YES;
            }
            
            [self.manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }

    if ([@"Get" isEqualToString:method]) { 

        [self.manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success) {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (![MPRequestTool statueIsOverdue:((NSHTTPURLResponse *)task.response).statusCode]) {
                if (failure) {
                    failure(task,error);
                }
            } else {
                NSLog(@"request %@ :401",url);
            }
        }];
    }else if ([@"Post" isEqualToString:method]) {

        [self.manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (![MPRequestTool statueIsOverdue:((NSHTTPURLResponse *)task.response).statusCode]) {
                if (failure) {
                    failure(task,error);
                }
            } else {
                NSLog(@"request %@ :401",url);
            }
        }];
    }else if ([@"Put" isEqualToString:method]) {
        [self.manager PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (![MPRequestTool statueIsOverdue:((NSHTTPURLResponse *)task.response).statusCode]) {
                if (failure) {
                    failure(task,error);
                }
            } else {
                NSLog(@"request %@ :401",url);
            }
        }];
    }else if ([@"Delete" isEqualToString:method]) {
        
        [self.manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success) {
                success(task,responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (![MPRequestTool statueIsOverdue:((NSHTTPURLResponse *)task.response).statusCode]) {
                if (failure) {
                    failure(task,error);
                }
            } else {
                NSLog(@"request %@ :401",url);
            }
        }];
    }
}
@end
