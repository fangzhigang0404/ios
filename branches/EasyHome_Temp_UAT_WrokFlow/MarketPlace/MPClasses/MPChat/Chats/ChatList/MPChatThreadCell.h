/**
 * @file    MPChatThreadCell.h
 * @brief   cell of thread in chat list.
 * @author  Avinash Mishra
 * @version 1.0
 * @date    2016-02-16
 *
 */

#import <UIKit/UIKit.h>

@class MPChatThread;
@class MPChatUser;

@protocol MPChatThreadCellDelegate <NSObject>
/**
 *  @brief get chat thread for index.
 *
 *  @param index The index is the number of the row in tab used to get the thread info.
 *
 *  @return MPChatThread.
 */
- (MPChatThread*) getChatThreadForIndex:(NSUInteger) index;
/**
 *  @brief get recipient users for index.
 *
 *  @param index The index is the number of the row in tab used to get the thread info.
 *
 *  @return MPChatThread.
 */
- (MPChatUser*) getReciepientUserserForIndex:(NSUInteger) index;
/**
 *  @brief analyze the mode of the log in user.
 *
 *  @param nil.
 *
 *  @return BOOL.
 */
- (BOOL) isLoggedInUserIsDesigner;

@optional
/**
 *  @brief Image tapped on cell.
 *
 *  @param index The index is the number of the row in tab.
 *
 *  @return void nil.
 */

- (void) imageTappedOnCellForIndex:(NSUInteger) index;

@end


@interface MPChatThreadCell : UITableViewCell
{
    NSUInteger                          _index; //!< _index The _index is number of cell.
    
    __weak IBOutlet UILabel*            _name; //!< _name The _name is name label.
    __weak IBOutlet UILabel*            _description; //!< _description The _description is description label.
    __weak IBOutlet UILabel*            _timeStamp; //!< _timeStamp The _timeStamp is time stamp label.
    __weak IBOutlet UILabel*            _assetStepLabel; //!< _assetStepLabel The _assetStepLabel is asset step label.
    __weak IBOutlet UILabel*            _messageUnreadCount; //!< _messageUnreadCount The _messageUnreadCount is message unread count label .
    __weak IBOutlet UIImageView*        _chatImage; //!< _chatImage The _chatImage
}

@property (nonatomic, weak) id <MPChatThreadCellDelegate>  delegate;
/**
 *  @brief update cell with index.
 *
 *  @param index The index is the number of the row in tab used to update the cell.
 *
 *  @return void nil.
 */
- (void) updateUIWithIndex:(NSUInteger) index;
/**
 *  @brief update the image on cell.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) updateImageForCell;

@end
