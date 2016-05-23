/**
 * @file    MPAboutWebViewController.h
 * @brief   the controller of about webview.
 * @author  niu
 * @version 1.0
 * @date    2016-03-29
 */

#import "MPBaseViewController.h"

@interface MPAboutWebViewController : MPBaseViewController

/**
 *  @brief the method for instancetype.
 *
 *  @param titleStr the string for title.
 *
 *  @param fileNameStr the string for fileName.
 *
 *  @return instancetype.
 */
- (instancetype)initWithParm:(NSString *)titleStr
                   withFile:(NSString *)fileNameStr;

@end

