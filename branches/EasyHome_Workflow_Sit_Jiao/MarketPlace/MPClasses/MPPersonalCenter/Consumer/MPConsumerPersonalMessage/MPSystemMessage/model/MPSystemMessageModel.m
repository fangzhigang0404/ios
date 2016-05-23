//
//  MPSystemMessageModel.m
//  MarketPlace
//
//  Created by xuezy on 16/3/18.
//  Copyright © 2016年 xuezy. All rights reserved.
//

#import "MPSystemMessageModel.h"
#import "MPChatHttpManager.h"
#import "MPDateUtility.h"

@implementation MPSystemMessageModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    
    self=[super init];
    
    if (self) {
        
//添加消息中心数据格式及数据
        
//        NSDictionary * latest_dict = [[NSDictionary alloc]initWithDictionary:dict[@"latestMessage"]];
        
        
        NSDate* sendDate = [MPChatHttpManager acsDateToNSDate:[NSString stringWithFormat:@"%@",dict[@"sent_time"]]];
        NSString* timeString = [MPDateUtility formattedStringFromDateForMessage:sendDate];
        self.sent_time = timeString;
        self.body =[dict[@"body"] stringByReplacingOccurrencesOfString:@"&quot;"withString:@"\""];
        NSData *data = [self.body dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingMutableContainers
                                                              error:&error];
     
        if  ([AppController AppGlobal_GetIsDesignerMode])
        {
            self.body = dic[@"for_designer"];
            
        }else{
            self.body = dic[@"for_consumer"];
        }
        
        self.needsID =    [[NSString stringWithFormat:@"%@",dic[@"need_id"]] integerValue];
        self.designerID = [[NSString stringWithFormat:@"%@",dic[@"designer_id"]] integerValue];
        self.subNodeID =  [[NSString stringWithFormat:@"%@",dic[@"sub_node_id"]] integerValue];
    
    }
    
    return self;
}

+ (instancetype)demandWithDict:(NSDictionary *)dict {
    
    return [[MPSystemMessageModel alloc]initWithDict:dict];
}

+(void)createStystemMessage:(NSDictionary *)parametDict success:(void (^)(NSMutableArray* array))success failure:(void(^) (NSError *error))failure {
    [MPAPI PostPersonalMessageMemberIDWithSucces:^(NSDictionary *thread_id)
     {
         
     
         NSString * innetID =[thread_id objectForKey:@"im_msg_thread_id"];//修改inner为IM
         [MPAPI GetPerSonalMessageMemberIDWithThreadID:innetID withParameters:parametDict WithSucces:^(NSDictionary *messages)
          {

              NSMutableArray *resultArray=[[NSMutableArray alloc] init];
              NSArray *arr = [NSArray arrayWithArray:messages[@"messages"]];
              
              for (NSDictionary *designersDict in arr)
                [resultArray addObject:[MPSystemMessageModel demandWithDict:designersDict]];
   
              if (success) {
                  success(resultArray);
              }

          }failure:^(NSError *error)
          {
              if (failure) {
                  failure(error);
              }
              
          }];
     } failure:^(NSError *error)
     {
         if (failure) {
             failure(error);
         }

     }];

}


@end
