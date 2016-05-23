/**
 * @file    MPAlertView.h
 * @brief   MPAlertView
 * @author  niu
 * @version 1.0
 * @date    2016-02-22
 */

#import "MPAlertView.h"

@interface MPAlertView ()<UIAlertViewDelegate>

@property (nonatomic, copy) void (^sureKey)();
@property (nonatomic, copy) void (^cancelKey)();

@end

typedef NS_ENUM(NSInteger, MPAlertViewType)
{
    MPAlertViewTypeError                    = 0,    //!< 0. net error.
    MPAlertViewTypeSureKey,                         //!< 1. sureButton.
    MPAlertViewTypeTitleAndSureKey,                 //!< 2. sureButton and title.
    MPAlertViewTypeSureAndCancelKey,                //!< 3. sureButton and cancelButton.
    MPAlertViewTypeTitleAndSureKeyCancelKey,        //!< 4. sureButton and cancelButton and title.
    MPAlertViewTypeDIY,                             //!< 5. DIY.
    MPAlertViewTypeAutoDisAppear,                   //!< 6. auto dismiss.
    MPAlertViewTypeParameterError                   //!< 7. param error,nil.
};

typedef NS_ENUM(NSInteger, MPAlertViewTag)
{
    MPAlertViewTagError                     = 110,  //!< 0. net error.
    MPAlertViewTagSureKey,                          //!< 1. sureButton.
    MPAlertViewTagTitleAndSureKey,                  //!< 2. sureButton and title.
    MPAlertViewTagSureAndCancelKey,                 //!< 3. sureButton and cancelButton.
    MPAlertViewTagTitleAndSureAndCancelKey,         //!< 4. sureButton and cancelButton and title.
    MPAlertViewTagDIY,                              //!< 5. DIY.
    MPAlertViewTagAutoDisAppear,                    //!< 6. auto dismiss.
    MPAlertViewTagParameterError                    //!< 7. param error,nil.
};

@implementation MPAlertView

+ (MPAlertView *)shareManager {
    
    return [[self alloc] init];
}


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static MPAlertView * manager;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [super allocWithZone:zone];
    });
    
    return manager;
}

+ (void)showAlertForNetError {
    
    [[self shareManager] showAlertViewWithMessage:NSLocalizedString(@"just_tip_net_error", nil)
                                              tag:MPAlertViewTagError
                                             type:MPAlertViewTypeError
                                              DIY:nil];
}

+ (void)showAlertForParameterError {
    
    [[self shareManager] showAlertViewWithMessage:NSLocalizedString(@"just_tip_tishi_Parameter_error", nil)
                                              tag:MPAlertViewTagParameterError
                                             type:MPAlertViewTypeParameterError
                                              DIY:nil];
}

+ (void)showAlertWithMessage:(NSString *)message
                     sureKey:(void(^) ())surekey {
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagSureKey
                                             type:MPAlertViewTypeSureKey
                                              DIY:nil];
    [self shareManager].sureKey = surekey;
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   sureKey:(void(^) ())surekey {
    
    if (title == nil) {
        title = @"";
    }
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagTitleAndSureKey
                                             type:MPAlertViewTypeTitleAndSureKey
                                              DIY:@{@"title":title}];
    [self shareManager].sureKey = surekey;
}

+ (void)showAlertWithMessage:(NSString *)message
                     sureKey:(void(^) ())surekey
                   cancelKey:(void(^) ())cancelKey {
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagSureAndCancelKey
                                             type:MPAlertViewTypeSureAndCancelKey
                                              DIY:nil];
    [self shareManager].sureKey   = surekey;
    [self shareManager].cancelKey = cancelKey;
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                   sureKey:(void(^) ())surekey
                 cancelKey:(void(^) ())cancelKey {
    
    if (title == nil) {
        title = @"";
    }
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagTitleAndSureAndCancelKey
                                             type:MPAlertViewTypeTitleAndSureKeyCancelKey
                                              DIY:@{@"title":title}];
    [self shareManager].sureKey   = surekey;
    [self shareManager].cancelKey = cancelKey;
}

