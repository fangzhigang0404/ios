//
//  MP3DPlanModel.m
//  MarketPlace
//
//  Created by Jiao on 16/3/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MP3DPlanModel.h"


@implementation MP3DPlanModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.acs_project_id = [NSString stringWithFormat:@"%@",dict[@"acs_project_id"]];
        self.bedroom = [NSString stringWithFormat:@"%@",dict[@"bedroom"]];
        self.city = [NSString stringWithFormat:@"%@",dict[@"city"]];
        self.community_name = [NSString stringWithFormat:@"%@",dict[@"community_name"]];
        self.conception = [NSString stringWithFormat:@"%@",dict[@"conception"]];
        self.custom_string_area = [NSString stringWithFormat:@"%@",dict[@"custom_string_area"]];
        self.custom_string_bedroom = [NSString stringWithFormat:@"%@",dict[@"custom_string_bedroom"]];
        self.custom_string_form = [NSString stringWithFormat:@"%@",dict[@"custom_string_form"]];
        self.custom_string_name = [NSString stringWithFormat:@"%@",dict[@"custom_string_name"]];
        self.custom_string_restroom = [NSString stringWithFormat:@"%@",dict[@"custom_string_restroom"]];
        self.custom_string_style = [NSString stringWithFormat:@"%@",dict[@"custom_string_style"]];
        self.custom_string_type = [NSString stringWithFormat:@"%@",dict[@"custom_string_type"]];
        self.design_asset_id = [NSString stringWithFormat:@"%@",dict[@"design_asset_id"]];
        self.design_name = [NSString stringWithFormat:@"%@",dict[@"design_name"]];
        self.district = [NSString stringWithFormat:@"%@",dict[@"district"]];
        self.hs_design_id = [NSString stringWithFormat:@"%@",dict[@"hs_design_id"]];
        self.hs_designer_uid = [NSString stringWithFormat:@"%@",dict[@"hs_designer_uid"]];
        self.project_style = [NSString stringWithFormat:@"%@",dict[@"project_style"]];
        self.project_type = [NSString stringWithFormat:@"%@",dict[@"project_type"]];
        self.province = [NSString stringWithFormat:@"%@",dict[@"province"]];
        self.restroom = [NSString stringWithFormat:@"%@",dict[@"restroom"]];
        self.room_area = [NSString stringWithFormat:@"%@",dict[@"room_area"]];
        self.room_type = [NSString stringWithFormat:@"%@",dict[@"room_type"]];
        
        NSMutableArray *renderArr = [NSMutableArray array];
        NSMutableArray *designArr = [NSMutableArray array];
        NSMutableArray *BOMArr = [NSMutableArray array];
        for (NSDictionary *tempDic in dict[@"design_file"]) {
            MP3DPlanDetailModel *model = [MP3DPlanDetailModel get3DPlanDetailWithDict:tempDic];
            if (model.type == PlanTypeFor3DHouseTypeURL) {
                self.link = model.link;
            }
            
            switch (model.type) {
                case PlanTypeFor360 :
                case PlanTypeForRender : {
                    [renderArr addObject:model];
                    break;
                }
                case PlanTypeForBOM: {
                    [BOMArr addObject:model];
                    break;
                }
                case PlanTypeForCAD: {
                    [designArr addObject:model];
                    break;
                }
                case PlanTypeFor3D:
                case PlanTypeForCase:
                case PlanTypeForSnapshot:
                case PlanTypeForOthers:
                case PlanTypeFor3DGraphicURL:
                case PlanTypeFor2DGraphicURL:
                case PlanTypeFor3DHouseTypeURL:
                    break;
                    
                default:
                    break;
            }
            
            self.delivery_renderArr = [NSArray arrayWithArray:renderArr];
            self.delivery_designArr = [NSArray arrayWithArray:designArr];
            self.delivery_BOMArr = [NSArray arrayWithArray:BOMArr];
        }
        
    }
    return self;
}

