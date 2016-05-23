//
//  MPDeliveryDetailController.m
//  MarketPlace
//
//  Created by Jiao on 16/3/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryDetailController.h"
#import <QuickLook/QuickLook.h>
#import "MPDeliveryBrowseController.h"
#import "MPDeliveryDownload.h"

@interface FileModel : NSObject <QLPreviewItem>
@property (nonatomic, strong)NSURL * previewItemURL;
@property (nonatomic, strong)NSString *previewItemTitle;
@end
@implementation FileModel


@end

@interface MPDeliveryDetailController ()<MPDeliveryDetailViewDelegate, QLPreviewControllerDelegate,QLPreviewControllerDataSource>
@property (nonatomic, strong) NSArray *filesArr;
@property (nonatomic, strong) NSMutableDictionary *resultDic;

@end

@implementation MPDeliveryDetailController
{
    MPDeliveryDetailView *deView;
    MPDeliveryDetailType _tempType;
    BOOL _tempFlag;
    NSInteger _cType;
    QLPreviewController* previewController;
    NSMutableArray *_fileURLArr;
}
- (instancetype)initWithFilesArray:(NSArray *)array andType:(MPDeliveryDetailType)type andControllerType:(NSInteger)cType {
    self = [super init];
    if (self) {
        _cType = cType;
        self.filesArr = [NSArray arrayWithArray:array];
        self.resultDic = [NSMutableDictionary dictionary];
        _fileURLArr = [NSMutableArray array];
        _tempType = type;
        if (type == DeTypeForMy3D) {
            for (MP3DPlanModel *model in self.filesArr) {
                [self.resultDic setValue:@(model.isSelected) forKey:model.design_asset_id];
                FileModel *fmodel = [[FileModel alloc]init];
                fmodel.previewItemURL =[MPDeliveryDownload getDownloadedFilesPathWithLink:model.link];
                fmodel.previewItemTitle = model.design_name;
                [_fileURLArr addObject:fmodel];
            }
        }else {
            for (MP3DPlanDetailModel *model in self.filesArr) {
                [self.resultDic setValue:@(model.isSelected) forKey:model.submit_id];
                FileModel *fmodel = [[FileModel alloc]init];
                fmodel.previewItemURL =[MPDeliveryDownload getDownloadedFilesPathWithLink:model.link];
                fmodel.previewItemTitle = model.name;
                [_fileURLArr addObject:fmodel];
            }
        }
        
        previewController  =[[QLPreviewController alloc]init];
        previewController.delegate = self;
        previewController.dataSource = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightButton.hidden = YES;
    switch (_tempType) {
        case DeTypeForMy3D:
            self.titleLabel.text = @"我的3D方案";
            break;
        case DeTypeForRender:
            self.titleLabel.text = @"渲染图交付";
            break;
        case DeTypeForDesign:
            self.titleLabel.text = @"设计图纸";
            break;
        case DeTypeForMaterial:
            self.titleLabel.text = @"材料清单";
            break;
        case DeTypeForMeasure:
            self.titleLabel.text = @"量房交付";
            break;
        default:
            break;
    }
    deView = [[MPDeliveryDetailView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVBAR_HEIGHT) withcType:_cType];
    [self.view addSubview:deView];
    deView.delegate = self;
}

#pragma mark - MPDeliveryDetailViewDelegate
- (NSArray *)getFilesArray {
    return self.filesArr;
}

- (void)confirmDelivery {
        if (_tempType == DeTypeForMy3D) {
            BOOL flag = NO;
            MP3DPlanModel *tempModel;
            for (MP3DPlanModel *model in self.filesArr) {
                model.isSelected = [[self.resultDic objectForKey:model.design_asset_id] boolValue];
                if (model.isSelected) {
                    tempModel = model;
                    flag = YES;
                }
            }
            [self.delegate selectedPlan:flag ? tempModel : nil];
        }else {
            BOOL flag = NO;
            for (MP3DPlanDetailModel *model in self.filesArr) {
                model.isSelected = [[self.resultDic objectForKey:model.submit_id] boolValue];
                if (model.isSelected) {
                    flag = YES;
                }
            }
            [self.delegate selectedFiles:self.filesArr withType:_tempType withHas:flag];
        }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MPDeliveryDetailCellDelegate
- (void)getDataFromIndex:(NSInteger)index withBlock:(void(^)(MPDeliveryDetailType type, id model, BOOL isSelected))block {
    if (block) {
        if (_tempType == DeTypeForMy3D) {
            MP3DPlanModel *model = [self.filesArr objectAtIndex:index];
            block(_tempType, model, [[self.resultDic objectForKey:model.design_asset_id] boolValue]);
        }else {
            MP3DPlanDetailModel *model = [self.filesArr objectAtIndex:index];
            block(_tempType, model, [[self.resultDic objectForKey:model.submit_id] boolValue]);
        }
    }
}

- (void)selectItemIndex:(NSInteger)index withSelected:(BOOL)selected {
    
    if (_tempType == DeTypeForMy3D) {
        MP3DPlanModel *model = [self.filesArr objectAtIndex:index];
        [self.resultDic setValue:@(selected) forKey:model.design_asset_id];
        [self.resultDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([@"ENOUGH" isEqualToString:key]) {
                *stop = YES;
            }
            if ([model.design_asset_id isEqualToString:key]) {
                obj = @(NO);
            }
        }];
        [deView refreshDetailView];
    }else {
        MP3DPlanDetailModel *model = [self.filesArr objectAtIndex:index];
        [self.resultDic setValue:@(selected) forKey:model.submit_id];
//        for (NSInteger i = 0; i < _tempArray.count; i++) {
//            MP3DPlanDetailModel *model = [_tempArray objectAtIndex:i];
//            if (i == index) {
//                model.isSelected = selected;
//            }
//        }
    }
}

- (void)tapDeliveryImgViewForIndex:(NSInteger)index {
//    MPDeliveryBrowseController *vc = [[MPDeliveryBrowseController alloc] initWithFilesArray:self.filesArr andIndex:index andType:_tempType];
//    [self.navigationController pushViewController:vc animated:YES];
    [self presentViewController:previewController animated:YES completion:nil];
    [previewController setCurrentPreviewItemIndex:index];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller{
    
    return [_fileURLArr count];
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index{

    return [_fileURLArr objectAtIndex:index];
}

@end
