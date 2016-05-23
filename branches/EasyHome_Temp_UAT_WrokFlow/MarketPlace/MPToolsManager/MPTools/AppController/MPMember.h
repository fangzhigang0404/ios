//
//  MPMember.h
//  MarketPlace
//
//  Created by Franco Liu on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MPMember : NSObject

+ (MPMember *)shareMember;

- (instancetype)SetWithDict:(NSDictionary *)dict;

@property (strong, nonatomic)NSString *memberType;
@property (strong, nonatomic)NSString *member_id;
@property (strong, nonatomic)NSString *x_token;
@property (strong, nonatomic)NSString *acs_x_session;
@property (strong, nonatomic)NSString *guid;
@property (strong, nonatomic)NSString *acs_member_id;
@property (strong, nonatomic)NSString *mobile_number;
@property (strong, nonatomic)NSString *nick_name;
@property (strong, nonatomic)NSString *X_Token;
@property (strong, nonatomic)NSString *ACS_Token;
@property (strong, nonatomic)NSString *hs_uid;
@property (strong, nonatomic)NSString *System_thread_id;
@property (strong, nonatomic)NSString *System_im_thread_id;


//"acs_token" = "J26.I0Y1MKs4F7nAGl8FzTCxP42AvqRkqkDMi4UAcM9T9rKD”;

//"hs_accesstoken" = "1fc3aaae-19cc-480f-a133-21d0654d7621";


-(void) MemberSetLoginStatus:(BOOL) status;
-(BOOL) MemberGetLoginStatus;
-(BOOL) MemberIsDesignerMode; 


-(void)System_im_thread_id:(NSString *)thread_id;
-(void)System_thread_id:(NSString *)thread_id;
-(BOOL) iSMemberCompareSysThread:(NSString *)thread_id;


@end
