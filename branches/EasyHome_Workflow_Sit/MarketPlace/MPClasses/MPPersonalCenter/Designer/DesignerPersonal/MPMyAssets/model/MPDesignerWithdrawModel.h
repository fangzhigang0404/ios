//
//  MPDesignerWithdrawModel.h
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPDesignerWithdrawModel : MPModel
@property (copy,nonatomic)NSString *bank_name;
@property (copy,nonatomic)NSString *timeString;

@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *transLog_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *remark;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)demandWithDict:(NSDictionary *)dict;
+(void)getDesignerWithDraw:(NSString *)designer_id withParameter:(NSDictionary *)paramDict success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure;
@end
