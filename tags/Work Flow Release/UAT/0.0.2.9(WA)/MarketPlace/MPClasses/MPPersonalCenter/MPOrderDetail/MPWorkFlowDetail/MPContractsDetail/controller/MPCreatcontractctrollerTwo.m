//
//  MPCreatcontractctrollerTwo.m
//  MarketPlace
//
//  Created by zzz on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPCreatcontractctrollerTwo.h"
#import "MPCreatcontractViewTwo.h"
#import "MPcreatcontractcellTwo.h"
#import "MPSenddesigncontract.h"
#import "MPContractModel.h"
#import "MPPayMentViewController.h"
#import "MPpayTableViewCell.h"
#import "MPStatusMachine.h"
#import "MPStatusModel.h"
#import <JSONKit.h>
@interface MPCreatcontractctrollerTwo ()<MPCreatcontracTwoDeleagate>

@end


@implementation MPCreatcontractctrollerTwo
{
    MPCreatcontractViewTwo * _contractView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _contractView = [[MPCreatcontractViewTwo alloc]init];
    _contractView.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64);
    [_contractView initview:self.isPayNow];
    _contractView.deleage = self;
    [self.view addSubview:_contractView];
//    [self initData];
}
- (void)initData {
    WS(blockSelf);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [MPStatusMachine getCurrentStatusWithNeedsID:self.statusModel.needs_id withDesignerID:self.statusModel.designer_id andSuccess:^(MPStatusModel *statusModel) {
        blockSelf.statusDetail = [[MPStatusMachine getCurrentStatusMessageWithCurNodeID:statusModel.workFlowModel.wk_cur_sub_node_id] firstObject];
        blockSelf.statusModel = statusModel;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
//            [_contractView refreshMeasureDetailView];
        });
    } andFailure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:blockSelf.view animated:YES];
        });
    }];
}

- (MPcreatcontractTwoModel *)updateCell {
    return self.contractModel;
}

- (void)detailsBtn:(MPcreatcontractTwoModel *)model{

    MPSenddesigncontract * vc = [[MPSenddesigncontract alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

    vc.TotalCost = model.total;
    vc.FristCost = model.First;
    vc.EndCost = model.End;
}


- (void)Sendbtn:(MPcreatcontractTwoModel *)model {
//    
//    if (self.isPayNow) {
//        
//        MPPayMentViewController * vc = [[MPPayMentViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//        
//        return;
//    }
//    MPCreatcontractctrollerTwo * vc = [[MPCreatcontractctrollerTwo alloc]init];
//    vc.contractModel = model;
//    vc.isPayNow = YES;
//    [self.navigationController pushViewController:vc animated:YES];

    NSDictionary *contractDic = @{@"name":@"焦旭",@"age":@"18",@"phone":@"13845118320"};
    NSString *a = [contractDic JSONString];
    NSString *c= [NSString stringWithFormat:@"%@",contractDic];
    NSString *b = [a stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSLog(@"contractDic string : %@ %@ %@",a,b,c);
    ///design_sketch 效果图
    ///render_map  渲染图
    ///design_sketch_plus 每增加一张效果图费用
    
    
    /// not use??
//    NSArray *resultA = [a objectFromJSONString];
    
    NSDictionary * body = @{@"contract_no": @"100001",
                            @"contract_data": @"[{name:name},{key1:value1},{key2:value2}]",
                            @"contract_first_charge": [NSString stringWithFormat:@"%@",model.First],
                            @"contract_charge": @"4000",
                            @"contract_template_url": @"www.baidu.com",
                            @"contract_type": @(0),
                            @"designer_id": [AppController AppGlobal_GetMemberInfoObj].acs_member_id};
    
    [MPContractModel createDesignContractWithNeedID:self.statusModel.needs_id Withbody:body success:^(MPContractModel *model) {
        
        NSLog(@"model=====%@",model);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
