/**
 * @file    MPnameViewController.h
 * @brief   the view of MPnameViewController
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */
#import "MPBaseViewController.h"

@protocol PassTrendValueDelegate <NSObject>
/**
 * @brief passTrendValues:(NSString *)values andtitle:(NSString *)title.
 *
 * @param  value value.
 *
 * @param  title information.
 * @return void.
 */

-(void)passTrendValues:(NSString *)values andtitle:(NSString *)title;
@end

@interface MPnameViewController : MPBaseViewController///修改个人信息name

{
    UITableView *_tableView;  //!< creat tableView.
    
}
/// Returns the value of the.
@property (copy,nonatomic)NSString *titleString;
/// Returns the name of the.
@property (copy,nonatomic)NSString *nameString;
/// Determine gender.
@property (assign, nonatomic) BOOL isSex;
/// self delegate.
@property (retain,nonatomic) id <PassTrendValueDelegate> trendDelegate;

@end
