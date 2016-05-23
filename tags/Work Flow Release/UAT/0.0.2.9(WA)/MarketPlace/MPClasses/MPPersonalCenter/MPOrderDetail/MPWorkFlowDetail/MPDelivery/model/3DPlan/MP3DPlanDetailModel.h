//
//  MP3DPlanDetailModel.h
//  MarketPlace
//
//  Created by Jiao on 16/3/26.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPModel.h"

typedef enum : NSInteger {
    PlanTypeForRender = 0,   //渲染图 (render)
    PlanTypeFor3D,           //3D方案 (3D)
    PlanTypeForBOM,          //BOM
    PlanTypeForCAD,          //CAD (2D平面图)
    PlanTypeFor360,          //360全景图
    PlanTypeForCase,         //装修案例图
    PlanTypeForSnapshot,     //截图 (SNAPSHOT)
    PlanTypeForOthers,       //其它 (Others)
    PlanTypeFor3DGraphicURL, //3D平面图URL
    PlanTypeFor2DGraphicURL, //2D平面图URL
    PlanTypeFor3DHouseTypeURL//3D户型图URL
}MP3DPlanDetailModelType;

@interface MP3DPlanDetailModel : MPModel
@property (nonatomic, copy) NSString *extended_data;
@property (nonatomic, copy) NSString *fileid;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *source_id;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) MP3DPlanDetailModelType type;

@property (nonatomic, copy) NSString *submit_id; /// 提交时提供的文件id
@property (nonatomic, assign) BOOL isSelected;

+ (instancetype)get3DPlanDetailWithDict:(NSDictionary *)dict;
@end
