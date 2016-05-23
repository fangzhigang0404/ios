/**
 * @file    MPDesignerMessageDetailViewController.h
 * @brief   the view of MPConsumerCenterMessage view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */
#import "MPBaseViewController.h"

@interface MPDesignerMessageDetailViewController : MPBaseViewController

/// Mask the view.
@property (strong,nonatomic)UIView *maskView;
/// provice attribute.
@property (copy,nonatomic)NSString *provice;
/// city attribute.
@property (copy,nonatomic)NSString *city;
/// district attribute.
@property (copy,nonatomic)NSString *district;
/// provice_name attribute.
@property (copy,nonatomic)NSString *provice_name;
/// city_name attribute.
@property (copy,nonatomic)NSString *city_name;
/// district_name attribute.
@property (copy,nonatomic)NSString *district_name;
@end
