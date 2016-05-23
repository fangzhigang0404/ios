//
//  ChatListViewController.h
//  tests
//
//  Created by Avinash Mishra on 06/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPBaseViewController.h"
#import "MPChatThreadCell.h"

@interface MPBaseChatListViewController : MPBaseViewController <MPChatThreadCellDelegate>
{
    NSMutableArray*                     _threads; //!< _threads The _threads is threads array.
    NSUInteger                          _totalNumberOfThread; //!< _totalNumberOfThread The _totalNumberOfThread is total number of thread.
    
    __weak IBOutlet UITableView*                _tableView; //!<_tableView The _tableView is table view.
    __weak IBOutlet UIActivityIndicatorView*    _activityIndicator; //!<_activityIndicator The _activityIndicator is activityIndicator control.
}

///loggedInUserId The loggedInUserId is logged in user id.
@property (nonatomic, strong) NSString*     loggedInUserId;
/**
 *  @brief the method as UIActivityIndicator start.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) startActivityIndicator;
/**
 *  @brief the method as UIActivityIndicator stop.
 *
 *  @param nil.
 *
 *  @return void nil.
 */
- (void) stopActivityIndicator;
/**
 *  @brief Entity type is not File .
 *
 *  @param nil.
 *
 *  @return BOOL NO.
 */
- (BOOL) isEntityTypeFile;
/**
 *  @brief get memeber threads of the chatroom list.
 *
 *  @param offset The page offset.
 *  @param limit The number of threads to get.
 *
 *  @return void nil.
 */
- (void) getMemeberThreadsForOffset:(NSUInteger)offset Limit:(NSUInteger)limit;
/**
 *  @brief clear tab and reload tab with array.
 *
 *  @param inThread The inThread array is threads storage array.
 *
 *  @return void nil.
 */
- (void) clearThreadsAndReloadThreads:(NSArray*)inThread;
/**
 *  @brief insert threads at start of array.
 *
 *  @param inThread The inThread array is threads storage array.
 *
 *  @return void nil.
 */
- (void) insertThreadsAtStart:(NSArray*)inThread;
/**
 *  @brief append threads at end of array.
 *
 *  @param inThread The inThread array is threads storage array.
 *
 *  @return void nil.
 */
- (void) appendThreadsinEnd:(NSArray*)inThread;

@end
