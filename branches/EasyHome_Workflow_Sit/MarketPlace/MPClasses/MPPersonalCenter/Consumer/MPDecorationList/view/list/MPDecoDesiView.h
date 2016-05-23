/**
 * @file    MPDecoDesiView.h
 * @brief   the view for bidder designer.
 * @author  niu
 * @version 1.0
 * @date    2016-02-23
 */

#import <UIKit/UIKit.h>

@class MPDecorationBidderModel;
@class MPDecorationNeedModel;
@protocol MPDecoDesiViewDelegate <NSObject>

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPDecorationNeedModel model class.
 */
- (MPDecorationNeedModel *)getBidderDesignerModelAtIndex:(NSInteger)index;

/**
 *  @brief the method for click bidder designer.
 *
 *  @param model the model for bidder designer.
 *
 *  @param needModel the model for decoration.
 *
 *  @return void nil.
 */
- (void)didSeletedDesignerAtIndex:(NSInteger)index
                      bidderModel:(MPDecorationBidderModel *)model
                        needModel:(MPDecorationNeedModel *)needModel;

@end

@interface MPDecoDesiView : UIView

/// delegate.
@property (nonatomic, assign) id<MPDecoDesiViewDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)updateViewAtIndex:(NSInteger)index;

@end