//
//  MPDesignerBankInfo.m
//  MarketPlace
//
//  Created by Jiao on 16/2/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPDesignerBankInfo.h"
#import "MPAPI.h"

@implementation MPDesignerBankInfo
- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.member_id = [NSString stringWithFormat:@"%@",[self judgeNULL:dict[@"member_id"]]];
        self.account_user_name = [NSString stringWithFormat:@"%@",[self judgeNULL:dict[@"account_user_name"]]];
        self.bank_name = [NSString stringWithFormat:@"%@",[self judgeNULL:dict[@"bank_name"]]];
        self.branch_bank_name = [NSString stringWithFormat:@"%@",[self judgeNULL:dict[@"branch_bank_name"]]];
        self.deposit_card = [NSString stringWithFormat:@"%@",[self judgeNULL:dict[@"deposit_card"]]];
        self.amount = [self moneyFormat:dict[@"amount"]];
    }
    return self;
}

+ (instancetype)bankInfoWithDict:(NSDictionary *)dict {
    return [[MPDesignerBankInfo alloc]initWithDict:dict];
}

+ (void)getDesignerBankInfo:(void(^)(MPDesignerBankInfo *))success
                andFailure :(void(^)(NSError *error))failure {
    
    NSDictionary *headerDict = [self getHeaderAuthorization];
    
    [MPAPI getDesignersBankInfoWithDesignerID:[self GetMemberID] withHeader:headerDict andSuccess:^(NSDictionary *dict) {
        MPDesignerBankInfo *model = [MPDesignerBankInfo bankInfoWithDict:dict];
        if (success) {
            success(model);
        }
    } andFailure:^(NSError *error) {
        NSLog(@"获取设计师银行卡信息失败");
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)withdrawWithModel:(MPDesignerBankInfo *)model
              withSuccess:(void(^)(NSString *))success
              withFailure:(void(^)(NSError *))failure {
    
//    model.deposit_card = [MPDesignerBankInfo formatStr:model.deposit_card];
    model.member_id = [self GetMemberID];

    
    [MPAPI putDesignersWithdraw:model.member_id withParameter:@{@"account_user_name":model.account_user_name,@"bank_name":model.bank_name,@"branch_bank_name":model.branch_bank_name,@"deposit_card":model.deposit_card} withSuccess:^(NSDictionary *dict) {
        if (success) {
            success(dict[@"result"]);
        }

    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }

    }];
}

#pragma mark - String format
- (id)judgeNULL:(id)obj {
    if ([obj isKindOfClass:[NSNull class]]) {
        return @"";
    }
    return obj;
}

//- (NSString *)moneyFormat:(NSNumber *)num {
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//    NSString *string = [formatter stringFromNumber:num];
//    NSLog(@"%@",string);
//    return string;
//}

- (NSString *)description {
    return [NSString stringWithFormat:@"member_id:%@, account_user_name:%@, bank_name:%@, branch_bank_name:%@, deposit_card:%@, amount:%@",self.member_id, self.account_user_name, self.bank_name, self.branch_bank_name, self.deposit_card, self.amount];
}
- (NSString *)moneyFormat:(NSNumber *)num {
    if (!num) {
        return @"¥ 0.00";
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSMutableString *string = [NSMutableString stringWithString:[formatter stringFromNumber:num]];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSInteger loc = [string rangeOfCharacterFromSet:characterSet].location;
    NSString *resultStr = [NSString stringWithFormat:@"¥ %@",[string substringFromIndex:loc]];
    return resultStr;
}

@end
