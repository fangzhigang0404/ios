/**
 * @file    MPBidderDesignerInfoView.h
 * @brief   the view for bidder designer.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MPBidderButtonIndex)
{
    MPBidderButtonIndexMeasure = 1, //!< choose.
    MPBidderButtonIndexChat,        //!< chat.
    MPBidderButtonIndexRefuse,      //!< refuse.
    MPBidderButtonIndexClose,       //!< close.
    MPBidderButtonIndexHeader       //!< detail.
};

@class MPDecorationNeedModel;
@class MPDecorationBidderModel;
@protocol MPBidderDesignerInfoViewDelegate <NSObject>

/**
 *  @brief the method for click action.
 *
 *  @param buttonIndex the index for button.
 *
 *  @param index the index for bidder designer in bidders.
 *
 *  @param model the model for designer.
 *
 *  @param needModel the index for decoration.
 *
 *  @return void nil.
 */
- (void)clickedButtonAtIndex:(MPBidderButtonIndex)buttonIndex
                       index:(NSInteger)index
                 bidderModel:(MPDecorationBidderModel *)model
                   needModel:(MPDecorationNeedModel *)needModel;

@end

@interface MPBidderDesignerInfoView : UIView

/// delegate.
@property (nonatomic, assign) id<MPBidderDesignerInfoViewDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param model the model for designer.
 *
 *  @param index the index for bidder designer in bidders.
 *
 *  @param needModel the index for decoration.
 *
 *  @return void nil.
 */
- (void)updateViewWithModel:(MPDecorationBidderModel *)model
                      index:(NSInteger)index
                  needModel:(MPDecorationNeedModel *)needModel;

@end