- (instancetype)initWithDicta:(NSDictionary *)dicta {
    self = [super init];
    if (self) {
        NSMutableArray *renderArr = [NSMutableArray array];
        NSMutableArray *designArr = [NSMutableArray array];
        NSMutableArray *BOMArr = [NSMutableArray array];
        for (NSDictionary *tempDic in dicta[@"deliveryFiles"]) {
            MP3DPlanDetailModel *model = [MP3DPlanDetailModel get3DPlanDetailWithDict:tempDic];
            model.type = [tempDic[@"usage_type"] integerValue];
            model.link = tempDic[@"url"];
            if (model.type == PlanTypeFor3DHouseTypeURL) {
                self.link = model.link;
                self.design_asset_id = model.fileid;
            }
            switch (model.type) {
                case PlanTypeFor360 :
                case PlanTypeForRender : {
                    [renderArr addObject:model];
                    break;
                }
                case PlanTypeForBOM: {
                    [BOMArr addObject:model];
                    break;
                }
                case PlanTypeForCAD: {
                    [designArr addObject:model];
                    break;
                }
                case PlanTypeFor3D:
                case PlanTypeForCase:
                case PlanTypeForSnapshot:
                case PlanTypeForOthers:
                case PlanTypeFor3DGraphicURL:
                case PlanTypeFor2DGraphicURL:
                case PlanTypeFor3DHouseTypeURL:
                    break;
                    
                default:
                    break;
            }
        }
        self.delivery_renderArr = [NSArray arrayWithArray:renderArr];
        self.delivery_designArr = [NSArray arrayWithArray:designArr];
        self.delivery_BOMArr = [NSArray arrayWithArray:BOMArr];
        
    }
    return self;
}
+ (instancetype)get3DPlanModelWithDict:(NSDictionary *)dict {
    return [[MP3DPlanModel alloc] initWithDict:dict];
}

+ (instancetype)getDeliveryModelWithDict:(NSDictionary *)dict {
    return [[MP3DPlanModel alloc] initWithDicta:dict];
}

+ (void)get3DPlansWithNeedsID:(NSString *)needs_id
               withDesignerID:(NSString *)designer_id
                  withSuccess:(void(^)(NSArray *plansArray))success
                   andFailure:(void(^)(NSError *error))failure {
    
    NSMutableArray *plansArray = [NSMutableArray array];
    NSDictionary *headerDict = [self getHeaderAuthorization];
    [MPAPI GetProjectNeedID:needs_id WithHeard:headerDict WithDesingeid:designer_id WithSuccess:^(NSDictionary *dict) {
       
        NSArray * array = [dict objectForKey:@"three_dimensionals"];
        if (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0) {
            if (success) {
                success(plansArray);
            }
            return;
        }

        __block NSInteger arrCount = array.count;
        __block void (^tempblock)(int) = ^(int index){
           if (arrCount == plansArray.count) {
               if (success) {
                   success(plansArray);
               }
           }
            return ;
        };
        
        for (int i = 0; i < array.count; i++) {
            NSDictionary *tempDict = [array objectAtIndex:i];
                // 并行执行的线程一
            NSString *asset_id = tempDict[@"design_asset_id"];
            [MP3DPlanModel getOne3DPlanWithAssetID:asset_id withNeedsID:needs_id withDesignerID:designer_id withHeader:headerDict withSuccess:^(MP3DPlanModel *model) {
                NSLog(@"%@",dict.description);
                [plansArray addObject:model];
                tempblock(i);
            } andFailure:^(NSError *error) {
                arrCount--;
                tempblock(i);
            }];
        }
    } failure:failure];
}

+ (void)getOne3DPlanWithAssetID:(NSString *)asset_id
                    withNeedsID:(NSString *)needs_id
                 withDesignerID:(NSString *)designer_id
                     withHeader:(NSDictionary *)headerDic
                    withSuccess:(void(^)(MP3DPlanModel *))success
                     andFailure:(void(^)(NSError *))failure {
    [MPAPI Get3DfileListAssetID:asset_id WithNeedID:needs_id WihtDesingerID:designer_id WithHeader:headerDic WithSuccess:^(NSDictionary *dict) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dict];
        [dic setValue:asset_id forKey:@"design_asset_id"];
        if (success) {
            success([MP3DPlanModel get3DPlanModelWithDict:dic]);
        }
        
    } failure:failure];
}

