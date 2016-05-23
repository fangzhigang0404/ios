//
//  MPMember.m
//  MarketPlace
//
//  Created by Franco Liu on 16/2/17.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPMember.h"

@implementation MPMember

/// singleton.
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static MPMember * manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [super allocWithZone:zone];
    });
    
    return manager;
}

+ (MPMember *)shareMember {
    return [[self alloc] init];
}

- (instancetype)init {
  
    self = [super init];
    if (self) {
        if  (_memberType == nil)
            _memberType=[[NSString alloc]init];
        
        if  (_member_id == nil)
            _member_id=[[NSString alloc]init];

        if  (_x_token == nil)
            _x_token=[[NSString alloc]init];

        if  (_acs_x_session == nil)
            _acs_x_session=[[NSString alloc]init];

        if  (_guid == nil)
            _guid=[[NSString alloc]init];
        
        if  (_acs_member_id == nil)
            _acs_member_id=[[NSString alloc]init];
        
        if  (_mobile_number == nil)
            _mobile_number=[[NSString alloc]init];
        
        if  (_X_Token == nil)
            _nick_name=[[NSString alloc]init];
        
        if  (_X_Token == nil)
            _X_Token=[[NSString alloc]init];
        
        if  (_nick_name == nil)
            _ACS_Token=[[NSString alloc]init];
        
        if (_hs_uid == nil) {
            _hs_uid = [[NSString alloc] init];
        
        if (_System_thread_id == nil)
            _System_thread_id = [[NSString alloc] init];
                
        if (_System_im_thread_id == nil)
            _System_im_thread_id = [[NSString alloc] init];
            
        }
        
    }
    return self;
}

    
    
- (instancetype)SetWithDict:(NSDictionary *)dict {
    
    NSString *strVal;
   
    if (self) {
        strVal=dict[@"member_type"];
        _memberType=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_memberType forKey:@"member_type"];
        
        strVal=dict[@"member_id"];
        _member_id=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_member_id forKey:@"member_id"];
        
        strVal=dict[@"token"];
        _x_token=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_x_token forKey:@"x_token"];
        
        
        strVal=dict[@"acs_x_session"];
        _acs_x_session=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_acs_x_session forKey:@"acs_x_session"];
        
        
        strVal=dict[@"guid"];
        _guid=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_guid forKey:@"guid"];
        
        strVal=dict[@"acs_member_id"];
        _acs_member_id=(strVal!=nil)?(strVal):(@"");
        
        
        while (_acs_member_id.length<8) {
            
            _acs_member_id=[NSString stringWithFormat:@"%@0",_acs_member_id];
        }
       
        
        [[NSUserDefaults standardUserDefaults] setObject:_acs_member_id forKey:@"acs_member_id"];
        
        strVal=dict[@"mobile_number"];
        _mobile_number=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_mobile_number forKey:@"mobile_number"];
        
        strVal=dict[@"nick_name"];
        _nick_name=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_nick_name forKey:@"nick_name"];
        
        strVal=dict[@"acs_token"];
        _ACS_Token=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_ACS_Token forKey:@"acs_token"];

        
        strVal=dict[@"hs_accesstoken"];
        _X_Token=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_X_Token forKey:@"hs_accesstoken"];

        strVal=dict[@"hs_uid"];
        _hs_uid=(strVal!=nil)?(strVal):(@"");
        [[NSUserDefaults standardUserDefaults] setObject:_hs_uid forKey:@"hs_uid"];
        
      
        
    }
    
    return self;
}

- (NSString *)hs_uid {
    
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"hs_uid"];
    if (str != nil) {
        _hs_uid = str;
    }
    return _hs_uid;
}


- (NSString *)memberType {
    
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"member_type"];
    if (str != nil) {
        _memberType = str;
    }
    return _memberType;
}

-(NSString *)member_id{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"member_id"];
    if (str != nil) {
        _member_id = str;
    }
    return _member_id;
}

-(NSString *)x_token{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"x_token"];
    if (str != nil) {
        _x_token = str;
    }
    return _x_token;
}

-(NSString *)acs_x_session{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"acs_x_session"];
    if (str != nil) {
        _acs_x_session = str;
    }
    return _acs_x_session;
    
}

-(NSString *)guid{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"guid"];
    if (str != nil) {
        _guid = str;
    }
    return _guid;
}

-(NSString *)acs_member_id{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"acs_member_id"];
    if (str != nil) {
        _acs_member_id = str;
    }
    return _acs_member_id;
}

-(NSString *)mobile_number{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"mobile_number"];
    if (str != nil) {
        _mobile_number = str;
    }
    return _mobile_number;
}

-(NSString *)nick_name{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"nick_name"];
    if (str != nil) {
        _nick_name = str;
    }
    return _nick_name;
}

-(NSString *)X_Token{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"hs_accesstoken"];
    if (str != nil) {
        _X_Token = str;
    }
    return _X_Token;
}

-(NSString *)ACS_Token{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"acs_token"];
    if (str != nil) {
        _ACS_Token = str;
    }
    return _ACS_Token;
}

-(void)System_im_thread_id:(NSString *)thread_id{
    
      // NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([thread_id isKindOfClass:[NSNull class]]) {
        thread_id = @"";
    }
    
     [[NSUserDefaults standardUserDefaults] setObject:thread_id forKey:@"system_im_thread_id"];
     //[defaults setObject:thread_id forKey:@"system_thread_id"];
    //[defaults synchronize];
}
-(void)System_thread_id:(NSString *)thread_id{
    
    // NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([thread_id isKindOfClass:[NSNull class]]) {
        thread_id = @"";
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:thread_id forKey:@"system_thread_id"];
    
    //[defaults setObject:thread_id forKey:@"system_im_thread_id"];
    //[defaults synchronize];
}



-(NSString *)System_thread_id{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"system_thread_id"];
    if (str != nil) {
        _System_thread_id = str;
    }
    return _System_thread_id;
}

-(NSString *)System_im_thread_id{
    NSString *str=[[NSUserDefaults standardUserDefaults] objectForKey:@"system_im_thread_id"];
    if (str != nil) {
        _System_im_thread_id = str;
    }
    return _System_im_thread_id;
}


-(void) MemberSetLoginStatus:(BOOL) status {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:(status==YES)?(@"YES"):(@"NO")  forKey:@"SignIn"];
}


-(BOOL) MemberGetLoginStatus {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString* str=[userDefaults objectForKey:@"SignIn"];
    
    if (str==nil)
        return NO;
    
    return ([str isEqualToString:@"YES"])?(YES):(NO);
}

-(BOOL) MemberIsDesignerMode {
    
    
    if ([self MemberGetLoginStatus]!=YES)
        return NO;
    
    return ([self.memberType isEqualToString:@"designer"])?(YES):(NO);
}


-(BOOL) iSMemberCompareSysThread:(NSString *)thread_id {
    
    
    //NSString * reciver_id = self.threadId;
    if ([thread_id isEqualToString:self.System_thread_id]||[thread_id isEqualToString:self.System_im_thread_id])
         return YES;
        
        
     return NO;
}



@end
