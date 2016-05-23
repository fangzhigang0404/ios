/**
 * @file    MPOrderEmptyView.h
 * @brief   the view for no needs.
 * @author  niu
 * @version 1.0
 * @date    2016-03-17
 */

#import <UIKit/UIKit.h>

@interface MPOrderEmptyView : UIView

/// the label for showing information.
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

/// the layout constraint of imageView.
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewY;

/// the imageView for showing image.
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@end