+ (void)showAlertWithTitle:(NSString*)title
                   message:(NSString *)message
            cancelKeyTitle:(NSString *)cancelKeyTitle
             rightKeyTitle:(NSString *)rightKeyTitle
                  rightKey:(void(^) ())rightKey
                 cancelKey:(void(^) ())cancelkey {
    
    if (title          == nil) title          = @"";
    if (cancelKeyTitle == nil) cancelKeyTitle = @"";
    if (rightKeyTitle  == nil) rightKeyTitle  = @"";
    
    NSDictionary *parameter = @{@"cancelKey" : cancelKeyTitle,
                                @"rightKey"  : rightKeyTitle,
                                @"title"     : title};
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagDIY
                                             type:MPAlertViewTypeDIY
                                              DIY:parameter];
    [self shareManager].sureKey   = rightKey;
    [self shareManager].cancelKey = cancelkey;
}

+ (void)showAlertWithMessage:(NSString *)message
     autoDisappearAfterDelay:(NSTimeInterval)delay {
    
    [[self shareManager] showAlertViewWithMessage:message
                                              tag:MPAlertViewTagAutoDisAppear
                                             type:MPAlertViewTypeAutoDisAppear
                                              DIY:@{@"delay":@(delay)}];
}

- (void)showAlertViewWithMessage:(NSString *)message
                             tag:(MPAlertViewTag)tag
                            type:(MPAlertViewType)type
                             DIY:(NSDictionary *)parameter{
    
    NSString *cancelTitle = nil;
    NSString *sureTitle   = nil;
    NSString *title       = nil;
    
    switch (tag) {
        case MPAlertViewTagSureKey:{
            sureTitle   = NSLocalizedString(@"OK_Key", nil);
            title       = NSLocalizedString(@"just_tip_tishi", nil);
            break;
        }
            
        case MPAlertViewTagSureAndCancelKey:{
            sureTitle   = NSLocalizedString(@"OK_Key", nil);
            cancelTitle = NSLocalizedString(@"cancel_Key", nil);
            title       = NSLocalizedString(@"just_tip_tishi", nil);
            break;
        }
            
        case MPAlertViewTagDIY: {
            sureTitle   = parameter[@"rightKey"];
            cancelTitle = parameter[@"cancelKey"];
            title       = parameter[@"title"];
            
            if (sureTitle.length   == 0) sureTitle   = nil;
            if (cancelTitle.length == 0) cancelTitle = nil;
            if (title.length       == 0) title       = nil;
            break;
        }
            
        case MPAlertViewTagAutoDisAppear: {
            break;
        }
            
        case MPAlertViewTagTitleAndSureKey: {
            sureTitle  = NSLocalizedString(@"OK_Key", nil);
            title      = parameter[@"title"];
            
            if (title.length == 0) title = nil;
            break;
        }
            
        case MPAlertViewTagTitleAndSureAndCancelKey: {
            title       = parameter[@"title"];
            sureTitle   = NSLocalizedString(@"OK_Key", nil);
            cancelTitle = NSLocalizedString(@"cancel_Key", nil);
            if (title.length == 0) title = nil;
            break;
        }
            
        case MPAlertViewTagError: {
            sureTitle   = NSLocalizedString(@"OK_Key", nil);
            break;
        }
        
        case MPAlertViewTagParameterError: {
            sureTitle   = NSLocalizedString(@"OK_Key", nil);
            break;
        }
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle : title
                                message : message
                               delegate : self
                      cancelButtonTitle : cancelTitle
                      otherButtonTitles : sureTitle,nil];
    alert.tag = tag;
    [alert show];
    
    if (alert.tag == MPAlertViewTagAutoDisAppear) {
        [self performSelector:@selector(alertAutoDisappear:)
                   withObject:alert
                   afterDelay:[parameter[@"delay"] doubleValue]];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == MPAlertViewTagSureKey                          ||
        alertView.tag == MPAlertViewTagTitleAndSureKey
        ) {
        if (self.sureKey) self.sureKey();
    }
    else if (alertView.tag == MPAlertViewTagSureAndCancelKey            ||
             alertView.tag == MPAlertViewTagDIY                         ||
             alertView.tag == MPAlertViewTagTitleAndSureAndCancelKey
             ) {
        
        if (buttonIndex == 0) {
            if (self.cancelKey) self.cancelKey();
        } else {
            if (self.sureKey) self.sureKey();
        }
    }
}

#pragma mark - alertAutoDisappear
- (void)alertAutoDisappear:(UIAlertView *)alert {
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
