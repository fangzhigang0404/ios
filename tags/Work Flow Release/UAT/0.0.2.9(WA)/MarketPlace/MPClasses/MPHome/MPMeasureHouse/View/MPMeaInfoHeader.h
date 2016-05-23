/**
 * @file    MPMeaInfoHeader.h
 * @brief   the view of measure.
 * @author  niu
 * @version 1.0
 * @date    2015-02-25
 */

#import <UIKit/UIKit.h>

@protocol MPMeaInfoHeaderDelegate <NSObject>

/**
 *  @brief the method for get decoration name.
 *
 *  @param index the index for model in datasource.
 *
 *  @return NSString decoration name.
 */
- (NSString *)getNeedNameStrAtIndex:(NSInteger)index;

/**
 *  @brief the method for seleted and show decoration.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)seletedAndShowNeedAtIndex:(NSInteger)index;

@end

@interface MPMeaInfoHeader : UIView

/// delegate.
@property (nonatomic, assign) id<MPMeaInfoHeaderDelegate>delegate;

/**
 *  @brief the method for refresh view.
 *
 *  @param index the index for model in datasource.
 *
 *  @param seleted the index for seleted model in datasource.
 *
 *  @return void nil.
 */
- (void)updateMeaInfoHeaderViewAtIndex:(NSInteger)index
                               seleted:(NSInteger)seleted;
@end
