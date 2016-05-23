//
//  ChatViewCell.h
//  tests
//
//  Created by Avinash Mishra on 02/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPChatMessage.h"


@class MPChatMessage;

@protocol MPChatViewCellDelegate <NSObject>
/**
 *  @brief child cell UI action.
 *
 *  @param index The index is the number of cell.
 *
 *  @return void nil.
 */
- (void) onCellChildUIActionForIndex:(NSUInteger) index;
/**
 *  @brief date change.
 *
 *  @param index The index is the number of cell.
 *
 *  @return void nil.
 */
- (BOOL) isDateChageForIndex:(NSUInteger) index;
/**
 *  @brief is cell is not for current logged in user.
 *
 *  @param index The index is the number of cell.
 *
 *  @return BOOL.
 */
- (BOOL) isCellIsNotForCurrentLoggedInUser:(NSUInteger) index;
/**
 *  @brief get logged in member id.
 *
 *  @return NSString.
 */
- (NSString*) getLoggedInMemberId;
/**
 *  @brief get cell model.
 *
 *  @param index The index is the number of cell.
 *
 *  @return MPChatMessage.
 */
- (MPChatMessage*) getCellModelForIndex:(NSUInteger) index;

@optional
/**
 *  @brief is logged in user or designer.
 *
 *  @return BOOL.
 */
- (BOOL) isLoggedInUserIsDesigner;
/**
 *  @brief is the audio file playing or not.
 *
 *  @param index The index is the number of cell.
 *
 *  @return BOOL.
 */
- (BOOL) isPlayingForIndex:(NSUInteger) index;
/**
 *  @brief get audio file playing progress.
 *
 *  @param index The index is the number of cell.
 *
 *  @return NSInteger progress.
 */
- (NSInteger) getProgressForIndex:(NSUInteger) index;
/**
 *  @brief get audio message duration.
 *
 *  @param index The index is the number of cell.
 *
 *  @return NSInteger duration.
 */
- (NSInteger) getMessageDurationForIndex:(NSUInteger) index;

@end



@interface MPChatViewCell : UITableViewCell
{
    
    NSUInteger                                  _index;  //!< _index The _index is the number of cell.
    __weak IBOutlet UILabel                     *_msgSendTime; //!<_msgSendTime The _msgSendTime is message send time.
    __weak IBOutlet UILabel                     *_msgSendDate; //!<_msgSendDate The _msgSendDate is message sende date.
    __weak IBOutlet UIImageView                 *_senderImageView; //!<_senderImageView The _senderImageView is sender avatar image view.
    __weak IBOutlet UIView                      *_childView; //!<_childView The _childView is child view of cell.
    __weak IBOutlet UIView                      *_msgSendParent; //!<_msgSendParent The _msgSendParent is the view content message body .

    __weak IBOutlet NSLayoutConstraint          *_senderImageRightConstraint; //!<_senderImageRightConstraint The _senderImageRightConstraint is sender avatar image view right constraint.
    __weak IBOutlet NSLayoutConstraint          *_senderImageLeftConstraint; //!<_senderImageLeftConstraint The _senderImageLeftConstraint is sender avatar image view left constraint.
    __weak IBOutlet NSLayoutConstraint          *_childViewRightConstraint; //!<_childViewRightConstraint The _childViewRightConstraint is child view right constraint.
    __weak IBOutlet NSLayoutConstraint          *_childViewLeftConstraint; //!<_childViewLeftConstraint The _childViewLeftConstraint  is child view left constraint.
 
    __weak IBOutlet NSLayoutConstraint          *_topConstraintForImage; //!<_topConstraintForImage The _topConstraintForImage is top constraint for image.
    __weak IBOutlet NSLayoutConstraint          *_topConstraintForChildView; //!<_topConstraintForChildView The _topConstraintForChildView is top constraint for child view.
 
    __weak IBOutlet NSLayoutConstraint          *_messageSendTimeLeftConstraint; //!<_messageSendTimeLeftConstraint The _messageSendTimeLeftConstraint is message send time label left constraint.
    __weak IBOutlet NSLayoutConstraint          *_messageSendTimeRightConstraint; //!<_messageSendTimeRightConstraint The _messageSendTimeRightConstraint is message send time label right constraint.

}

@property (nonatomic, weak) id <MPChatViewCellDelegate>    delegate;
@property (nonatomic, readonly) NSUInteger                  index;//!< _index The _index is the number of cell.
/**
 *  @brief update sender image.
 *
 *  @return void nil.
 */
- (void) updateSenderImage;
/**
 *  @brief update cell .
 *
 *  @param index The index is the number of cell.
 *
 *  @return void nil.
 */
- (void) updateCellForIndex:(NSUInteger) index;

@end
