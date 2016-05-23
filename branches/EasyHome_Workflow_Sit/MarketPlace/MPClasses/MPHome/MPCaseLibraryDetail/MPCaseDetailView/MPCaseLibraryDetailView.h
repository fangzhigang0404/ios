/**
 * @file    MPCaseLibraryDetailView.h
 * @brief   MPCaseLibraryDetailView.
 * @author  Xue.
 * @version 1.0
 * @date    2016-02-20
 */

#import <UIKit/UIKit.h>

@class MPCaseModel;
@protocol MPCaseLibraryDetailViewDelegate <NSObject>

/**
 *  @brief the method for judge is not beishu.
 *
 *  @param nil.
 *
 *  @return NSInteger collectiobView items.
 */
- (NSInteger)getCaseDetailCellCount;

/**
 *  @brief the method for push detail.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void)viewCaseDetail;

/**
 *  @brief the method for scroll begin.
 *
 *  @param x num of scroll begin.
 *
 *  @return void nil.
 */
- (void)draggingWithContentOffsetX:(CGFloat)x;


/**
 *  @brief the method for scroll over.
 *
 *  @param x num of scroll over.
 *
 *  @return void nil.
 */
- (void)deceleratingWithContentOffsetX:(CGFloat)x;

@end

@interface MPCaseLibraryDetailView : UIView

@property (nonatomic, weak) id<MPCaseLibraryDetailViewDelegate>delegate;

/**
 *  @brief the method for refresh View.
 *
 *  @param avatar the designer head.
 *
 *  @return void nil.
 */
- (void)refreshCaseLibraryDetailUI:(NSString *)avatar;

@end
