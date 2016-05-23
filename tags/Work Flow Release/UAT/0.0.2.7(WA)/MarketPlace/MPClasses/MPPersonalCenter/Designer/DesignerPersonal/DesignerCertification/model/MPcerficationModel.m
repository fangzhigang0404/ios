/**
 * @file    MPcerficationModel.m
 * @brief   the view of cerfication Model view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */

#import "MPcerficationModel.h"
#import "MPAPI.h"
@implementation MPcerficationModel
- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];

    if (self) {
        
        self.file_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"file_id"]];
        self.file_name = [NSString stringWithFormat:@"%@",[dict objectForKey:@"name"]];
        self.file_url = [NSString stringWithFormat:@"%@",[dict objectForKey:@"public_url"]];
        self.server = [NSString stringWithFormat:@"%@",[dict objectForKey:@"server"]];

    }
    return self;
}



+ (instancetype)CertificationWithDictWithDict:(NSDictionary *)dict{

    return [[MPcerficationModel alloc]initWithDict:dict];

}

+ (void)CertificationWithUrl:(NSString *)url withFiles:(NSArray *)array withHeader:(NSDictionary *)header withSuccess:(void(^) (MPcerficationModel *model))success failure:(void(^) (NSError *error))failure {
    
    [MPAPI createUploadPhotosWithUrl:url withFiles:array withHeader:header success:^(NSDictionary *dict) {
        NSArray *files = [dict objectForKey:@"files"];
        NSDictionary *dic = files[0];
        MPcerficationModel *model = [MPcerficationModel CertificationWithDictWithDict:dic];
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
+ (void)GetServiesStringwithSuccess:(void(^) (MPcerficationModel *model))success failure:(void(^) (NSError *error))failure {
    [MPAPI uploadPhoto:nil withsuccess:^(NSDictionary *dictionary) {
        
        NSLog(@"dictionary is %@",dictionary);
        
        MPcerficationModel *model = [MPcerficationModel CertificationWithDictWithDict:dictionary];

        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (BOOL)checkName:(NSString *)name {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[\u4e00-\u9fa5]{0,}$"];
    BOOL isMatchName = [predicate evaluateWithObject:name];
    BOOL right =  (name.length >= 2 && name.length <= 10 && isMatchName)?YES:NO;
    return right;
}

+ (BOOL)checkPhone:(NSString *)phone {
    return [self validateMobile:phone];
}

+ (BOOL)checkIDNumber:(NSString *)id_num {
    return [self verifyIDCardNumber:id_num];
}

+ (BOOL)verifyIDCardNumber:(NSString *)value {
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([value length] != 18) {
        return NO;
    }
    NSString *mmdd = @"(((0[13578]|1[02])(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)(0[1-9]|[12][0-9]|30))|(02(0[1-9]|[1][0-9]|2[0-8])))";
    NSString *leapMmdd = @"0229";
    NSString *year = @"(19|20)[0-9]{2}";
    NSString *leapYear = @"(19|20)(0[48]|[2468][048]|[13579][26])";
    NSString *yearMmdd = [NSString stringWithFormat:@"%@%@", year, mmdd];
    NSString *leapyearMmdd = [NSString stringWithFormat:@"%@%@", leapYear, leapMmdd];
    NSString *yyyyMmdd = [NSString stringWithFormat:@"((%@)|(%@)|(%@))", yearMmdd, leapyearMmdd, @"20000229"];
    NSString *area = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|82|[7-9]1)[0-9]{4}";
    NSString *regex = [NSString stringWithFormat:@"%@%@%@", area, yyyyMmdd  , @"[0-9]{3}[0-9Xx]"];
    
    NSPredicate *regexTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![regexTest evaluateWithObject:value]) {
        return NO;
    }
    int summary = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7
    + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9
    + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10
    + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5
    + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8
    + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4
    + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2
    + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6
    + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
    NSInteger remainder = summary % 11;
    NSString *checkBit = @"";
    NSString *checkString = @"10X98765432";
    checkBit = [checkString substringWithRange:NSMakeRange(remainder,1)];// 判断校验位
    return [checkBit isEqualToString:[[value substringWithRange:NSMakeRange(17,1)] uppercaseString]];
}

+ (BOOL)validateMobile:(NSString *)mobile
{
    if (mobile.length <= 0) {
        return NO;
    }
    NSString *phoneRegex = @"1[3|5|7|8|][0-9]{9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

@end
