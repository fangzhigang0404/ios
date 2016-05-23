/**
 * @file    MPDecoListCollectionViewCell.h
 * @brief   the view for cell.
 * @author  niu
 * @version 1.0
 * @date    2016-02-17
 */

#import <UIKit/UIKit.h>

@class MPDecorationNeedModel;

@protocol MPDecoListCollectionViewCellDelegate <NSObject>

/**
 *  @brief the method for get header view count.
 *
 *  @param index the index for model in datasource.
 *
 *  @return NSInteger header view count.
 */
- (NSInteger)getDecoListHeaderCountForIndex:(NSUInteger)index;

/**
 *  @brief the method for get tableView section.
 *
 *  @param section the section in tableView.
 *
 *  @return NSInteger tableView section count.
 */
- (NSInteger)showDecoInfoWithSection:(NSInteger)section;

@end

@interface MPDecoListCollectionViewCell : UICollectionViewCell

/// delegate.
@property (nonatomic, assign) id<MPDecoListCollectionViewCellDelegate>delegate;

/**
 *  @brief the method for updating view.
 *
 *  @param index the index for model in datasource.
 *
 *  @return void nil.
 */
- (void)updateCellForIndex:(NSUInteger)index;

@end
