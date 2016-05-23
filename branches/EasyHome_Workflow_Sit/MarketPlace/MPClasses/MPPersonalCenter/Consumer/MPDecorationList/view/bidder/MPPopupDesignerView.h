/**
 * @file    MPPopupView.h
 * @brief   the view for bidder designer.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import <Foundation/Foundation.h>
#import "MPBidderDesignerInfoView.h"

@protocol MPPopupDesignerViewDelegate <NSObject>

@end

@class MPDecorationNeedModel;
@interface MPPopupDesignerView : NSObject

/**
 *  @brief the method for showing bidder designer view.
 *
 *  @param view the parent view for  popup view.
 *
 *  @param model the model for bidder designer.
 *
 *  @param needModel the model for the decoretion.
 *
 *  @param index the index for designer in bidders.
 *
 *  @param delegate the delegate for the NSObject.
 *
 *  @param animated reserve param.
 *
 *  @return void nil.
 */
+ (void)showBidderDesignerInfoAddTo:(UIView *)view
                              model:(MPDecorationBidderModel *)model
                          needModel:(MPDecorationNeedModel *)needModel
                              index:(NSInteger)index
                           delegate:(id)delegate
                           animated:(BOOL)animated;

/**
 *  @brief the method for hiding bidder designer view.
 *
 *  @param animated reserve param.
 *
 *  @return void nil.
 */
+ (void)hideAllViewAnimated:(BOOL)animated;


@end
