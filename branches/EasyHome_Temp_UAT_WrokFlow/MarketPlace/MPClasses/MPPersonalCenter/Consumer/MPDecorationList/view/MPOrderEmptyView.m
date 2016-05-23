/**
 * @file    MPOrderEmptyView.m
 * @brief   the view for no needs.
 * @author  niu
 * @version 1.0
 * @date    2016-03-17
 */

#import "MPOrderEmptyView.h"

@implementation MPOrderEmptyView

- (void)awakeFromNib {
    self.imageViewY.constant = (200/667.0) * SCREEN_HEIGHT;
}

@end
