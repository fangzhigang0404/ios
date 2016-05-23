//
//  MPBaseViewController.h
//  MarketPlace
//
//  Created by xuezy on 15/12/16.
//  Copyright © 2015年 xuezy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REFrostedViewController.h"
#import "MBProgressHUD.h"
#import "MJRefresh.h"
#import "MPAlertView.h"
#import "AppController.h"
#import "MPTranslate.h"
#import "MPChatHttpManager.h"

@interface MPBaseViewController : UIViewController

/// The navigation bar view.
@property (strong,nonatomic)UIImageView *navgationImageview;

/// The navigation bar on the left Label.
@property (strong,nonatomic)UILabel *menuLabel ;

/// The navigation bar on the left button.
@property (strong,nonatomic)UIButton *leftButton;

/// The navigation bar on the left button.
@property (strong,nonatomic)UIButton *rightButton;

/// The navigation bar TitleLabel.
@property (strong,nonatomic)UILabel *titleLabel ;

/// supplementory button on right side of image
/// by default it is hidden
@property (strong,nonatomic)UIButton *supplementaryButton;

/// the block for load new data.
@property (nonatomic, copy) void (^refreshForLoadNew)();
/// the block for load more data.
@property (nonatomic, copy) void (^refreshForLoadMore)();

/**
 * @brief Hide pull refresh, drop - loaded view.
 *
 * @param isLoadMore isload more or not.
 *
 * @return void nil.
 */
- (void)endRefreshView:(BOOL)isLoadMore;

/**
 * @brief  Execution method by clicking on the navigation bar on the left button,
 *  can in subclasses override this method to realize the required functions.
 *
 * @return void nil.
 */
- (void)tapOnLeftButton:(id)sender;



- (void)tapOnRightButton:(id)sender;
/**
 * @brief The sliding view hide the navigation bar.
 *
 * @param scrollableView The sliding View.
 *
 * @return void nil.
 */
- (void)followScrollView:(UIView*)scrollableView;

- (void)customPushViewController:(UIViewController *)controller animated:(BOOL)animated;


/**
 @brief This method to create and show bubble on right bar button on navigation bar
 */

- (void) updateBubbleWithUnreadCount:(NSUInteger)count;

- (NSString *)stringTypeChineseToEnglishWithString:(NSString *)string;
@end
