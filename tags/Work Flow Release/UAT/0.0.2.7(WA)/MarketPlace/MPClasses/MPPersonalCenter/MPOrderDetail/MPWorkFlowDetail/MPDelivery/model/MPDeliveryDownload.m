//
//  MPDeliveryDownload.m
//  MarketPlace
//
//  Created by Jiao on 16/3/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryDownload.h"
#import "MPHttpRequestManager.h"

@implementation MPDeliveryDownload

+ (void)downloadFilesWithLink:(NSString *)link
                 withProgress:(void(^)(NSString *))progress
                  withSuccess:(void(^)(NSURL *))success
                   andFailure:(void(^)(NSError *))failure{
    
    NSURL *targetURL = [MPDeliveryDownload getDownloadedFilesPathWithLink:link];
    NSLog(@"%@",targetURL.description);
    BOOL a = [MPDeliveryDownload isFileExist:targetURL.path];
    if (!a) {
        [MPHttpRequestManager DownloadFile:link withHeaderField:nil atTargetPath:targetURL progress:^(NSProgress *downloadProgress) {
            NSString *percent = [NSString stringWithFormat:@"%lld%%",(NSInteger)downloadProgress.               completedUnitCount * 100/downloadProgress.totalUnitCount];
            if (progress) {
                progress(percent);
            }
        } success:^(NSURL *filePath, id responseObject) {
            if (success) {
                success(filePath);
            }
        } failure:^(NSError *error) {
            //失败后再请求一次
            NSLog(@"download one more");
            if (failure) {
               [MPDeliveryDownload downloadFilesWithLink:link withProgress:progress withSuccess:success andFailure:nil];
            }
        }];
    }else {
        if (success) {
            success(targetURL);
        }
    }
}

+ (NSURL *)getDownloadedFilesPathWithLink:(NSString *)link {
    NSString *docDir = [NSString stringWithFormat:@"%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    NSString *folderPath = [docDir stringByAppendingPathComponent:@"mpdelivery"];
    [MPDeliveryDownload createDirectory:folderPath];

    NSString *absolutePath = [link stringByExpandingTildeInPath];
    NSString *fileDir = [NSString stringWithFormat:@"%@/%@",folderPath,[absolutePath lastPathComponent]];
    NSURL *targetURL = [NSURL fileURLWithPath:fileDir];
    return targetURL;
}

+ (BOOL) isFileExist:(NSString *)filePath {
    return ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
}

+ (void) createDirectory:(NSString *)folderFullpath {
    if (folderFullpath) {
        
        if (![MPDeliveryDownload isDirectoryExist:folderFullpath]) {
            NSError *err = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:folderFullpath
                                                 withIntermediateDirectories:YES
                                                                  attributes:nil
                                                                       error:&err];
        
        }
    }
}
+ (BOOL) isDirectoryExist:(NSString *)filePath {
    if (filePath) {
        //Value of bStaus is undefined upon return when path does not exist
        // so just return with NO if path is not found
        BOOL bStatus = NO;
        BOOL bExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&bStatus];
        
        if (bExists)
            return bStatus;
    }
    
    return NO;
}
@end
