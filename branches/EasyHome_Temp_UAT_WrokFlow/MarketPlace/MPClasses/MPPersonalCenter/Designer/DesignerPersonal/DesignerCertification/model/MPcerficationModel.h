/**
 * @file    MPcerficationModel.h
 * @brief   the view of cerfication Model view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */


#import "MPModel.h"

@interface MPcerficationModel : MPModel

/// certification name textField.
@property (nonatomic,retain)UITextField *nameTextField;
/// certification mobile number textField.
@property (nonatomic,retain)UITextField *numberTextField;
/// certification ID card textField.
@property (nonatomic,retain)UITextField *ID_cardTextField;
/// certification ID card positive button.
@property (nonatomic,strong)UIButton *IDcard_positive;
/// certification ID card reverse button.
@property (nonatomic,strong)UIButton *ID_cardReverse;
/// certification ID card handheld button.
@property (nonatomic,strong)UIButton *ID_cardHandheld;
/// certification file_id.
@property (nonatomic,copy)NSString *file_id;
/// certification file_name.
@property (nonatomic,copy)NSString *file_name;
/// certification file_url.
@property (nonatomic,copy)NSString *file_url;
/// certification server.
@property (nonatomic,copy)NSString *server;
/**
 * @brief CertificationWithDictWithDict:(NSDictionary *)dict.
 *
 * @param  dict certifition dictionary.
 *
 * @return void.
 */
+ (instancetype)CertificationWithDictWithDict:(NSDictionary *)dict;
/**
 * @brief CertificationWithUrl:(NSString *)url withFiles:(NSArray *)array withHeader:(NSDictionary *)header.
 *
 * @param  url URL.
 *
 * @param  array files.
 *
 * @param  header head body.
 *
 * @return void.
 */
+ (void)CertificationWithUrl:(NSString *)url withFiles:(NSArray *)array withHeader:(NSDictionary *)header withSuccess:(void(^) (MPcerficationModel *model))success failure:(void(^) (NSError *error))failure;
/**
 * @brief GetServiesStringwithSuccess.
 *
 * @return void.
 */
+ (void)GetServiesStringwithSuccess:(void(^) (MPcerficationModel *model))success failure:(void(^) (NSError *error))failure;
/// check name.
+ (BOOL)checkName:(NSString *)name;
/// check phone.
+ (BOOL)checkPhone:(NSString *)phone;
/// check ID card.
+ (BOOL)checkIDNumber:(NSString *)id_num;

@end
