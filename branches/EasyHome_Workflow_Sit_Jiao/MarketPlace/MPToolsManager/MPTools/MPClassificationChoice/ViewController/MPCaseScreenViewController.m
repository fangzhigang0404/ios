//
//  MPCaseScreenViewController.m
//  MarketPlace
//
//  Created by xuezy on 16/2/23.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPCaseScreenViewController.h"
#import "MPCaseScreenView.h"
@interface MPCaseScreenViewController ()<caseScreenViewDelegate>
{
    NSMutableDictionary *typeDict;
}
@end

@implementation MPCaseScreenViewController
- (NSMutableDictionary *)selectDict {
    if (_selectDict == nil) {
        _selectDict = [NSMutableDictionary dictionary];
    }
    return _selectDict;
}

- (NSMutableDictionary *)selectTypeDict {
    if (_selectTypeDict == nil) {
        _selectTypeDict = [NSMutableDictionary dictionary];
    }
    return _selectTypeDict;
}

/// Rewrite the superclass showMenu method.
- (void)tapOnLeftButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)tapOnRightButton:(id)sender
{
    NSLog(@"完成风格:%@",self.selectDict);
    [self.delegate selectedClassificationDict:self.selectTypeDict withSelectDict:self.selectDict];

     [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"筛选";
    typeDict = [NSMutableDictionary dictionary];
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.rightButton setImage:nil forState:UIControlStateNormal];
    [self createCaseScreenView];
}

- (void)createCaseScreenView {
    NSLog(@"选中的信息:%@",self.selectDict);

    MPCaseScreenView *caseScreenView = [[MPCaseScreenView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT) withSelectDict:self.selectDict];
    caseScreenView.delegate = self;
//    caseScreenView.cellDict = self.selectDict;
    [self.view addSubview:caseScreenView];
    
}

- (void)didSelectType:(NSString *)buttonTitle type:(NSString *)type  withSelectCellSection:(NSMutableDictionary *)cellSectionDict{
    NSLog(@"%@_______%@",buttonTitle,type);
    [self.selectTypeDict setObject:buttonTitle forKey:type];
    self.selectDict = cellSectionDict;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
