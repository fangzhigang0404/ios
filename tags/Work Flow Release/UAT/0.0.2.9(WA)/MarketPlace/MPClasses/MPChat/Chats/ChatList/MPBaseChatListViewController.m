//
//  ChatListViewController.m
//  tests
//
//  Created by Avinash Mishra on 06/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPBaseChatListViewController.h"
#import "MPChatListCell.h"
#import "MPChatHttpManager.h"
#import "MPChatRoomViewController.h"
#import "MPChatThreads.h"
#import "MPChatThread.h"
#import "MPChatUser.h"
#import "MPChatThreadCell.h"
#import "MPWebSocketManagerBroadcaster.h"
#import "MPChatMessage.h"
#import "MPChatUtility.h"

#define MPGETNEWSYSTEMTHREADID @"MPGetnewthreadid"
#define MPAPPLICATIONBECOMEFRONT @"MPApplicationBecomeFront"
#define MPSSO_LOHO @"MP_SSO_LOHO"

///由于改用了storyBoard初始化TabbarViewController，所有- (instancetype)initWithUserId:(NSString*) userId;方法有待商榷，暂时先用其他方法代替
//============================


#define PageLimit       20

@interface MPBaseChatListViewController () <UITableViewDataSource, UITableViewDelegate, MPChatThreadCellDelegate>
{
    BOOL                                    _isNextPageRequestRunning;
}

@end

@implementation MPBaseChatListViewController


- (instancetype)initWithUserId:(NSString*) userId
{
    if (self == [super init])
    {
        if (userId)
            self.loggedInUserId = userId;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //==========================================
    MPMember * member = [AppController AppGlobal_GetMemberInfoObj];
    self.loggedInUserId = member.acs_member_id;
    //==========================================
    
    _threads = [NSMutableArray array];
    _isNextPageRequestRunning = NO;
    _totalNumberOfThread = -1;
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatListCell" bundle:nil] forCellReuseIdentifier:@"MPChatListCell"];
    [self startActivityIndicator];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self registerHandler];
    [self getFileThreadUnreadCount];
    [self getMemeberThreadsForOffset:0 Limit:PageLimit];
    
    self.tabBarController.tabBar.hidden = NO;
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self unRegisterHandler];
}


- (void) initialiseActivityIndicator
{
//    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.view addSubview:_activityIndicator];
//    _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_activityIndicator attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    NSLog(@"initialiseActivityIndicator:::: %@", NSStringFromCGRect(_activityIndicator.frame));
}

- (void) startActivityIndicator
{
    _activityIndicator.hidden = NO;
    [_activityIndicator startAnimating];
    [self.view bringSubviewToFront:_activityIndicator];
}


- (void) stopActivityIndicator
{
    _activityIndicator.hidden = YES;
    [_activityIndicator stopAnimating];
}



#pragma - -------API calls-----------

- (void) getMemeberThreadsForOffset:(NSUInteger)offset Limit:(NSUInteger)limit
{
    _isNextPageRequestRunning = YES;
    if (offset >= _totalNumberOfThread)
    {
        [self stopActivityIndicator];
        return;
    }
    
   
    
    [[MPChatHttpManager sharedInstance] retrieveMemberThreads:self.loggedInUserId onlyAttachedToFile:[self isEntityTypeFile] withOffset:offset andLimit:limit success:^(MPChatThreads* threads)
    {
        
            [self stopActivityIndicator];

            if ([[threads numThreads] integerValue] > 0)
              _totalNumberOfThread = [[threads numThreads] integerValue];
        
            if (offset > 0)
            {
                [self appendThreadsinEnd:threads.threads];
            }
            else
            {
                [self clearThreadsAndReloadThreads:threads.threads];
            }
            _isNextPageRequestRunning = NO;

       
    }failure:^(NSError* err)
    {
        [self stopActivityIndicator];
        _isNextPageRequestRunning = NO;
    }];
}


- (void) getFileThreadUnreadCount
{
    [[MPChatHttpManager sharedInstance] retrieveMemberUnreadMessageCount:self.loggedInUserId needAllMessages:NO success:^(NSInteger count)
    {
        [self updateBubbleWithUnreadCount:count];
        
    }
    failure:^(NSError *error)
    {
        [self updateBubbleWithUnreadCount:0];
    }];
    
}


