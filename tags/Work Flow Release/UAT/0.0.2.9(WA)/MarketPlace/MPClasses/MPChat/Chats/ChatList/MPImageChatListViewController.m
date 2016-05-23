//
//  ChatListViewController.m
//  tests
//
//  Created by Avinash Mishra on 06/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPImageChatListViewController.h"
#import "MPUIUtility.h"
#import "MPImageChatListCell.h"
#import "MPChatHttpManager.h"
#import "MPImageChatRoomViewController.h"
#import "MPChatThreads.h"
#import "MPChatThread.h"
#import "MPChatRecipients.h"
#import "MPChatUser.h"
#import "MPChatThreadCell.h"
#import "MPChatEntityInfos.h"
#import "MPChatEntityInfo.h"
#import "MPChatConversations.h"
#import "MPChatUtility.h"

@interface MPImageChatListViewController () <UITableViewDataSource, UITableViewDelegate, MPChatThreadCellDelegate>
{

}

@end

@implementation MPImageChatListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavigationBar];
    [_tableView registerNib:[UINib nibWithNibName:@"MPImageChatListCell" bundle:nil] forCellReuseIdentifier:@"MPImageChatListCell"];
    [[MPChatHttpManager sharedInstance] retrieveMemberThreads:self.loggedInUserId onlyAttachedToFile:YES withOffset:0 andLimit:20 success:^(MPChatThreads* threads)
    {
        _threads = threads.threads;
        [_tableView reloadData];
    }failure:^(NSError* err)
    {
        
    }];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void) setUpNavigationBar
{
    //self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    
    self.titleLabel.text = NSLocalizedString(@"File_Thread_List", @"File Thread List");
    self.rightButton.hidden = YES;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}


- (BOOL) isEntityTypeFile
{
    return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _threads.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MPImageChatListCell* cell = (MPImageChatListCell*)[tableView dequeueReusableCellWithIdentifier:@"MPImageChatListCell"];
    cell.delegate = self;
    [cell updateUIWithIndex:indexPath.row];
    [MPUIUtility setSelectionColorForCell:cell color:[UIColor colorWithRed:236/255.0 green:242/255.0 blue:246/255.0 alpha:1.0]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MPChatThread* thread = [_threads objectAtIndex:indexPath.row];
    
    NSString* fileId = nil;
    CGPoint pt = CGPointZero;

    if (thread.entity.entityInfos.count > 0)
    {
        fileId = [thread.entity.entityInfos[0] entity_id];
        pt = CGPointMake([[thread.entity.entityInfos[0] x_coordinate] floatValue], [[thread.entity.entityInfos[0] y_coordinate] floatValue]);
    }

    MPChatUser* user = [MPChatUtility getComplimentryUserFromThread:thread withLoginUserId:self.loggedInUserId];
    MPImageChatRoomViewController* ctrl = [[MPImageChatRoomViewController alloc] initWithCloudFile:fileId serverFileURL:[MPChatUtility getFileUrlFromThread:thread] point:pt withReceiverId:user.user_id loggedInUserId:self.loggedInUserId projectInfo:nil];

    ctrl.threadId = thread.thread_id;
    ctrl.recieverUserName = user.name;
    [self.navigationController pushViewController:ctrl animated:YES];
}


#pragma - -------MPChatThreadCellDelegate Methods-----------


- (MPChatThread*) getChatThreadForIndex:(NSUInteger) index
{
    return [_threads objectAtIndex:index];
}


#pragma mark - navigation methods hookup

- (void)tapOnLeftButton:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
