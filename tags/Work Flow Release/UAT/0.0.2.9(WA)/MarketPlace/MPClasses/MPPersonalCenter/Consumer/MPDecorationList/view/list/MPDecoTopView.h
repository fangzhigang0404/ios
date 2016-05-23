/**
 * @file    MPDecoTopView.h
 * @brief   the view for cell.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import <UIKit/UIKit.h>

@class MPDecorationNeedModel;
@protocol MPDecoTopViewDelegate <NSObject>

/**
 *  @brief the method for getting model.
 *
 *  @param index the index for model in datasource.
 *
 *  @return MPDecorationNeedModel model class.
 */
- (MPDecorationNeedModel *)getNeedModelAtIndex:(NSInteger)index;

/**
 *  @brief the method for click.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)didSeletedTopView:(NSInteger)index;

/**
 *  @brief the method for edit decoration.
 *
 *  @param need_id the id for need.
 *
 *  @param index the index for for model in datasource.
 *
 *  @return void nil.
 */
- (void)editDecorationWithNeedId:(NSString *)need_id
                           index:(NSInteger)index;

@end

@interface MPDecoTopView : UIView

/// show button.
@property (weak, nonatomic) IBOutlet UIButton *showButton;

/// delegate.
@property (nonatomic, assign) id<MPDecoTopViewDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @param row the row for collectionView.
 *
 *  @return void nil.
 */
- (void)updateViewAtIndex:(NSInteger)index
            collectionRow:(NSInteger)row;

@end
