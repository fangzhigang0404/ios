/**
 * @file    MPFindDesignersTableViewCell.h
 * @brief   the view for cell.
 * @author  Xue
 * @version 1.0
 * @date    2016-02-17
 */

#import <UIKit/UIKit.h>
@class MPDesignerInfoModel;

@protocol MPFindDesignersTableViewCellDelegate <NSObject>

@required

-(MPDesignerInfoModel *) getDesignerLibraryModelForIndex:(NSUInteger) index;
-(void) startChatWithDesignerForIndex:(NSUInteger) index;
-(void) followDesignerForIndex:(NSUInteger) index;

@end

@interface MPFindDesignersTableViewCell : UITableViewCell
@property(assign,nonatomic) id<MPFindDesignersTableViewCellDelegate> delegate;

-(void) updateCellForIndex:(NSUInteger) index;
@end
