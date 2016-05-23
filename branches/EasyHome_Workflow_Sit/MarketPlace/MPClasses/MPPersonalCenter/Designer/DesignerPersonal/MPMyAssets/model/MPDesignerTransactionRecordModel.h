//
//  MPDesignerTransactionRecordModel.h
//  MarketPlace
//
//  Created by xuezy on 16/3/9.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

@interface MPDesignerTransactionRecordModel : MPModel
@property (copy,nonatomic)NSString *adjustment;
@property (copy,nonatomic)NSString *create_date;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *order_line_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)demandWithDict:(NSDictionary *)dict;
+(void)getDesignerTransactionTecord:(NSString *)designer_id withParameter:(NSDictionary *)paramDict success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure;
@end
