/**
 * @file    MPCenterInfo.h
 * @brief   the tool of person center.
 * @author  niu
 * @version 1.0
 * @date    2015-04-07
 */

#import "MPCenterInfo.h"

@implementation MPCenterInfo

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.nick_name forKey:@"nick_name"];
    [encoder encodeObject:self.avatar forKey:@"avatar"];
    [encoder encodeObject:self.is_loho forKey:@"is_loho"];
    [encoder encodeObject:self.hitachi_account forKey:@"hitachi_account"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    [encoder encodeObject:self.mobile_number forKey:@"mobile_number"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.province forKey:@"province"];
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.district forKey:@"district"];
    [encoder encodeObject:self.design_price_max forKey:@"design_price_max"];
    [encoder encodeObject:self.design_price_min forKey:@"design_price_min"];
    [encoder encodeObject:self.measurement_price forKey:@"measurement_price"];
    [encoder encodeObject:self.acount forKey:@"acount"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.nick_name          = [decoder decodeObjectForKey:@"nick_name"];
        self.avatar             = [decoder decodeObjectForKey:@"avatar"];
        self.is_loho            = [decoder decodeObjectForKey:@"is_loho"];
        self.hitachi_account    = [decoder decodeObjectForKey:@"hitachi_account"];
        self.gender             = [decoder decodeObjectForKey:@"gender"];
        self.mobile_number      = [decoder decodeObjectForKey:@"mobile_number"];
        self.email              = [decoder decodeObjectForKey:@"email"];
        self.province           = [decoder decodeObjectForKey:@"province"];
        self.city               = [decoder decodeObjectForKey:@"city"];
        self.district           = [decoder decodeObjectForKey:@"district"];
        self.design_price_max   = [decoder decodeObjectForKey:@"design_price_max"];
        self.design_price_min   = [decoder decodeObjectForKey:@"design_price_min"];
        self.measurement_price  = [decoder decodeObjectForKey:@"measurement_price"];
        self.acount             = [decoder decodeObjectForKey:@"acount"];
    }
    return self;
}

@end
