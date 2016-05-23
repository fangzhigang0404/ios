/**
 * @file    MPmessageViewController.m
 * @brief   the view of MPmessageViewController
 * @author  fu
 * @version 1.0
 * @date    2015-12-25
 */
#import "MPmessageViewController.h"
//#import "AppController.h"
//#import "MPAPI.h"
//#import "MPMessageViewControllercell.h"
#import "MPSystemMessaggeView.h"
#import "MPSystemMessageModel.h"
#import "MPStatusMachine.h"
@interface MPmessageViewController ()<MPSystemMessageViewDelegate>
{
//    UITableView *tableView;
//    NSArray *array;
//    NSMutableArray * Data;
    
    
    MPSystemMessaggeView *_systemMessageView;
    NSMutableArray *_arrayDS;
    NSInteger _offset;
    NSInteger _limit;
    BOOL _isLoadMore;

}

@end
static NSString * const RCellIdentifier = @"MPMessageViewControllercell";
@implementation MPmessageViewController

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBar];
    [self initData];
    [self initUI];

}
- (void)initBar {
    //self.tabBarController.tabBar.hidden = YES;
    self.menuLabel.hidden = YES;
    self.rightButton.hidden = YES;
    self.titleLabel.text = @"消息中心";
}

- (void)initUI {
    _systemMessageView = [[MPSystemMessaggeView alloc] initWithFrame:CGRectMake(0, NAVBAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-NAVBAR_HEIGHT)];
    _systemMessageView.delegate = self;
    [self.view addSubview:_systemMessageView];
}

- (void)initData {
    _arrayDS = [NSMutableArray array];
    _limit = 10;
    _offset = 0;
}

- (void)requestData {
    WS(weakSelf);
    [MPSystemMessageModel createStystemMessage:@{@"limit":@(_limit),@"offset":@(_offset)}  success:^(NSArray *array) {
        
        if (!_isLoadMore)
            [_arrayDS removeAllObjects];

        
        [weakSelf endRefreshView:_isLoadMore];
        [_arrayDS addObjectsFromArray:array];
        
//        for (int i = 1 ; i<=[array count]; i++) {
//            if ([array objectAtIndex:i] == 0) {
//            }
//            
//        }
        
        [_systemMessageView refreshSystemMessageUI];
        
        
    } failure:^(NSError *error) {
        
        [weakSelf endRefreshView:_isLoadMore];
        [MPAlertView showAlertForNetError];
        NSLog(@"%@",error);
    }];
    
    
}

#pragma mark - MPFindDesignersViewDelegate methods

- (NSInteger) getSystemMessageCellCount {
    return [_arrayDS count];
}

- (void)didSelectItemAtIndex:(NSInteger)index {
// 是否有点击跳转效果。待定
//    MPSystemMessageModel *model = _arrayDS[index];
// 
//    [MPStatusMachine mpPerformCurrentEventWithController:self
//                                             withNeedsID:[NSString stringWithFormat:@"%ld",(long)model.needsID]
//                                          withDesignerID:[NSString stringWithFormat:@"%ld",(long)model.designerID]
//     
//                                      withDesignerhs_uid:nil
//                                         andCurSubNodeID:[NSString stringWithFormat:@"%ld",(long)model.subNodeID]];
//    
 
}

- (void)systemMessageViewRefreshLoadNewData:(void (^)())finish {
    self.refreshForLoadNew = finish;
    _offset = 0;
    _isLoadMore = NO;
    [self requestData];
}

- (void)systemMessageViewRefreshLoadMoreData:(void (^)())finish {
    self.refreshForLoadMore = finish;
    _offset += _limit;
    _isLoadMore = YES;
    [self requestData];
}

#pragma mark - MPSystemMessageTableViewCellDelegate methods

-(MPSystemMessageModel *) getSystemMessaggeModelForIndex:(NSUInteger) index;
{
    MPSystemMessageModel *model = nil;
    
    if ([_arrayDS count])
        return [_arrayDS objectAtIndex:index];
    
    return model;
}


-(void) startChatWithDesignerForIndex:(NSUInteger) index
{
   
}


-(void) followDesignerForIndex:(NSUInteger) index {
    
}

//-(void)loadData
//{
//    
//    [[MPAPI shareAPIManager] PostPersonalMessageMemberIDWithSucces:^(NSDictionary *thread_id)
//     {
//         NSString * innetID =[thread_id objectForKey:@"inner_sit_msg_thread_id"];
//         [[MPAPI shareAPIManager] GetPerSonalMessageMemberIDWithThreadID:innetID WithSucces:^(NSDictionary *messages)
//          {
//            Data = [messages objectForKey:@"messages"];
//              
//              [tableView reloadData];
//              
//          }failure:^(NSError *error)
//          {
//              
//          }];
//     }
//    failure:^(NSError *error)
//     {
//         
//     }];
//}
//
//
//#pragma mark -- UITableViewDelegate
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return Data.count;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
//
//{
//    return nil;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSString *identifier = @"cell";
//    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//
//    UILabel *lab_Date = [[UILabel alloc]initWithFrame:CGRectMake(-20, 10, SCREEN_HEIGHT, 15)];
//    
//    if(![[Data[indexPath.row]objectForKey:@"read_time"] isEqual:@""])
//        {
//            [Data[indexPath.row]objectForKey:@"read_time"];
//        }else
//        {
//                 lab_Date.text = @"未收到時間參數";
//        }
//    
//        lab_Date.textAlignment = NSTextAlignmentCenter;
//
//    cell.textLabel.text = [Data[indexPath.row]objectForKey:@"body"];;
//    
//    [cell addSubview:lab_Date];
//    
////        CGSize boundSize = CGSizeMake(216, CGFLOAT_MAX);
//
////        cell.userInteractionEnabled = NO;
//    
////        CGSize requiredSize = [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:boundSize lineBreakMode:UILineBreakModeWordWrap];
////    
////            CGRect rect = cell.frame;
////        rect.size.height = requiredSize.height+40;
////        cell.frame = rect;  
////        cell.textLabel.numberOfLines = 0;
//    return cell;
//
//}
//- (CGFloat)tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//       UITableViewCell *cell = [self tableView:tableView1 cellForRowAtIndexPath:indexPath];
//    
//    NSLog(@"cell height %f",cell.frame.size.height);
//    
//    return cell.frame.size.height;
//}

@end
