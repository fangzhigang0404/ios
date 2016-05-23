/**
 * @file    MPHttpRequestManager.h
 * @brief   the manager of HTTP request.
 * @author  Jiao
 * @version 1.0
 * @date    2016-02-03
 *
 */

#import <Foundation/Foundation.h>

/// the manager of HTTP request.
@interface MPHttpRequestManager : NSObject

/*
 * If you need the header of reponse, you should:
 *  NSDictionary *dict=[NSDictionary dictionaryWithDictionary:[(NSHTTPURLResponse*)task.response allHeaderFields]];
 */

#pragma mark - Get
/**
 *  @brief the method as GET of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *  
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                                andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

/**
 *  @brief the method as GET of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param header the request header.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

/**
 *  @brief the method as GET of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param body the body of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withBody:(NSDictionary *)body
                                andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

/**
 *  @brief the method as GET of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param header the request header.
 *
 *  @param body the body of request.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Get:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                  withBody:(NSDictionary *)body
                                andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

#pragma mark - Post
/**
 *  @brief the method as POST of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                 andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                 andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

/**
 *  @brief the method as POST of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param header the request header.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                 withHeader:(NSDictionary *)header
                                 andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                 andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

/**
 *  @brief the method as POST of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param body the body of request.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                   withBody:(NSDictionary *)body
                                 andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                 andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

/**
 *  @brief the method as POST of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param header the request header.
 *
 *  @param body the body of request.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                 withHeader:(NSDictionary *)header
                                   withBody:(NSDictionary *)body
                                 andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                 andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

/**
 *  @brief upload file.
 *
 *  @param url the url with request.
 *
 *  @param parameters the request parameters.
 *
 *  @param files the array with files(key - @"url": the url of file, @"name": the name of file).
 *
 *  @param success the block if upload successfully.
 *
 *  @param failure the block if upload unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withFiles:(NSArray <NSDictionary *>*)files
                                 andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                 andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

/**
 *  @brief upload file.
 *
 *  @param url the url with request.
 *
 *  @param parameters the request parameters.
 *
 *  @param files the array with files(key - @"url": the url of file, @"name": the name of file).
 *
 *  @param header the request header.
 *
 *  @param success the block if upload successfully.
 *
 *  @param failure the block if upload unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Post:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withFiles:(NSArray <NSDictionary *>*)files
                                 withHeader:(NSDictionary *)header
                                 andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                 andFailure:(void (^)(NSURLSessionDataTask *task, NSError* error))failure;

#pragma mark - Put
/**
 *  @brief the method as Put of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  @brief the method as Put of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param header the request header.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  @brief the method as Put of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param body the body of request.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                  withBody:(NSDictionary *)body
                                andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  @brief the method as Put of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param header the request header.
 *
 *  @param body the body of request.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                  withBody:(NSDictionary *)body
                                andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/**
 *  @brief upload file.
 *
 *  @param url the url with request.
 *
 *  @param parameters the request parameters.
 *
 *  @param files the array with files(key - @"url": the url of file, @"name": the name of file).
 *
 *  @param success the block if upload successfully.
 *
 *  @param failure the block if upload unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Put:(NSString *)url withParameters:(NSDictionary *)parameters
                                withHeader:(NSDictionary *)header
                                 withFiles:(NSArray <NSDictionary *>*)files
                                 andSuccess:(void (^)(NSURLResponse *response, NSData *responseData))success
                                 andFailure:(void (^)(NSError *error))failure;
#pragma mark - Delete
/**
 *  @brief the method as Put of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                   andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                   andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  @brief the method as Put of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param header the request header.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                   withHeader:(NSDictionary *)header
                                   andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                   andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  @brief the method as Put of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param body the body of request.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                     withBody:(NSDictionary *)body
                                   andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                   andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  @brief the method as Put of HTTP request.
 *
 *  @param url the URL of request.
 *
 *  @param parameters the request parameters.
 *
 *  @param header the request header.
 *
 *  @param body the body of request.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */
+ (void)Delete:(NSString *)url withParameters:(NSDictionary *)parameters
                                   withHeader:(NSDictionary *)header
                                     withBody:(NSDictionary *)body
                                   andSuccess:(void (^)(NSURLSessionDataTask *task, NSData *responseData))success
                                   andFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

/**
 *  @brief the method of downloading file.
 *
 *  @param url the URL of request.
 *
 *  @param withHeaderField the request header.
 *
 *  @param path the local path.
 *
 *  @param downloadProgressBlock the progress block of download.
 *
 *  @param success the block if request successfully.
 *
 *  @param failure the block if request unsuccessfully.
 *
 *  @return void nil.
 */

+ (void)DownloadFile:(NSString *)url
     withHeaderField:(NSDictionary *)header
        atTargetPath:(NSURL *)path
            progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
             success:(void (^)(NSURL* filePath, id responseObject))success
             failure:(void (^)(NSError* error))failure;
@end
