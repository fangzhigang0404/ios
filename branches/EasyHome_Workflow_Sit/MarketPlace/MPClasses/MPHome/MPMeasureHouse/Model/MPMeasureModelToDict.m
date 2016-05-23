/**
 * @file    MPMeasureModelToDict.m
 * @brief   the tool of create request body.
 * @author  niu
 * @version 1.0
 * @date    2015-03-24
 */

#import "MPMeasureModelToDict.h"
#import "MPDecorationNeedModel.h"
#import "MPTranslate.h"

@implementation MPMeasureModelToDict

+ (NSDictionary *)getMeasureBodyWithModel:(MPDecorationNeedModel *)model
                              measureDate:(NSString *)date
                               designerId:(NSString *)designer_id
                              mesurePrice:(NSString *)measurePrice
                                   hs_uid:(NSString *)hs_uid
                                 threadID:(NSString *)thread_id {
    
    NSDictionary *parameterDict = @{
                      @"service_date"         : [self noNull:date],
                      @"user_id"              : [self noNull:[MPMember shareMember].acs_member_id],
                      @"contacts_name"        : [self noNull:model.contacts_name],
                      @"contacts_mobile"      : [self noNull:model.contacts_mobile],
                      @"designer_id"          : [self noNull:designer_id],
                      @"order_type"           : @"0",
                      @"amount"               : [self noNull:measurePrice],
                      @"channel_type"         : @"IOS",
                      @"house_type"           : [self noNull:[MPTranslate stringTypeChineseToEnglishWithString:model.house_type]],
                      @"house_area"           : [self noNull:model.house_area],
                      @"decoration_budget"    : [self noNull:model.decoration_budget],
                      @"design_budget"        : [self noNull:model.design_budget],
                      @"decoration_style"     : [self noNull:[MPTranslate stringTypeChineseToEnglishWithString:model.decoration_style]],
                      @"province"             : [self noNull:model.province],
                      @"city"                 : [self noNull:model.city],
                      @"district"             : [self noNull:model.district],
                      @"province_name"        : [self noNull:model.province_name],
                      @"city_name"            : [self noNull:model.city_name],
                      @"district_name"        : [self noNull:model.district_name],
                      @"community_name"       : [self noNull:model.community_name],
                      @"room"                 : [self noNull:[MPTranslate stringTypeChineseToEnglishWithString:model.room]],
                      @"living_room"          : [self noNull:[MPTranslate stringTypeChineseToEnglishWithString:model.living_room]],
                      @"toilet"               : [self noNull:[MPTranslate stringTypeChineseToEnglishWithString:model.toilet]],
                      @"hs_uid"               : [self noNull:hs_uid],
                      @"thread_id"            : (thread_id == nil)?@"":thread_id
                      };

    return parameterDict;
}

+ (NSString *)noNull:(NSString *)str {
    if (str == nil) {
        return @"no date";
    }
    return str;
}

@end
