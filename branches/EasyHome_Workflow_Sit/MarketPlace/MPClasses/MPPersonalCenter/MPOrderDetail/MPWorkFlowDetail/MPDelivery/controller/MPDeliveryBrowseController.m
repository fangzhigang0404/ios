//
//  MPDeliveryBrowseController.m
//  MarketPlace
//
//  Created by Jiao on 16/3/24.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDeliveryBrowseController.h"
#import <UIImageView+WebCache.h>
#import "MP3DPlanModel.h"
#import "MP3DPlanDetailModel.h"

@interface MPDeliveryBrowseController ()

@end

@implementation MPDeliveryBrowseController
{
    __weak IBOutlet UIButton *_backBtn;
    __weak IBOutlet UIButton *_selectBtn;

    __weak IBOutlet UIButton *_confirmBtn;
    
    __weak IBOutlet UIView *_topView;
    __weak IBOutlet UIView *_bottomView;
    
    __weak IBOutlet UITableView *_browseTableView;
    NSArray *_filesArray;
    NSInteger _index;
    NSInteger _type;
}

- (instancetype)initWithFilesArray:(NSArray *)filesArr andIndex:(NSInteger)index andType:(NSInteger)type{
    self = [super init];
    if (self) {
        _filesArray = filesArr;
        _index = index;
        _type = type;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _browseTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
}

#pragma mark - Custom Method
- (IBAction)backBtnClick:(id)sender {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectBtnClick:(id)sender {
    
}
- (IBAction)confirmBtnClick:(id)sender {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _filesArray.count;
}


@end
