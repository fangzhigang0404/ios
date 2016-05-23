/**
 * @file    MPUIImageView.h
 * @brief   the Custom View of HeadImage.
 * @author  Jiao
 * @version 1.0
 * @date    2015-12-30
 *
 */

#import <UIKit/UIKit.h>

@interface MPUIImageView : UIImageView

/// the image of view.
//@property (strong , nonatomic) UIImage *image;

/**
 *  @brief init method of this view.
 *
 *  @param frame the frame of the view.
 *
 *  @param radius the radius of every corner in view.
 *
 *  @param borderWidth the width of border of view.
 *
 *  @return instancetype the instance of MPUIImageView.
 */
- (instancetype)initWithFrame:(CGRect)frame withRadius:(CGFloat)radius withBoderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color;

/**
 *  @brief init method of this view if need autoLayout.
 *
 *  @param radius the radius of every corner in view.
 *
 *  @param borderWidth the width of border of view.
 *
 *  @return instancetype the instance of MPUIImageView.
 */
- (instancetype)initWithRadius:(CGFloat)radius withBoderWidth:(CGFloat)borderWidth andBorderColor:(UIColor *)color;

@end

