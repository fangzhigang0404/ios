/**
 * @file    MPSearchResultViewController.m
 * @brief   Search result the viewcontroller.
 * @author  Xue.
 * @version 1.0.
 * @date    2015-12-15.
 */

#import "MPSearchResultViewController.h"

@interface MPSearchResultViewController ()

@end

@implementation MPSearchResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.navgationImageview.hidden = YES;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"Entering:%@",searchController.searchBar.text);
    
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
