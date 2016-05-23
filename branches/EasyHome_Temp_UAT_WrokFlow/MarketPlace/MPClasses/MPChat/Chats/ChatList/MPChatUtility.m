//
//  MPChatUtility.m
//  MarketPlace
//
//  Created by Avinash Mishra on 25/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPChatUtility.h"
#import "MPChatThread.h"
#import "MPChatRecipients.h"
#import "MPChatUser.h"
#import "MPChatEntity.h"
#import "MPChatEntityInfos.h"
#import "MPChatEntityInfo.h"
#import "MPChatEntityData.h"
#import "AppController.h"

@implementation MPChatUtility


+ (MPChatUser*) getComplimentryUserFromThread:(MPChatThread*)thread withLoginUserId:(NSString*)loggedInUserId
{
    
    MPChatUser* sysUser=[MPChatUtility IsThereSystemThreadName:thread];
                         
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    
    
    // if this is a system thread , find system member
    if ([member iSMemberCompareSysThread:thread.thread_id])
    {
        if (sysUser!=nil)
            return sysUser;
        
        return thread.sender;
    }
    else{
    
        if (![thread.sender.user_id isEqualToString:loggedInUserId] && ![thread.sender.user_id isEqualToString:ADMIN_USER_ID]){
        
            return thread.sender;
        }
   
    
        for (MPChatUser* user in thread.recipients.users)
        {
            //if (![user.user_id isEqualToString:loggedInUserId])
        
            if (![user.user_id isEqualToString:loggedInUserId] && ![user.user_id isEqualToString:ADMIN_USER_ID])
            return user;
        }
    }
    
    
    if (sysUser!=nil)
        return sysUser;
    
    
    return thread.sender;
}

+ (MPChatUser*) IsThereSystemThreadName:(MPChatThread*)thread
{
    if ([thread.sender.user_id isEqualToString:ADMIN_USER_ID] ){
        
        return thread.sender;
    }
    
    
    for (MPChatUser* user in thread.recipients.users)
    {
        if ([user.user_id isEqualToString:ADMIN_USER_ID])
            
            //if (![user.user_id isEqualToString:loggedInUserId] && ![user.name isEqualToString:Default_SystemUserName])
            return user;
    }
    
    return nil;
}



+ (NSString*) getFileUrlFromThread:(MPChatThread*) thread
{
    NSString* imageURL = nil;
    if (thread.entity.entityInfos.count > 0)
    {
        MPChatEntityInfo* info = [thread.entity.entityInfos firstObject];
        if (info.entity_data.public_file_url)
            imageURL = info.entity_data.public_file_url;
    }
    
    if (!imageURL)
        imageURL = thread.sender.profile_image;
    
    return imageURL;
}


+ (NSString*) getAssetNameFromThread:(MPChatThread*) thread
{
    if (thread.entity.entityInfos.count > 0)
    {
        MPChatEntityInfo* info = [thread.entity.entityInfos firstObject];
        if (info.entity_data.asset_name)
            return info.entity_data.asset_name;
    }
    
    return nil;
}


+ (NSString*) getWorkflowStepNameFromThread:(MPChatThread*) thread
{
    if (thread.entity.entityInfos.count > 0)
    {
        MPChatEntityInfo* info = [thread.entity.entityInfos firstObject];
        if (info.entity_data.workflow_step_name)
            return info.entity_data.workflow_step_name;
    }
    
    return nil;
}


+ (NSString*) getAssetIdFromThread:(MPChatThread*) thread
{
    if (thread.entity.entityInfos.count > 0)
    {
        MPChatEntityInfo* info = [thread.entity.entityInfos firstObject];
        if (info.entity_data.asset_id)
            return [info.entity_data.asset_id stringValue];
    }
    
    return nil;
}


+ (NSString*) getFileEntityIdForThread:(MPChatThread*) thread
{
    if (thread.entity.entityInfos.count > 0)
    {
        for (MPChatEntityInfo* info in thread.entity.entityInfos)
        {
            if (info.entity_type && [info.entity_type isEqualToString:@"FILE"])
                return info.entity_id;
        }
    }
    
    return nil;
}


+ (NSString*) getWorkflowIdForThread:(MPChatThread*) thread
{
    if (thread.entity.entityInfos.count > 0)
    {
        for (MPChatEntityInfo* info in thread.entity.entityInfos)
        {
            if (info.entity_type && [info.entity_type isEqualToString:@"WORKFLOW_STEP"])
                return info.entity_id;
        }
    }
    
    return nil;
}


+ (NSString*) getUserDisplayNameFromUser:(NSString*) userName
{
    NSString* name = nil;
    NSArray* arr = [userName componentsSeparatedByString:@"_"];
    if (arr.count > 1)
    {
        NSString* nameId = [arr lastObject];
        name = [userName stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"_%@", nameId] withString:@""];
    }
    else if (arr.count > 0)
        name = arr[0];
    
    return name;
}


+ (BOOL) isSystemThread:(NSString *)thread_id
{
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    return [member iSMemberCompareSysThread:thread_id];
}



+ (BOOL) isAvatarImageIsDefaultForUser:(NSString*) userProfileImage
{
    return ([[userProfileImage lastPathComponent] caseInsensitiveCompare:Default_UserImage] == NSOrderedSame);
}



+ (NSString*) getSystemThreaduserName:(NSString *)thread_id withDefault:(NSString*)defaultName
{
    MPMember *member = [AppController AppGlobal_GetMemberInfoObj];
    
    NSString* nameName=member.System_thread_id;
    NSString* nameName_im=member.System_im_thread_id;
    
    if ([thread_id isEqualToString:nameName]||[thread_id isEqualToString:nameName_im])
        return NSLocalizedString(@"HomePage_key", nil);
     
     return defaultName;
}

+ (NSString*) getUserHs_Uid:(NSString *)name
{
    
    NSArray* arr = [name componentsSeparatedByString:@"_"];
    if (arr.count > 1)
         return [arr lastObject];
    
    return @"";
}


+ (MPChatUser*) getThreadDesignerHomeStyleIdFromThread:(MPChatThread*)thread withAcsId:(NSString*)AcsId
{
    
    if ([thread.sender.user_id isEqualToString:AcsId]){
        
        return thread.sender;
    }
    
    
    for (MPChatUser* user in thread.recipients.users)
    {
        //if (![user.user_id isEqualToString:loggedInUserId])
        
        if ([user.user_id isEqualToString:AcsId] )
            return user;
    }

    return nil;
}




@end