+ (void)submitDesignDeliveryWithNeedsID:(NSString *)needs_id
                         withDesignerID:(NSString *)designer_id
                              withModel:(MP3DPlanModel *)model
                            withSuccess:(void(^)(NSDictionary * dict))success
                             andFailure:(void(^)(NSError *error))failure {
    NSMutableString *str = [NSMutableString string];
    for (MP3DPlanDetailModel *tempModel in model.delivery_renderArr ) {
        if (tempModel.isSelected) {
            [str appendString:[NSString stringWithFormat:@"%@,",tempModel.submit_id]];
        }
    }
    for (MP3DPlanDetailModel *tempModel in model.delivery_designArr ) {
        if (tempModel.isSelected) {
            [str appendString:[NSString stringWithFormat:@"%@,",tempModel.submit_id]];
        }
    }
    for (MP3DPlanDetailModel *tempModel in model.delivery_BOMArr ) {
        if (tempModel.isSelected) {
            [str appendString:[NSString stringWithFormat:@"%@,",tempModel.submit_id]];
        }
    }
    [str appendString:[NSString stringWithFormat:@"%@,",model.design_asset_id]];
    NSString *fileids = [str substringToIndex:str.length-1];
    [MP3DPlanModel submitDeliveryWithAsset:model.design_asset_id withNeedsID:needs_id withDesignerID:designer_id withFileIDs:fileids withType:@"1" withSuccess:success andFailure:failure];
}

+ (void)submitMeasureDeliveryWithNeedsID:(NSString *)needs_id
                          withDesignerID:(NSString *)designer_id
                               withModel:(MP3DPlanModel *)model
                             withSuccess:(void(^)(NSDictionary * dict))success
                              andFailure:(void(^)(NSError *error))failure {
    NSMutableString *str = [NSMutableString string];
    for (MP3DPlanDetailModel *tempModel in model.delivery_designArr) {
        if (tempModel.isSelected) {
            [str appendString:[NSString stringWithFormat:@"%@,",tempModel.submit_id]];
        }
    }
    [str appendString:[NSString stringWithFormat:@"%@,",model.design_asset_id]];
    NSString *fileids = [str substringToIndex:str.length-1];
    [MP3DPlanModel submitDeliveryWithAsset:model.design_asset_id withNeedsID:needs_id withDesignerID:designer_id withFileIDs:fileids withType:@"0" withSuccess:success andFailure:failure];
}

+ (void)submitDeliveryWithAsset:(NSString *)asset_id
                    withNeedsID:(NSString *)needs_id
                 withDesignerID:(NSString *)designer_id
                    withFileIDs:(NSString *)file_ids
                       withType:(NSString *)type
                    withSuccess:(void(^)(NSDictionary * dict))success
                     andFailure:(void(^)(NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];
    [MPAPI SubmitDeliverablesAsset:asset_id WithNeedID:needs_id WithDesignerID:designer_id WithFileID:file_ids WithType:type WithHeader:headerDict WithSuccess:^(NSDictionary *dict) {
        
        if (success) {
            success(dict);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getDesignDeliveryWithNeedsID:(NSString *)needs_id
                      withDesingerID:(NSString *)desinger_id
                          withSucces:(void(^)(MP3DPlanModel *))success
                          andFailure:(void(^)(NSError *))failure {
    NSDictionary * headerDic = [self getHeaderAuthorization];
    [MPAPI GetProjectDataNeedID:needs_id WithDesingerID:desinger_id WithHeaderDict:headerDic WithSucces:^(NSDictionary *dict) {
        MP3DPlanModel *tempModel;
        if ([dict[@"count"] integerValue] == 0) {
            if (success) {
                success(tempModel);
            }
            return ;
        }
        tempModel = [MP3DPlanModel getDeliveryModelWithDict:dict];
        [MP3DPlanModel getOne3DPlanWithAssetID:tempModel.design_asset_id withNeedsID:needs_id withDesignerID:desinger_id withHeader:headerDic withSuccess:^(MP3DPlanModel *model) {
            
            tempModel.design_name = model.design_name;
            if (success) {
                success(tempModel);
            }
        } andFailure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
        
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getMeasureDeliveryWithNeedsID:(NSString *)needs_id
                       withDesingerID:(NSString *)desinger_id
                           withSucces:(void(^)(MP3DPlanModel *model))success
                           andFailure:(void(^)(NSError *error))failure {
    NSDictionary * headerDic = [self getHeaderAuthorization];
    [MPAPI GetProjectDataNeedID:needs_id WithDesingerID:desinger_id WithHeaderDict:headerDic WithSucces:^(NSDictionary *dict) {
        MP3DPlanModel *tempModel;
        if ([dict[@"count"] integerValue] == 0) {
            if (success) {
                success(tempModel);
            }
            return ;
        }
        tempModel = [MP3DPlanModel getDeliveryModelWithDict:dict];
            if (success) {
                success(tempModel);
            }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
