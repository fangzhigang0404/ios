/**
 * @file    MPmessageViewController.m
 * @brief   the view of MPmessageViewController
 * @author  fu
 * @version 1.0
 * @date    2015-12-25
 */
#import "MPmessageViewController.h"
#import "AppController.h"
#import "MPAPI.h"
#import "MPMessageViewControllercell.h"
@interface MPmessageViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UITableView *tableView;
    NSArray *array;
    NSMutableArray * Data;
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
    
    UINib *chatNib = [UINib nibWithNibName:@"MPMessageViewControllercell" bundle:[NSBundle bundleForClass:[MPMessageViewControllercell class]]];
    [tableView registerNib:chatNib forCellReuseIdentifier:RCellIdentifier];
    
    [AppController AppGlobal_GetMemberInfoObj];
    [self loadData];
    Data  = [[NSMutableArray alloc]init];
    // Do any additional setup after loading the view.
    NSString *pathFiled = [[NSBundle mainBundle] pathForResource:@"perSon" ofType:@"plist"];
    array = [NSArray arrayWithContentsOfFile:pathFiled];
    self.view.backgroundColor = [UIColor orangeColor];
    //self.tabBarController.tabBar.hidden = YES;
    self.menuLabel.text = array[16];
    self.menuLabel.textColor = [UIColor blackColor];
    self.menuLabel.font = [UIFont systemFontOfSize:16];
    self.menuLabel.textAlignment = NSTextAlignmentCenter;
    self.menuLabel.hidden= NO;
    self.rightButton.hidden = YES;
    
    
    
    /// Initialize the UITableView.
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
//    UIView *heardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    tableView.tableHeaderView = heardView;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
//    [heardView addSubview:label];
//    label.text = array[42];
    label.textAlignment = NSTextAlignmentCenter;
    tableView.sectionFooterHeight = 1;
    tableView.sectionHeaderHeight = 20;
    [self.view addSubview:tableView];
}

-(void)loadData
{
    
    [[MPAPI shareAPIManager] PostPersonalMessageMemberIDWithSucces:^(NSDictionary *thread_id)
     {
         NSString * innetID =[thread_id objectForKey:@"inner_sit_msg_thread_id"];
         [[MPAPI shareAPIManager] GetPerSonalMessageMemberIDWithThreadID:innetID WithSucces:^(NSDictionary *messages)
          {
            Data = [messages objectForKey:@"messages"];
              
              [tableView reloadData];
              
          }failure:^(NSError *error)
          {
              
          }];
     }
    failure:^(NSError *error)
     {
         
     }];
}


#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return Data.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section

{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    UILabel *lab_Date = [[UILabel alloc]initWithFrame:CGRectMake(-20, 10, SCREEN_HEIGHT, 15)];
    
    if(![[Data[indexPath.row]objectForKey:@"read_time"] isEqual:@""])
        {
            [Data[indexPath.row]objectForKey:@"read_time"];
        }else
        {
                 lab_Date.text = @"未收到時間參數";
        }
    
        lab_Date.textAlignment = NSTextAlignmentCenter;

    cell.textLabel.text = [Data[indexPath.row]objectForKey:@"body"];;
    
    [cell addSubview:lab_Date];
    
//        CGSize boundSize = CGSizeMake(216, CGFLOAT_MAX);

//        cell.userInteractionEnabled = NO;
    
//        CGSize requiredSize = [cell.textLabel.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:boundSize lineBreakMode:UILineBreakModeWordWrap];
//    
//            CGRect rect = cell.frame;
//        rect.size.height = requiredSize.height+40;
//        cell.frame = rect;  
//        cell.textLabel.numberOfLines = 0;
    return cell;

}
- (CGFloat)tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
       UITableViewCell *cell = [self tableView:tableView1 cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell height %f",cell.frame.size.height);
    
    return cell.frame.size.height;
}

@end
