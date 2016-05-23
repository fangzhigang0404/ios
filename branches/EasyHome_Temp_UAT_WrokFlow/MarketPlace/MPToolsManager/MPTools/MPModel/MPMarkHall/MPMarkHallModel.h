/**
 * @file    MPMarkHallModel.h
 * @brief   mark hall the data model.
 * @author  Xue
 * @version 1.0
 * @date    2016-01-13
 */

#import <Foundation/Foundation.h>
#import "MPModel.h"
/// the model of mark hall data.
@interface MPMarkHallModel : MPModel
/// Good at space.
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
@property (strong, nonatomic)NSString *renovation_style;

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

@property (strong, nonatomic)NSString *is_public;
@property (strong ,nonatomic)NSString *detail_desc;
@property (copy,nonatomic)NSString *after_bidding_status;
@property (copy,nonatomic)NSString *design_budget;
@property (copy,nonatomic)NSArray *bidders;


-(instancetype)initWithDict:(NSDictionary *)dict;

+(instancetype)demandWithDict:(NSDictionary *)dict;

/// mark hall.
+(void)createMarkHallWithOffset:(NSString *)offset withLimit:(NSString *)limit success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure;
/// mark detail.
+(void)createMarkDetailWithNeedId:(NSString *)needId success:(void (^)(MPMarkHallModel* model))success failure:(void(^) (NSError *error))failure;
@end
