/**
 * @file    MPcerficationInformationModel.h
 * @brief   the view of cerficationInformation Model view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */


#import "MPModel.h"

@interface MPcerficationInformationModel : MPModel



@property (nonatomic,copy)NSString *audit_status;
/**
 * @brief CertificationWithDictWithDict:(NSDictionary *)dict.
 *
 * @param  dict cercifition dictionary.
 *
 * @return void.
 */
+ (instancetype)CertificationWithDictWithDict:(NSDictionary *)dict;
/**
 * @brief CertificationMemberid:(NSString *)memberid withHeader:(NSDictionary *)header.
 *
 * @param  memberid member id.
 *
 * @param  header dictionary body.
 *
 * @return void.
 */
+ (void)CertificationMemberid:(NSString *)memberid withHeader:(NSDictionary *)header withSuccess:(void(^) (MPcerficationInformationModel *model))success failure:(void(^) (NSError *error))failure;
/**
 * @brief updataGetdesignersInformation:(NSString *)memberid withParam:(NSDictionary *)param withRequestHeard:(NSDictionary *)dic.
 *
 * @param  memberid member id.
 *
 * @param  param dictionary body.
 *
 * @param  dic dictionary body.
 *
 * @return void.
 */
+ (void)updataGetdesignersInformation:(NSString *)memberid withParam:(NSDictionary *)param withRequestHeard:(NSDictionary *)dic withSuccess:(void(^) (MPcerficationInformationModel *model))success failure:(void(^) (NSError *error))failure;
/**
 * @brief updataCerInformation:(NSString *)member_id withParam:(NSDictionary *)dic withRequestHeard:(NSDictionary *)heard.
 *
 * @param  memberid member id.
 *
 * @param  heard dictionary body.
 *
 * @param  dic dictionary body.
 *
 * @return void.
 */
+ (void)updataCerInformation:(NSString *)member_id withParam:(NSDictionary *)dic withRequestHeard:(NSDictionary *)heard withSuccess:(void(^) (MPcerficationInformationModel *model))success failure:(void(^) (NSError *error))failure;
/**
 * @brief updataCerInformation:(NSString *)member_id withParam:(NSDictionary *)dic withRequestHeard:(NSDictionary *)heard.
 *
 * @param  URl URL.
 *
 * @param  headerdict dictionary body.
 *
 * @param  dict dictionary body.
 *
 * @return void.
 */
+ (void)UploadRealNameAuthenticationWith:(NSString *)URl Withparam:(NSDictionary *)dict WithHeader:(NSDictionary *)headerdict withSuccess:(void(^) (MPcerficationInformationModel *model))success failure:(void(^) (NSError *error))failure;
@end
