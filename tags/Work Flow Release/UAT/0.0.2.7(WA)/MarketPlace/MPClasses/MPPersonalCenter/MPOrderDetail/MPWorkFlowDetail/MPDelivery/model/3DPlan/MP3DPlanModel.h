//
//  MP3DPlanModel.h
//  MarketPlace
//
//  Created by Jiao on 16/3/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"
#import "MP3DPlanDetailModel.h"

typedef enum : NSInteger {
    MP3DPlanModelTypeForNone = 0,
    MP3DPlanModelTypeForDesigner,
    MP3DPlanModelTypeForConsumer
}MP3DPlanModelType;

@interface MP3DPlanModel : MPModel

@property (nonatomic, copy) NSString *acs_project_id;
@property (nonatomic, copy) NSString *bedroom;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *community_name;
@property (nonatomic, copy) NSString *conception;
@property (nonatomic, copy) NSString *custom_string_area;
@property (nonatomic, copy) NSString *custom_string_bedroom;
@property (nonatomic, copy) NSString *custom_string_form;
@property (nonatomic, copy) NSString *custom_string_name;
@property (nonatomic, copy) NSString *custom_string_restroom;
@property (nonatomic, copy) NSString *custom_string_style;
@property (nonatomic, copy) NSString *custom_string_type;
@property (nonatomic, copy) NSString *design_asset_id;
@property (nonatomic, copy) NSString *design_name;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *hs_design_id;
@property (nonatomic, copy) NSString *hs_designer_uid;
@property (nonatomic, copy) NSString *project_style;
@property (nonatomic, copy) NSString *project_type;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *restroom;
@property (nonatomic, copy) NSString *room_area;
@property (nonatomic, copy) NSString *room_type;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, strong) NSArray *delivery_renderArr;
@property (nonatomic, strong) NSArray *delivery_designArr;
@property (nonatomic, strong) NSArray *delivery_BOMArr;

///获取该需求的所有的3D方案（以后可能是一对多）
+ (void)get3DPlansWithNeedsID:(NSString *)needs_id
               withDesignerID:(NSString *)designer_id
                  withSuccess:(void(^)(NSArray *plansArray))success
                   andFailure:(void(^)(NSError *error))failure;

///获取该需求的某一个3D方案
+ (void)getOne3DPlanWithAssetID:(NSString *)asset_id
                    withNeedsID:(NSString *)needs_id
                 withDesignerID:(NSString *)designer_id
                     withHeader:(NSDictionary *)headerDic
                    withSuccess:(void(^)(MP3DPlanModel *model))success
                     andFailure:(void(^)(NSError *error))failure;


+ (void)submitDesignDeliveryWithNeedsID:(NSString *)needs_id
                         withDesignerID:(NSString *)designer_id
                              withModel:(MP3DPlanModel *)model
                            withSuccess:(void(^)(NSDictionary * dict))success
                             andFailure:(void(^)(NSError *error))failure;

+ (void)submitMeasureDeliveryWithNeedsID:(NSString *)needs_id
                          withDesignerID:(NSString *)designer_id
                               withModel:(MP3DPlanModel *)model
                             withSuccess:(void(^)(NSDictionary * dict))success
                              andFailure:(void(^)(NSError *error))failure;

///获取设计交付物
+ (void)getDesignDeliveryWithNeedsID:(NSString *)needs_id
                      withDesingerID:(NSString *)desinger_id
                          withSucces:(void(^)(MP3DPlanModel *model))success
                          andFailure:(void(^)(NSError *error))failure;

///获取量房交付物
+ (void)getMeasureDeliveryWithNeedsID:(NSString *)needs_id
                       withDesingerID:(NSString *)desinger_id
                           withSucces:(void(^)(MP3DPlanModel *model))success
                           andFailure:(void(^)(NSError *error))failure;
@end
