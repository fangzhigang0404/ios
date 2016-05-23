/**
 * @file    MPWKMeasureModel.h
 * @brief   the model of measurement.
 * @author  Shaco(Jiao)
 * @version 1.0
 * @date    2016-02-29
 *
 */

#import "MPModel.h"

@interface MPWKMeasureModel : MPModel

/// the name of consumer at measurement form which consumer filled in.
@property (nonatomic, copy) NSString *contacts_name;

/// the mobile of consumer at measurement form which consumer filled in.
@property (nonatomic, copy) NSString *contacts_mobile;

/// the budget of designe.
@property (nonatomic, copy) NSString *design_budget;

/// the budget of decoration.
@property (nonatomic, copy) NSString *decoration_budget;

/// the type of house.
@property (nonatomic, copy) NSString *house_type;

/// the area of house.
@property (nonatomic, copy) NSString *house_area;

/// the number of living room.
@property (nonatomic, copy) NSString *living_room;

/// the number of room.
@property (nonatomic, copy) NSString *room;

/// the number of toilet.
@property (nonatomic, copy) NSString *toilet;

/// the style of decoration.
@property (nonatomic, copy) NSString *decoration_style;

/// the time of designer going to measure.
@property (nonatomic, copy) NSString *measure_time;

/// the address of province.
@property (nonatomic, copy) NSString *province;

/// the address of city.
@property (nonatomic, copy) NSString *city;

/// the address of district.
@property (nonatomic, copy) NSString *district;

/// the address of community_name.
@property (nonatomic, copy) NSString *community_name;

/// the charge of measurement.
@property (nonatomic, copy) NSString *measurement_fee;

/**
 *  @brief get the model of measurement.
 *
 *  @param dict the dictionary of data.
 *
 *  @return MPWKMeasureModel.
 */
+ (instancetype)getWKMeasureModelWithDict:(NSDictionary *)dict;
@end
