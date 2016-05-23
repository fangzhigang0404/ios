/**
 * @file    MPDesignerOrderModel.h
 * @brief   order the data model.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-24
 */

#import "MPModel.h"
@class MPStatusModel;
@interface MPDesignerOrderModel : MPModel
@property (strong ,nonatomic)NSString *needName;

/// consumer head portrait.
@property (strong, nonatomic)NSString *headImage;

///Id design demand.
@property (strong, nonatomic)NSString *needs_id;

/// the type of house.
@property (strong, nonatomic)NSString *house_type;

/// room.
@property (strong, nonatomic)NSString *room;

/// living room.
@property (strong, nonatomic)NSString *living_room;

/// toilet.
@property (strong, nonatomic)NSString *toilet;

/// The area of the house.
@property (strong, nonatomic)NSString *house_area;

/// Decorate a style.
@property (strong, nonatomic)NSString *decoration_style;

/// Decorate a budget.
@property (strong, nonatomic)NSString *renovation_budget;

/// province.
@property (strong, nonatomic)NSString *province;

/// city.
@property (strong, nonatomic)NSString *city;

/// district.
@property (strong, nonatomic)NSString *district;

/// neighbourhoods.
@property (strong, nonatomic)NSString *neighbourhoods;

/// Door model figure url.
@property (strong, nonatomic)NSString *img_url;

/// Family name of figure.
@property (strong, nonatomic)NSString *img_name;

/// Release demand time.
@property (strong, nonatomic)NSString *publish_time;

/// Demand state.
@property (strong, nonatomic)NSString *status;

/// contacts mobile.
@property (strong, nonatomic)NSString *contacts_mobile;

/// contacts name.
@property (strong, nonatomic)NSString *contacts_name;

/// The tenderer.
@property (strong, nonatomic)NSString *tendererName;

/// Existing should mark number.
@property (strong, nonatomic)NSString *bidder_count;

@property (copy, nonatomic)NSString *dayNumber;

@property (strong ,nonatomic)NSString *detail_desc;

@property (strong ,nonatomic)NSString *bidding_status;

@property (copy,nonatomic)NSString *is_public;
@property (copy,nonatomic)NSString *workflow_step_id;

@property (nonatomic, copy) NSString *wk_sub_node_id;
@property (nonatomic, copy) NSString *designer_id;

-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)demandWithDict:(NSDictionary *)dict;

+(void)createDesignerOrdersListWithParameters:(NSDictionary *)dictionary success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure;

@end
