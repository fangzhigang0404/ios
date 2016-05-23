//
//  MPDesignediliverView.m
//  MarketPlace
//
//  Created by zzz on 16/3/16.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPdiliverContraller.h"
#import "DesignediliverView.h"
#import "MPBillofMaterialsContraller.h"
#import "MPDeliveryModel.h"
@interface MPdiliverContraller ()<DesignediliverViewdelegate>
{
    NSMutableArray * DesingerArray;
    NSMutableArray * GeneralArray;
    int nolyoen;
    BillofMaterialsViewType _temp;
    DesignediliverView * diliverView;
}
@end

@implementation MPdiliverContraller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    diliverView = [[DesignediliverView alloc]initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height)];
    diliverView.delegate = self;
    self.rightButton.hidden = YES;
    [self.view addSubview:diliverView];
    [diliverView initView];
    DesingerArray = [[NSMutableArray alloc]init];
    GeneralArray = [[NSMutableArray alloc]init];
    self.TypeD = @"0";
    
    if ([self.assetid isKindOfClass:[NSNull class]] || [self.assetid isEqualToString:@""] || self.assetid == nil) {
        //获取交付物 消费者
        [self GETneedid:self.needid WithDesingerid:self.desingerid];
    }else {
        //提交交付物 设计师
        [self GETneedid:self.needid WithDesingerid:self.desingerid WithAssentid:self.assetid];
    }
    
}

- (void)GETneedid:(NSString * )neeid WithDesingerid:(NSString *)desingerid WithAssentid:(NSString *)assentid{
    
//
//    [MPDeliveryModel GetProjectAssetIDForNeedID:neeid WithDesigneID:desingerid WithSuccess:^(NSDictionary *dict) {
//        
//        
//        NSArray * array = [dict objectForKey:@"three_dimensionals"];
//        if (array.count == 0 || [array isKindOfClass:[NSNull class]]) {
//            return ;
//        }
//        self.assetid = [array[0] objectForKey:@"design_asset_id"];
//        
//        
//        [MPDeliveryModel Get3DfileListAssetID:self.assetid WithNeedID:neeid WihtDesingerID:desingerid WithSuccess:^(NSMutableArray *NSarray) {
//            
//            for (MPDeliveryModel * model in NSarray) {
//                
//
//                if ([model.Type isEqualToString:self.TypeD]) {
//                    [DesingerArray addObject:model];
//                    if ([DesingerArray isKindOfClass:[NSNull class]] || DesingerArray.count == 0) {
//                        return;
//                    }
//                }
//
//            }
//            
//        } failure:^(NSError *error) {
//            
//            NSLog(@"%@",error);
//            
//        }];
//        
//    } failure:^(NSError *error) {
//        
//        NSLog(@"%@",error);
//    }];
    
}

- (void)GETneedid:(NSString * )neeid WithDesingerid:(NSString *)desingerid{
//
//    diliverView.sel = YES;
//    [MPDeliveryModel GetProjectDataNeedID:neeid WithDesingerID:desingerid WithSucces:^(NSMutableArray *Nsarray) {
//
//        for (MPDeliveryModel * model in Nsarray) {
//            
//            if ([model.TYP isEqualToString:self.TypeD]) {
//                [DesingerArray addObject:model];
//                if ([DesingerArray isKindOfClass:[NSNull class]] || DesingerArray.count == 0) {
//                    return;
//                }
//            }
//        }
//        
//    } failure:^(NSError *error) {
//        
//   }];
//
}

- (void)SeliveryBtn:(UIButton *)seliverBtn{
    
    MPBillofMaterialsContraller * vc = [[MPBillofMaterialsContraller alloc]init];
    vc.Title =@"设计交付物";
    vc.fileArr = DesingerArray;
    if (DesingerArray.count == 0) {
        return;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    if ([DesingerArray isKindOfClass:[NSNull class]] || DesingerArray.count == 0) {
        return;
    }
    vc.AssetID = self.assetid;
    vc.type = TypeForSubmit;
    if (diliverView.sel == YES) {
        vc.type = TypeForObtain;
    }
    vc.dict = ^(NSMutableDictionary *dict) {
        [GeneralArray addObject:dict];
    };
}

-(void)SentBtn:(UIButton *)Sentbtn{
    
    NSMutableArray * strarray = [[NSMutableArray alloc]init];
    NSLog(@"%@======",GeneralArray);
    for (NSDictionary * dic in GeneralArray) {
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if (![obj isKindOfClass:[NSNull class]]) {
                [strarray addObject:obj];
            }
            
        }];
 
        
    }
    self.fileid = [strarray componentsJoinedByString:@","];
    NSLog(@"------------------------->>>>>%@",self.fileid);
    
    nolyoen++;
    if (nolyoen == 1) {
        
        /// 提交交付物
        [MPDeliveryModel SubmitDeliverablesAsset:self.assetid WithNeedID:self.needid WithDesignerID:self.desingerid WithFileID:[NSString stringWithFormat:@"%@",self.fileid] WithType:@"0" WithSuccess:^(NSDictionary *dict) {
            
            NSLog(@"%@",dict);
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"just_tip_tishi_success", @"") autoDisappearAfterDelay:1];
            
            
        } failure:^(NSError *error) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [MPAlertView showAlertWithMessage:NSLocalizedString(@"Fail_in_send", @"") autoDisappearAfterDelay:1];
            
        }];
        
    }else{
        
        [MPAlertView showAlertWithMessage:NSLocalizedString(@"Has_been_submitted, no_need_to_repeat", @"") autoDisappearAfterDelay:1];
    }

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapOnLeftButton:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
