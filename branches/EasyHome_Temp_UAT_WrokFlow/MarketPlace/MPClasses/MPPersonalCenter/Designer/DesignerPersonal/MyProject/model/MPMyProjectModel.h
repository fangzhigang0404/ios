/**
 * @file    MPMyProjectModel.h
 * @brief   bei shu order the data model.
 * @author  Xue
 * @version 1.0
 * @date    2016-01-21
 */

#import <Foundation/Foundation.h>
#import "MPModel.h"
@interface MPMyProjectModel : MPModel///我的项目的model

@property (copy,nonatomic)NSString *projectName;
@property (copy,nonatomic)NSString *nameString;
@property (copy,nonatomic)NSString *phone;
@property (copy,nonatomic)NSString *neighbourhoods;
@property (copy,nonatomic)NSString *houseType;
@property (copy,nonatomic)NSString *room;
@property (copy,nonatomic)NSString *living_room;
@property (copy,nonatomic)NSString *toilet;
@property (copy,nonatomic)NSString *style;
@property (copy,nonatomic)NSString *orderId;
@property (copy,nonatomic)NSString *district;
@property (copy,nonatomic)NSString *city;
@property (copy,nonatomic)NSString *province;
@property (copy,nonatomic)NSString *is_beishu;

@property (copy,nonatomic)NSString *avatar;

@property (copy, nonatomic) NSString *consumer_id;

@property (copy, nonatomic) NSString *beishu_thread_id;

@property (copy, nonatomic) NSString *needs_id;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)createWithDict:(NSDictionary *)dict;

+(void)createDesignerMyProjectWithOffset:(NSString *)offset withLimit:(NSString *)limit success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure;

@end
