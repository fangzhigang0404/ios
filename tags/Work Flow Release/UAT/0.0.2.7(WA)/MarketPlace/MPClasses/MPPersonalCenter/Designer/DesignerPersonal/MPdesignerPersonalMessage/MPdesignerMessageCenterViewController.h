/**
 * @file    MPdesignerMessageCenterViewController.h
 * @brief   the view of designer Message Center view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPBaseViewController.h"

@interface MPdesignerMessageCenterViewController : MPBaseViewController
/// mask view.
@property (strong,nonatomic)UIView *maskView;
/// designer center provice.
@property (copy,nonatomic)NSString *provice;
/// designer center city.
@property (copy,nonatomic)NSString *city;
/// designer center district.
@property (copy,nonatomic)NSString *district;
/// designer center provice_name.
@property (copy,nonatomic)NSString *provice_name;
/// designer center city_name.
@property (copy,nonatomic)NSString *city_name;
/// designer center district_name.
@property (copy,nonatomic)NSString *district_name;
@end
