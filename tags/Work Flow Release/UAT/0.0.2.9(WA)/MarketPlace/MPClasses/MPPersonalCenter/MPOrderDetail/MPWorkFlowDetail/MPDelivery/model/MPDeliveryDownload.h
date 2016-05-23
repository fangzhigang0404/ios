//
//  MPDeliveryDownload.h
//  MarketPlace
//
//  Created by Jiao on 16/3/29.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPDeliveryDownload : MPModel

+ (void)downloadFilesWithLink:(NSString *)link
                 withProgress:(void(^)(NSString *percent))progress
                  withSuccess:(void(^)(NSURL *filePath))success
                   andFailure:(void(^)(NSError *error))failure;

+ (NSURL *)getDownloadedFilesPathWithLink:(NSString *)link;
@end
