/**
 * @file    MPCallViewController.m
 * @brief   the controller of call.
 * @author  niu
 * @version 1.0
 * @date    2016-03-29
 */

#import "MPCallViewController.h"
#import "MPAlertView.h"

@interface MPCallViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *callImage;
@property (weak, nonatomic) IBOutlet UILabel *callInfo;

@end

@implementation MPCallViewController

- (void)tapOnLeftButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initNavigationBar];
    
    [self.callImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callphone)]];
    [self.callInfo addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callphone)]];
    
}

- (void)callphone {
    [MPAlertView showAlertWithTitle:nil
                            message:[NSString stringWithFormat:@"%@%@?",NSLocalizedString(@"just_tip_call", nil),@"4006503333"]
                     cancelKeyTitle:NSLocalizedString(@"cancel_Key", nil)
                      rightKeyTitle:NSLocalizedString(@"just_tip_call", nil)
                           rightKey:^{
                               
                               [[UIApplication sharedApplication]
                                openURL:[NSURL URLWithString:
                                         [NSString stringWithFormat:@"tel://%@",@"4006503333"]]];
                               
                           } cancelKey:nil];
}

- (void)initNavigationBar {
    self.titleLabel.text = @"联系方式";
    self.rightButton.hidden = YES;
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
