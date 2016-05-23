/**
 * @file    MPcerficationInformationModel.m
 * @brief   the view of cerficationInformation Model view.
 * @author  fu
 * @version 1.0
 * @date    2015-12-29
 */


#import "MPcerficationInformationModel.h"

@implementation MPcerficationInformationModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
        
        self.audit_status = [NSString stringWithFormat:@"%@",[dict objectForKey:@"audit_status"]];
     
    }
    return self;
}



+ (instancetype)CertificationWithDictWithDict:(NSDictionary *)dict{
    
    return [[MPcerficationInformationModel alloc] initWithDict:dict];
    
}
+ (void)CertificationMemberid:(NSString *)memberid withHeader:(NSDictionary *)header withSuccess:(void(^) (MPcerficationInformationModel *model))success failure:(void(^) (NSError *error))failure {
    
    [MPAPI getDesignersCerInformation:memberid withRequestHeard:header witSuccess:^(NSDictionary *dict) {
        
        NSLog(@"dict is ###################%@",dict);
        MPcerficationInformationModel *model = [MPcerficationInformationModel CertificationWithDictWithDict:dict];
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
+ (void)updataGetdesignersInformation:(NSString *)memberid withParam:(NSDictionary *)param withRequestHeard:(NSDictionary *)dic withSuccess:(void(^) (MPcerficationInformationModel *model))success failure:(void(^) (NSError *error))failure {
    
    [MPAPI updataGetdesignersInformation:memberid withParam:param withRequestHeard:dic witSuccess:^(NSDictionary *dict) {
        NSLog(@"dict is -----------------%@",dict);
        MPcerficationInformationModel *model = [MPcerficationInformationModel CertificationWithDictWithDict:dict];
        if (success) {
            success(model);
        }
       
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
        if (failure) {
            failure(error);
        }
        
    }];
}
+ (void)updataCerInformation:(NSString *)member_id withParam:(NSDictionary *)dic withRequestHeard:(NSDictionary *)heard withSuccess:(void(^) (MPcerficationInformationModel *model))success failure:(void(^) (NSError *error))failure {
    
    
    [MPAPI updataCerInformation:member_id withParam:dic withRequestHeard:heard witSuccess:^(NSDictionary *dict) {
        NSLog(@"dict is -----------------%@",dict);
        MPcerficationInformationModel *model = [MPcerficationInformationModel CertificationWithDictWithDict:dict];

        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
        if (failure) {
            failure(error);
        }
    }];
    
}
+ (void)UploadRealNameAuthenticationWith:(NSString *)URl Withparam:(NSDictionary *)dict WithHeader:(NSDictionary *)headerdict withSuccess:(void(^) (MPcerficationInformationModel *model))success failure:(void(^) (NSError *error))failure {
    
    [MPAPI UploadRealNameAuthenticationWith:URl Withparam:dict WithHeader:headerdict success:^(NSDictionary *dict) {
        
               
    } failure:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];

}

@end
