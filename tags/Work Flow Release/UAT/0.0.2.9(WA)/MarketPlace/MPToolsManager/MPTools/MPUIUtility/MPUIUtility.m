//
//  MPUIUtility.m
//  MarketPlace
//
//  Created by Arnav Jain on 17/02/16.
//  Copyright © 2016 xuezy. All rights reserved.
//

#import "MPUIUtility.h"

@implementation MPUIUtility

+ (UIAlertController *)createSimpleAlertWithTitle:(NSString *)title
                                      withMessage:(NSString *)message
                                  withActionTitle:(NSString *)actionTitle
{
    // Title and message mandatory
    assert(title);
    assert(message);

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    NSString *okText; 
    
    if (!actionTitle)
        okText = NSLocalizedString(@"photo_taker_alert_view_ok", nil);
    else
        okText = actionTitle;

    UIAlertAction* action = [UIAlertAction actionWithTitle:okText
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action) {}];

    [alert addAction:action];

    return alert;
}

+ (UIAlertController *)createSimpleAlertWithTitle:(NSString *)title
                                      withMessage:(NSString *)message
                                  withActionTitle:(NSString *)actionTitle
                                withActionHandler:(MPAlertHandler)actionHandler;
{
    // Title and message mandatory, along with the action handler
    assert(title);
    assert(message);
    assert(actionHandler);

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];

    NSString *okText; 
    
    if (!actionTitle)
        okText = NSLocalizedString(@"photo_taker_alert_view_ok", nil);
    else
        okText = actionTitle;

    UIAlertAction* action = [UIAlertAction actionWithTitle:okText
                                                     style:UIAlertActionStyleDefault
                                                   handler:actionHandler];

    [alert addAction:action];

    return alert;
}


+ (void) setSelectionColorForCell:(UITableViewCell *)cell
                            color:(UIColor *)color
{
    if (cell)
    {
        cell.backgroundView = nil;
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = color;
        [cell setSelectedBackgroundView:bgColorView];
    }
}


+ (UIView *) getBadgeViewWithBaddesCount:(NSUInteger)count
                                userFont:(UIFont *)font
{
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.backgroundColor = [UIColor redColor];
    badgeLabel.clipsToBounds = YES;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.font = font;
    
    NSString* text = [NSString stringWithFormat:@"%lu%@", (unsigned long)((count > 99) ? 99 : count), (count > 99) ? @"+" : @""];
    NSDictionary *userAttributes = @{NSFontAttributeName: font};
    const CGSize textSize = [text sizeWithAttributes: userAttributes];
    CGFloat width = (textSize.width > textSize.height) ? textSize.width : textSize.height;
    badgeLabel.frame = CGRectMake(0, 0, lround(width), lround(width));
    badgeLabel.text = text;
    badgeLabel.layer.cornerRadius = badgeLabel.frame.size.width / 2;

    return badgeLabel;
}


+ (UIImage *)imageByRenderingView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snapshotImage;
}

@end
