/**
 * @file    MPHomeViewController.h
 * @brief   the controller of home case.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import "MPHomeViewController.h"
#import "MPHomeView.h"
#import "MPHomeViewCell.h"
#import "MPIssueDemandViewController.h"
#import "MPCaseLibraryViewController.h"
#import "MPCaseDetailViewController.h"
#import "MPChatListViewController.h"
#import "MPBubbleMenu.h"
#import "MPCaseLibraryViewController.h"
#import "MPFindDesignersViewController.h"
#import "MPSearchCaseViewController.h"
#import "MPDesignerDetailViewController.h"
#import "MPCaseBaseModel.h"
#import "MPSearchCaseLibraryViewController.h"
#import "MPChatRoomViewController.h"
#import "MPCaseLibraryDetailViewController.h"

@interface MPHomeViewController ()<MPHomeViewDelegate, MPHomeViewCellDelegate, DWBubbleMenuViewDelegate>

@end

@implementation MPHomeViewController
{
    UIImageView *_btnImage;             //!< _btnImage the imageView for home button.
    MPBubbleMenu *upMenuView;           //!< upMenuView the view for show menuView.
    UIView *_bgView;                    //!< _bgView the view for upMenuView background.
    UIView *_bgView2;                   //!< _bgView2 the view for upMenuView background.
    MPHomeView *consumerView;           //!< consumerView the view for controller.
    BOOL _isLoadMore;                   //!< _isLoadMore load more or not.
    NSMutableArray *_consumerArray;     //!< _consumerArray the array of datasource.
    NSInteger _offset;                  //!< _offset offset for request.
    NSInteger _limit;                   //!< _limit limit for request.
}

- (void)tapOnRightButton:(id)sender
{
    //self.tabBarController.tabBar.hidden = YES;
//    MPSearchCaseViewController *search = [[MPSearchCaseViewController alloc] init];
//    search.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:search animated:YES];
    
//    MPSearchCaseLibraryViewController *search = [[MPSearchCaseLibraryViewController alloc] init];
//    [self customPushViewController:search animated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    
    self.menuLabel.text = NSLocalizedString(@"designerKey",nil);
    
    _btnImage.hidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.leftButton.hidden = YES;
    self.menuLabel.hidden = YES;
    
    self.titleLabel.text = NSLocalizedString(@"HomePage_key", @"");
    consumerView = [[MPHomeView alloc] initWithFrame:CGRectMake(0, -5, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT +5)];
    consumerView.delegate = self;
    [self.view addSubview:consumerView];
    [self.view sendSubviewToBack:consumerView];
    [self followScrollView:consumerView.homeCollectionView];
    
    self.rightButton.hidden = YES;
    
    /// Create button moving area.
    upMenuView = [[MPBubbleMenu alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 180,self.view.bounds.size.height-260,300,200) expansionDirection:DirectionUp];
    
    if (SCREEN_WIDTH > 400) {
        upMenuView = [[MPBubbleMenu alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 200,self.view.bounds.size.height-260,340,200) expansionDirection:DirectionUp];
    }
    
    upMenuView.userInteractionEnabled = YES;
    upMenuView.delegate = self;
    [upMenuView addButtons:[self createButtonArray]];
    
    _btnImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 58 - 15, SCREEN_HEIGHT - 58 - 66 , 58, 58)];
    _btnImage.image = [UIImage imageNamed:SUSPENSION_EXPAND];
    _btnImage.layer.cornerRadius = 29;
    if (SCREEN_WIDTH > 400) {
        _btnImage.frame = CGRectMake(SCREEN_WIDTH - 66 - 15, SCREEN_HEIGHT - 66 - 66 , 66, 66);
        _btnImage.layer.cornerRadius = 33;
    }
    _btnImage.userInteractionEnabled = YES;
    [_btnImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch)]];
    [self.view addSubview:_btnImage];
    
    [self initData];
}

- (void)initData {
    _consumerArray= [NSMutableArray array];
    _isLoadMore = NO;
    _offset = 0;
    _limit = 10;
}

- (void)requestData {
    WS(weakSelf);
    [MPCaseBaseModel getCaseLibrayWithOffset:[NSString stringWithFormat:@"%ld",(long)_offset] limit:[NSString stringWithFormat:@"%ld",(long)_limit] custom_string_area:@"" custom_string_form:@"" custom_string_style:@"" custom_string_type:@"" custom_string_keywords:@"" success:^(NSArray *array) {
        if (!_isLoadMore)
            [_consumerArray removeAllObjects];
        [weakSelf endRefreshView:_isLoadMore];
        [_consumerArray addObjectsFromArray:array];
        [consumerView refreshHomeCaseView];
        
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
        [MPAlertView showAlertForNetError];
        [weakSelf endRefreshView:_isLoadMore];
    }];
}

- (void)refreshLoadNewData:(void (^)())finish {
    self.refreshForLoadNew = finish;
    _isLoadMore = NO;
    _offset = 0;
    [self requestData];
}

- (void)refreshLoadMoreData:(void (^)())finish {
    self.refreshForLoadMore = finish;
    _isLoadMore = YES;
    _offset += _limit;
    [self requestData];
}

- (void)bubbleMenuButtonDidCollapse:(MPBubbleMenu *)expandableView
{
    [_bgView2 removeFromSuperview];
    [_bgView removeFromSuperview];
    _btnImage.hidden = NO;
}


- (void)touch
{
    _btnImage.hidden = YES;
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0.5;
    
    _bgView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _bgView2.backgroundColor = [UIColor clearColor];
    [_bgView2 addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(effectclick)]];
    [self.tabBarController.view addSubview:_bgView];
    [self.tabBarController.view addSubview:_bgView2];
    [_bgView2 addSubview:upMenuView];
    [upMenuView showButtons];
}


-(void)effectclick
{
    _btnImage.hidden = NO;
    [_bgView2 removeFromSuperview];
    [_bgView removeFromSuperview];
}


#pragma mark -------MPHomeViewDelegate, MPHomeViewCellDelegate--------

- (MPCaseModel *) getDatamodelForIndex:(NSUInteger) index
{
    return [_consumerArray objectAtIndex:index];
}

- (void) designerIconClickedAtIndex:(NSUInteger) consumer
{
    MPCaseModel *caseModel = _consumerArray[consumer];
    MPDesignerInfoModel *model = caseModel.designer_info;
    model.member_id = caseModel.designer_id;
    model.hs_uid = caseModel.hs_designer_uid;
    
    MPDesignerDetailViewController *detail = [[MPDesignerDetailViewController alloc]
                                              initWithIsDesignerCenter:NO
                                              designerInfoModel:model
                                              isConsumerNeeds:NO
                                              needInfo:nil
                                              needInfoIndex:0];

    [self customPushViewController:detail animated:YES];
}


- (void)chatButtonClickedAtIndex:(NSUInteger)consumer {
    MPCaseModel *model = _consumerArray[consumer];
    
    NSLog(@"%@",model.designer_id);
    
    if ([AppController AppGlobal_GetLoginStatus]) {
        
        [AppController chatWithVC:self
                       ReceiverID:[model.designer_id description]
              ReceiverHomeStyleID:model.hs_designer_uid
                     receiverName:model.designer_info.nick_name
                          assetID:nil
                         isQRScan:NO];
        
    } else {
        [AppController AppGlobal_ProccessLogin];
    }
}

- (void)didSelectedItemAtIndex:(NSUInteger)index {
    
    MPCaseModel * model = [_consumerArray objectAtIndex:index];
    
    MPCaseLibraryDetailViewController *caseDetail = [[MPCaseLibraryDetailViewController alloc] init];
    caseDetail.model = model;
    caseDetail.arrayDS = _consumerArray;
    caseDetail.index = index;
    caseDetail.case_id = model.case_id;
    [self customPushViewController:caseDetail animated:YES];
}


- (NSUInteger) getNumberOfItemsInCollection {
    return _consumerArray.count;
}

- (NSArray *)createButtonArray
{
    /// Create the buttons array.
    NSMutableArray *buttonsMutable = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 3; ++i)
    {
        if ([AppController AppGlobal_GetIsDesignerMode] && i == 0) continue;
        
        /// Create button do View,set button attribute.
        UIView *view1=[[UIView alloc]initWithFrame:CGRectMake(300, 100, 300, 40)];
        
        //view1.backgroundColor = [UIColor redColor];
        UIButton *touchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        touchButton.frame = CGRectMake(0, 0, 300, 40);
        //        touchButton.backgroundColor = [UIColor yellowColor];
        
        touchButton.tag = i;
        UIImageView * buttonImageview = [[UIImageView alloc]init];
        buttonImageview.tag = i;
        //        [button setTitle:title forState:UIControlStateNormal];
        buttonImageview.frame = CGRectMake(115.0, 0.f, 42, 42);
        
        if (SCREEN_WIDTH > 400) {
            view1.frame = CGRectMake(280, 80, 320, 40);
            touchButton.frame = CGRectMake(0, 0, 320, 40);
            buttonImageview.frame = CGRectMake(118, 0, 50, 50);
        }
        buttonImageview.clipsToBounds = YES;
        view1.tag = i;
        
        if (view1.tag == 0)
        {
            /// Create button.
            buttonImageview.image = [UIImage imageNamed:SUSPENSION_REQS];
            /// Create lable.
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(-7, 5, 110, 30)];
            if (SCREEN_WIDTH > 400) {
                lab.frame = CGRectMake(-8, 5, 109, 30);
            }
            [lab setText:NSLocalizedString(@"needKey",nil)];
            [lab setTextColor:[UIColor whiteColor]];
            [lab setTextAlignment:NSTextAlignmentRight];
            /// Add button and lable on the view.
            [view1 addSubview:buttonImageview];
            [view1 addSubview:lab];
            [view1 addSubview:touchButton];
            
        }
        else if (view1.tag == 1)
        {
            buttonImageview.image = [UIImage imageNamed:SUSPENSION_SHOWCASE];
            
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
            
            [lab setText:NSLocalizedString(@"caseKey",nil)];
            [lab setTextColor:[UIColor whiteColor]];
            [lab setTextAlignment:NSTextAlignmentRight];
            
            [view1 addSubview:buttonImageview];
            [view1 addSubview:lab];
            [view1 addSubview:touchButton];
            
        }else if (view1.tag == 2)
        {
            buttonImageview.image = [UIImage imageNamed:SUSPENSION_SHOWDESIGNER];
            
            UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 80, 30)];
            
            [lab setText:NSLocalizedString(@"look_for_key",nil)];
            [lab setTextColor:[UIColor whiteColor]];
            [lab setTextAlignment:NSTextAlignmentRight];
            
            [view1 addSubview:buttonImageview];
            [view1 addSubview:lab];
            [view1 addSubview:touchButton];
            
        }
        /// Button to add monitor events.
        [touchButton addTarget:self action:@selector(test:) forControlEvents:UIControlEventTouchUpInside];
        
        /// add view to array.
        [buttonsMutable addObject:view1];
    }
    /// Method returns.
    return buttonsMutable;
}

- (void)login {
    [AppController AppGlobal_ProccessLogin];
}

- (void)test:(UIButton *)sender
{
    if (![AppController AppGlobal_GetLoginStatus] && sender.tag == 0) {
        [AppController AppGlobal_ProccessLogin];
        return;
    };
    
    if (sender.tag == 0) {
        
        if ([IS_BEISHU isEqualToString:@"BEISHU"]) {
            [MPAlertView showAlertWithMessage:@"功能开发中,敬请期待" sureKey:nil];
        } else {
            MPIssueDemandViewController *vc = [[MPIssueDemandViewController alloc] initWithType:MPDecorationVCTypeIssue needID:nil refresh:nil];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (sender.tag == 1)
    {
        MPCaseLibraryViewController *caseLibrary = [[MPCaseLibraryViewController alloc] init];
        caseLibrary.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:caseLibrary animated:YES];
    }
    else
    {
        MPFindDesignersViewController *findDesigner = [[MPFindDesignersViewController alloc] init];
        findDesigner.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:findDesigner animated:YES];
    }
    
}

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender translationInView:self.view];
    
    if (point.x>0) {
        
        [self.frostedViewController panGestureRecognized:sender];
    }
}


@end
