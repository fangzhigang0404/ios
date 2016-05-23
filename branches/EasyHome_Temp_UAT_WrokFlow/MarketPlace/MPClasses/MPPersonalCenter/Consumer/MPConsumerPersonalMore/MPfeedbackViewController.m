/**
 * @file    MPfeedbackViewController.m
 * @brief   the view of MPfeedbackViewController
 * @author  fu
 * @version 1.0
 * @date    2015-12-30
 */

#import "MPfeedbackViewController.h"

@interface MPfeedbackViewController ()

{
    NSArray *array; //!< arrayy.
}
@end

@implementation MPfeedbackViewController

- (void)tapOnLeftButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"MPfeedbackViewController lounch");
    
    NSString *pathFiled = [[NSBundle mainBundle] pathForResource:@"perSon" ofType:@"plist"];
    array = [NSArray arrayWithContentsOfFile:pathFiled];
    self.view.backgroundColor = [UIColor brownColor];
    //self.tabBarController.tabBar.hidden = YES;
    self.menuLabel.text = array[54];
    self.rightButton.hidden = YES;
    
    /// creat textView.
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10 +64, (SCREEN_WIDTH - 10 * 2), 200)];

    [self.view addSubview:textView];
    /// creat sure button.
    UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 10 +64+30 + 200, (SCREEN_WIDTH - 40 *2), 40)];
    [sureBtn setTitle:array[55] forState:UIControlStateNormal];
    sureBtn.backgroundColor = [UIColor orangeColor];
    [sureBtn addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

// srue button click.
- (void)sureBtnClick:(UIButton *)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
