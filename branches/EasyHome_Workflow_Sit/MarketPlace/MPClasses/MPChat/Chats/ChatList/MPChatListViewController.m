//
//  ChatListViewController.m
//  tests
//
//  Created by Avinash Mishra on 06/02/16.
//  Copyright © 2016 Avinash Mishra. All rights reserved.
//

#import "MPChatHttpManager.h"
#import "MPChatRoomViewController.h"
#import "MPChatListViewController.h"
#import "MPUIUtility.h"
#import "MPImageChatListViewController.h"
#import "MPChatThreads.h"
#import "MPChatThread.h"
#import "MPChatUser.h"
#import "MPChatRecipients.h"
#import "MPChatListCell.h"
#import "MPChatThreadCell.h"
#import "MPQRCodeReader.h"
#import "MPQRCodeTool.h"

#define QR_BUTTON_TAG 963

@interface MPChatListViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MPChatListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpNavigationBar];
    _tableView.backgroundView.backgroundColor = [UIColor redColor];
    [_tableView registerNib:[UINib nibWithNibName:@"MPChatListCell" bundle:nil] forCellReuseIdentifier:@"MPChatListCell"];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MPQRCodeTool checkQRBtn:[self.view viewWithTag:QR_BUTTON_TAG]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void) setUpNavigationBar
{
    /// create qr read button
    [self createQRButton];
    
    [self.rightButton setImage:[UIImage imageNamed:@"fileChat"] forState:UIControlStateNormal];
    self.titleLabel.text = NSLocalizedString(@"Thread_List", @"Thread List");
    self.leftButton.hidden = YES;
}

- (void)createQRButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(SCREEN_WIDTH - 85, 20, 50, 44);
    [button setImage:[UIImage imageNamed:QR_SAOYISAO] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(qrReanerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = QR_BUTTON_TAG;
    [self.navgationImageview addSubview:button];
}

- (void)qrReanerButtonAction:(UIButton *)button {
    MPQRCodeReader *redader = [[MPQRCodeReader alloc] init];
    WS(weakSelf);
    redader.dict = ^(NSDictionary *dict){
        [MPQRCodeTool checkQRWithViewController:weakSelf dict:dict];
    };
    
    if ([MPQRCodeTool checkCameraEnable]) {
        [self customPushViewController:redader animated:YES];
    }
}

#pragma - -------UITableViewDelegate/UITableViewDataSource Methods-----------

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
    cell.backgroundColor = [UIColor clearColor];
    [cell updateUIWithIndex:indexPath.row];
    [MPUIUtility setSelectionColorForCell:cell color:[UIColor colorWithRed:236/255.0 green:242/255.0 blue:246/255.0 alpha:1.0]];
    return cell;
}


#pragma - -------MPChatThreadCellDelegate Methods-----------


- (void) imageTappedOnCellForIndex:(NSUInteger) index
{
    
}


#pragma mark - navigation methods hookup

- (void)tapOnRightButton:(id)sender
{
    MPImageChatListViewController* ctrl = [[MPImageChatListViewController alloc] initWithNibName:@"MPImageChatListViewController" bundle:nil];
    ctrl.loggedInUserId = self.loggedInUserId;
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}


@end
