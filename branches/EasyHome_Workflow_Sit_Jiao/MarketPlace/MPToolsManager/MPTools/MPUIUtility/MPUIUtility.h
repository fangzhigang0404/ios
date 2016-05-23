//
//  MPUIUtility.h
//  MarketPlace
//
//  Created by Arnav Jain on 17/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPUIUtility : NSObject

typedef void (^MPAlertHandler)(UIAlertAction *action);

+ (UIAlertController *)createSimpleAlertWithTitle:(NSString *)title
                                      withMessage:(NSString *)message
                                  withActionTitle:(NSString *)actionTitle;

+ (UIAlertController *)createSimpleAlertWithTitle:(NSString *)title
                                      withMessage:(NSString *)message
                                  withActionTitle:(NSString *)actionTitle
                                withActionHandler:(MPAlertHandler)actionHandler;

+ (void) setSelectionColorForCell:(UITableViewCell *)cell
                        color:(UIColor *)color;

+ (UIView *) getBadgeViewWithBaddesCount:(NSUInteger)count
                 userFont:(UIFont *)font;

+ (UIImage *)imageByRenderingView:(UIView *)view;


@end
