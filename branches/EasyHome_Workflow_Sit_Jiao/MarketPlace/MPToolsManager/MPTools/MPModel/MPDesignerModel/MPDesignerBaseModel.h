//
//  MPDesignerBaseModel.h
//  MarketPlace
//
//  Created by WP on 16/2/3.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"
#import "MPDesignerInfoModel.h"

@interface MPDesignerBaseModel : MPModel            /// i am base, i request data.

@property (nonatomic, retain) NSNumber *count;
@property (nonatomic, retain) NSNumber *offset;
@property (nonatomic, retain) NSNumber *limit;
@property (nonatomic, retain) NSArray<MPDesignerInfoModel> *designer_list;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

+ (void)getDesignerInfoWithParam:(NSDictionary *)param
                         success:(void (^)(MPDesignerInfoModel* model))success
                         failure:(void(^) (NSError *error))failure;
@end