- (BOOL) isEntityTypeFile
{
    return NO;
}


#pragma - -------UITableViewDelegate/dataSource Methods-----------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _threads.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPChatListCell* cell = (MPChatListCell*)[tableView dequeueReusableCellWithIdentifier:@"MPChatListCell"];
  
    cell.delegate = self;
    [cell updateUIWithIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_threads.count > 0)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        MPChatThread* thread = [_threads objectAtIndex:indexPath.row];
        
        MPChatUser* user = [MPChatUtility getComplimentryUserFromThread:thread withLoginUserId:self.loggedInUserId];
        NSString* assetId = [MPChatUtility getAssetIdFromThread:thread];
        MPChatRoomViewController* ctrl = [[MPChatRoomViewController alloc] initWithThread:thread.thread_id withReceiverId:user.user_id withReceiverName:user.name withAssetId:assetId loggedInUserId:self.loggedInUserId];

        ctrl.currentStepId = [MPChatUtility getWorkflowIdForThread:thread];
        NSLog(@"ctrl.currentStepId=%@",ctrl.currentStepId);
        ctrl.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == (_threads.count - 1))
    {
        if (!_isNextPageRequestRunning)
            [self getMemeberThreadsForOffset:_threads.count Limit:PageLimit];
    }
}


#pragma - -------MPChatThreadCellDelegate Methods-----------


- (BOOL) isLoggedInUserIsDesigner
{
    return [[MPMember shareMember] MemberIsDesignerMode];
}


- (MPChatUser*) getReciepientUserserForIndex:(NSUInteger) index
{
    MPChatThread* thread = [self getChatThreadForIndex:index];
    return [MPChatUtility getComplimentryUserFromThread:thread withLoginUserId:self.loggedInUserId];
}


- (MPChatThread*) getChatThreadForIndex:(NSUInteger) index
{
    if (index < _threads.count)
        return [_threads objectAtIndex:index];
    
    return nil;
}


- (void) clearThreadsAndReloadThreads:(NSArray*)inThread
{
    _threads = [NSMutableArray arrayWithArray:inThread];
    [_tableView reloadData];
}


- (void) insertThreadsAtStart:(NSArray*)inThreads
{
    if (inThreads.count > 0)
    {
//        NSLog(@"Start addMessages Start");
        
        NSMutableArray* indexPathsArray = [NSMutableArray array];
        for (int i = 0; i < inThreads.count; ++i)
        {
            [indexPathsArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
        }
        
        [_threads insertObjects:inThreads atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, inThreads.count)]];
        
        
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        
//        NSLog(@"End addMessages End");
        
        
              
        
    }
}


- (void) appendThreadsinEnd:(NSArray*)inThread
{
    if (inThread.count > 0)
    {
//        NSLog(@"Start insertMessages Start");
        
        NSUInteger count = _threads.count;
        NSMutableArray* indexPathsArray = [NSMutableArray array];
        for (int i = 0; i < inThread.count; ++i)
        {
            [indexPathsArray addObject:[NSIndexPath indexPathForRow:(count + i) inSection:0]];
        }
        
        [_threads insertObjects:inThread atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(_threads.count, inThread.count)]];
        
        [_tableView beginUpdates];
        [_tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationNone];
        [_tableView endUpdates];
        
//        NSLog(@"End insertMessages End");
    }
}


# pragma - ------Register Functions------

- (void) registerHandler
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageGotFromNotification:) name:MPCHATNEWMESSAGENOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSystemName) name:MPGETNEWSYSTEMTHREADID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retryMessage) name:MPAPPLICATIONBECOMEFRONT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateQrButton) name:MPSSO_LOHO object:nil];
}

- (void)updateQrButton {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPSSO_LOHO object:nil];
}

-(void)changeSystemName
{
    [_tableView reloadData];
}
- (void) unRegisterHandler
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) messageGotFromNotification:(NSNotification*)msgNotification
{
    // un use.
    //MPChatMessage* message = (MPChatMessage*)msgNotification.object;
    [self getMemeberThreadsForOffset:0 Limit:PageLimit];
    [self getFileThreadUnreadCount];
}
-(void)retryMessage
{
    if (self) {
        [self getMemeberThreadsForOffset:0 Limit:PageLimit];
    }
}


@end
